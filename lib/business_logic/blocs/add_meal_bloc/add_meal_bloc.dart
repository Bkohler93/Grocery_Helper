import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/repositories/meal/i_meal_repository.dart';

part 'add_meal_event.dart';
part 'add_meal_state.dart';

class AddMealBloc extends Bloc<AddMealEvent, AddMealState> {
  final IMealRepository _mealRepository;

  AddMealBloc(this._mealRepository) : super(const AddMealState()) {
    on<EditMealNameEvent>(_validateName);
    on<EditIngredientNameEvent>(_validateIngredientName);
    on<EditIngredientQtyEvent>(_validateIngredientQty);
    on<ChangeIngredientCategoryEvent>(_changeIngredientCategory);
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

  FutureOr<void> _validateIngredientName(
      EditIngredientNameEvent event, Emitter<AddMealState> emit) {
    final String name = event.text.toLowerCase();

    if (name.isEmpty || name.startsWith(' ')) {
      emit(state.copyWith(
        ingredientNameErrorText: "Ingredient must have a name.",
      ));
    } else if (name.length > 20) {
      emit(state.copyWith(
        ingredientNameErrorText: "Name cannot be over 20 characters long.",
      ));
    } else {
      emit(state.copyWith(ingredientNameErrorText: "", ingredientName: name));
    }
  }

  FutureOr<void> _validateIngredientQty(EditIngredientQtyEvent event, Emitter<AddMealState> emit) {
    final String qty = event.text.toLowerCase();

    if (qty.length > 10) {
      emit(state.copyWith(
        ingredientQtyErrorText: "Field cannot be over 10 characters long.",
      ));
    } else if (!qty.contains(RegExp(r"^([0-9A-Za-z/.]*)$"))) {
      emit(state.copyWith(
        ingredientQtyErrorText: "Invalid characters found.",
      ));
    } else {
      emit(state.copyWith(ingredientNameErrorText: "", ingredientQty: qty));
    }
  }

  FutureOr<void> _changeIngredientCategory(
      ChangeIngredientCategoryEvent event, Emitter<AddMealState> emit) {
    final String category = event.category.toLowerCase();

    emit(state.copyWith(ingredientCategory: category));
  }

  FutureOr<void> _addIngredient(AddIngredientEvent event, Emitter<AddMealState> emit) {
    if (state.ingredientFieldsComplete()) {
      var newIngredient = GroceryItem.fromRawQty(
        category: state.ingredientCategory,
        name: state.ingredientName,
        rawQty: state.ingredientQty,
      );

      emit(state.copyWith(
        ingredientCategory: "Produce",
        ingredientName: "",
        ingredientQty: '',
        items: [...state.items, newIngredient],
        status: state.nameErrorText == "" ? AddMealStatus.valid : AddMealStatus.invalid,
      ));
    }
  }
}
