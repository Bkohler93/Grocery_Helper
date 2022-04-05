import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_helper_app/business_logic/cubits/cubit/add_ingredient_cubit.dart';
import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/repositories/meal/i_meal_repository.dart';

part 'add_meal_event.dart';
part 'add_meal_state.dart';

class AddMealBloc extends Bloc<AddMealEvent, AddMealState> {
  final IMealRepository mealRepository;
  final AddIngredientCubit _addIngredientCubit;
  late final StreamSubscription<AddIngredientState> _addIngredientStreamSubscription;

  AddMealBloc({required this.mealRepository, required AddIngredientCubit addIngredientCubit})
      : _addIngredientCubit = addIngredientCubit,
        super(const AddMealState()) {
    _addIngredientStreamSubscription = _addIngredientCubit.stream.listen((addIngredientState) {
      if (addIngredientState.status == AddIngredientStatus.add) {
        _addIngredient(addIngredientState, state);
      }
    });

    on<EditMealNameEvent>(_validateName);
  }

  Future<void> _validateName(EditMealNameEvent event, Emitter<AddMealState> emit) async {
    final String name = event.text.toLowerCase();

    try {
      bool nameExists = await mealRepository.mealExists(name);
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

  void _addIngredient(AddIngredientState ingredientState, AddMealState state) {
    var newIngredient = GroceryItem.fromRawQty(
      category: ingredientState.section,
      name: ingredientState.name,
      rawQty: ingredientState.quantity,
    );

    // ignore: invalid_use_of_visible_for_testing_member
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
}
