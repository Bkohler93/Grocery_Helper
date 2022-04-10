import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_helper_app/business_logic/cubits/ingredient_cubit/add_ingredient_cubit.dart';
import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/repositories/meal/i_meal_repository.dart';

part 'add_meal_event.dart';
part 'add_meal_state.dart';

class AddMealBloc extends Bloc<AddMealEvent, AddMealState> {
  final IMealRepository _mealRepository;
  final AddIngredientCubit _addIngredientCubit;
  late final StreamSubscription<AddIngredientState> _addIngredientStreamSubscription;

  AddMealBloc(
      {required IMealRepository mealRepository, required AddIngredientCubit addIngredientCubit})
      : _addIngredientCubit = addIngredientCubit,
        _mealRepository = mealRepository,
        super(const AddMealState()) {
    _addIngredientStreamSubscription = _addIngredientCubit.stream.listen((addIngredientState) {
      if (addIngredientState.status == AddIngredientStatus.add) {
        add(AddIngredientEvent(
          name: addIngredientState.name,
          rawQty: addIngredientState.quantity,
          category: addIngredientState.section,
        ));
      }
    });
    on<InitializeForm>(_reset);
    on<EditMealNameEvent>(_validateName);
    on<DeleteIngredientEvent>(_deleteIngredient);
    on<SaveMealEvent>(_saveMeal);
    on<AddIngredientEvent>(_addIngredient);
  }

  Future<void> _validateName(EditMealNameEvent event, Emitter<AddMealState> emit) async {
    final String name = event.text.toLowerCase();

    try {
      bool nameExists = await _mealRepository.mealExists(name);
      if (nameExists) {
        emit(state.copyWith(
          status: AddMealStatus.invalid,
          nameErrorText: "A meal with that name already exists.",
          mealName: '',
        ));
      } else if (name.length > 30) {
        emit(state.copyWith(
          status: AddMealStatus.invalid,
          nameErrorText: "Meals can have maximum length of 30.",
          mealName: '',
        ));
      } else if (name.isEmpty || name.startsWith(' ')) {
        emit(state.copyWith(
            status: AddMealStatus.invalid, nameErrorText: "Meals must have a name."));
      } else if (state.items.isNotEmpty) {
        emit(state.copyWith(
          status: AddMealStatus.valid,
          mealName: name,
          nameErrorText: '',
        ));
      } else {
        emit(state.copyWith(
          status: AddMealStatus.invalid,
          mealName: name,
          nameErrorText: '',
        ));
      }
    } catch (error) {
      emit(state.copyWith(status: AddMealStatus.error));
    }
  }

  FutureOr<void> _addIngredient(AddIngredientEvent event, Emitter<AddMealState> emit) async {
    var newIngredient = GroceryItem.fromRawQty(
      category: event.category,
      name: event.name,
      rawQty: event.rawQty,
    );

    emit(state.copyWith(
      items: [...state.items, newIngredient],
      status: state.nameErrorText == "" ? AddMealStatus.valid : AddMealStatus.invalid,
    ));
  }

  @override
  Future<void> close() {
    _addIngredientStreamSubscription.cancel();
    return super.close();
  }

  FutureOr<void> _deleteIngredient(DeleteIngredientEvent event, Emitter<AddMealState> emit) {
    GroceryItem itemToRemove = event.groceryItem;

    List<GroceryItem> newList = [];

    for (var item in state.items) {
      if (item.id != itemToRemove.id) {
        newList.add(item);
      }
    }

    emit(state.copyWith(
      items: newList,
    ));
  }

  FutureOr<void> _saveMeal(SaveMealEvent event, Emitter<AddMealState> emit) async {
    try {
      await _mealRepository.insert(state.mealName, state.items);
      emit(state.copyWith(status: AddMealStatus.success, items: [], mealName: ""));
    } catch (error) {
      emit(state.copyWith(status: AddMealStatus.error));
    }
  }

  FutureOr<void> _reset(AddMealEvent event, Emitter<AddMealState> emit) {
    emit(const AddMealState());
  }
}
