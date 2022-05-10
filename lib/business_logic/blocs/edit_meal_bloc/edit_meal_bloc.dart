import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_helper_app/business_logic/cubits/ingredient_cubit/add_ingredient_cubit.dart';
import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/models/meal.dart';
import 'package:grocery_helper_app/data/repositories/meal/i_meal_repository.dart';

part 'edit_meal_event.dart';
part 'edit_meal_state.dart';

class EditMealBloc extends Bloc<EditMealEvent, EditMealState> {
  final IMealRepository _mealRepository;
  final AddIngredientCubit _addIngredientCubit;
  final Meal _meal;
  late final StreamSubscription<AddIngredientState> _addIngredientStreamSubscription;

  EditMealBloc({
    required IMealRepository mealRepository,
    required AddIngredientCubit addIngredientCubit,
    required Meal meal,
  })  : _addIngredientCubit = addIngredientCubit,
        _mealRepository = mealRepository,
        _meal = meal,
        super(EditMealState(mealId: meal.id!)) {
    _addIngredientStreamSubscription = _addIngredientCubit.stream.listen((addIngredientState) {
      if (addIngredientState.status == AddIngredientStatus.add) {
        add(AddIngredientEvent(
          name: addIngredientState.name,
          rawQty: addIngredientState.quantity,
          category: addIngredientState.section,
        ));
      }
    });
    on<EditMealNameEvent>(_validateName);
    on<DeleteIngredientEvent>(_deleteIngredient);
    on<SaveMealEvent>(_saveMeal);
    on<AddIngredientEvent>(_addIngredient);
    on<LoadIngredientsEvent>(_loadIngredients);
  }

  Future<void> _validateName(EditMealNameEvent event, Emitter<EditMealState> emit) async {
    final String name = event.text.toLowerCase();

    try {
      bool nameExists = await _mealRepository.mealExists(name, state.mealId);
      if (nameExists) {
        emit(state.copyWith(
          status: EditMealStatus.invalid,
          nameErrorText: "A meal with that name already exists.",
          mealName: '',
        ));
      } else if (name.length > 30) {
        emit(state.copyWith(
          status: EditMealStatus.invalid,
          nameErrorText: "Meals can have maximum length of 30.",
          mealName: '',
        ));
      } else if (name.isEmpty || name.startsWith(' ')) {
        emit(state.copyWith(
            status: EditMealStatus.invalid, nameErrorText: "Meals must have a name."));
      } else if (state.items.isNotEmpty) {
        emit(state.copyWith(
          status: EditMealStatus.valid,
          mealName: name,
          nameErrorText: '',
        ));
      } else {
        emit(state.copyWith(
          status: EditMealStatus.invalid,
          mealName: name,
          nameErrorText: '',
        ));
      }
    } catch (error) {
      emit(state.copyWith(status: EditMealStatus.error));
    }
  }

  FutureOr<void> _addIngredient(AddIngredientEvent event, Emitter<EditMealState> emit) async {
    var newIngredient = GroceryItem.fromRawQty(
      category: event.category,
      name: event.name,
      rawQty: event.rawQty,
      isChecked: false,
    );

    emit(state.copyWith(
      items: [...state.items, newIngredient],
      status: state.nameErrorText == "" ? EditMealStatus.valid : EditMealStatus.invalid,
    ));
  }

  @override
  Future<void> close() {
    _addIngredientStreamSubscription.cancel();
    return super.close();
  }

  FutureOr<void> _deleteIngredient(DeleteIngredientEvent event, Emitter<EditMealState> emit) {
    GroceryItem itemToRemove = event.groceryItem;

    List<GroceryItem> newList = [];

    for (var item in state.items) {
      if (item.id != itemToRemove.id) {
        newList.add(item);
      }
    }

    emit(state.copyWith(
      items: newList,
      status: EditMealStatus.valid,
    ));
  }

  FutureOr<void> _saveMeal(SaveMealEvent event, Emitter<EditMealState> emit) async {
    try {
      await _mealRepository.updateMeal(state.mealId, state.mealName, state.items);
      emit(state.copyWith(status: EditMealStatus.success, items: [], mealName: ""));
    } catch (error) {
      emit(state.copyWith(status: EditMealStatus.error));
    }
  }

  FutureOr<void> _loadIngredients(LoadIngredientsEvent event, Emitter<EditMealState> emit) async {
    try {
      List<GroceryItem> _items = await _mealRepository.getMealIngredients(mealName: event.mealName);
      emit(state.copyWith(status: EditMealStatus.initial, items: _items, mealName: event.mealName));
    } catch (err) {
      emit(state.copyWith(status: EditMealStatus.error));
    }
  }
}
