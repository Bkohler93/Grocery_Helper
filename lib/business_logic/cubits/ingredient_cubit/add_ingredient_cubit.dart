import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_helper_app/data/models/grocery_item.dart';

part 'add_ingredient_state.dart';

mixin GroceryListAddIngredientCubit on Cubit<AddIngredientState> {}

class AddIngredientCubit extends Cubit<AddIngredientState> with GroceryListAddIngredientCubit {
  AddIngredientCubit() : super(const AddIngredientState());

  void editIngredientName(String text) {
    final String name = text.toLowerCase();

    if (name.isEmpty || name.startsWith(' ')) {
      emit(state.copyWith(
        nameErrorText: "Ingredient must have a name.",
        status: AddIngredientStatus.invalid,
      ));
    } else if (name.length > 20) {
      emit(state.copyWith(
        nameErrorText: "Name cannot be over 20 characters long.",
        status: AddIngredientStatus.invalid,
      ));
    } else {
      emit(state.copyWith(
        nameErrorText: "",
        name: name,
        status: _validateFields(
          quantityErrorText: state.quantityErrorText,
          nameErrorText: '',
          section: state.section,
        ),
      ));
    }
  }

  AddIngredientStatus _validateFields({
    required String quantityErrorText,
    required String nameErrorText,
    required String section,
  }) {
    if (quantityErrorText.isNotEmpty) {
      return AddIngredientStatus.invalid;
    } else if (nameErrorText.isNotEmpty) {
      return AddIngredientStatus.invalid;
    } else if (section.isEmpty) {
      return AddIngredientStatus.invalid;
    } else {
      return AddIngredientStatus.valid;
    }
  }

  void editIngredientQty(String text) {
    final String qty = text.toLowerCase();

    if (qty.length > 10) {
      emit(state.copyWith(
        quantityErrorText: "Field cannot be over 10 characters long.",
        status: AddIngredientStatus.invalid,
      ));
    } else if (!qty.contains(RegExp(r"^([0-9A-Za-z/. ]*)$"))) {
      emit(state.copyWith(
        quantityErrorText: "Invalid characters found.",
        status: AddIngredientStatus.invalid,
      ));
    } else {
      emit(state.copyWith(
        quantity: qty,
        quantityErrorText: "",
        status: _validateFields(
          quantityErrorText: "",
          nameErrorText: state.nameErrorText,
          section: state.section,
        ),
      ));
    }
  }

  void changeSection(String text) {
    final String section = text.toLowerCase();

    emit(state.copyWith(
        section: section,
        sectionErrorText: "",
        status: _validateFields(
          quantityErrorText: state.quantityErrorText,
          nameErrorText: state.nameErrorText,
          section: section,
        )));
  }

  void addIngredient() {
    if (state.status == AddIngredientStatus.valid || state.status == AddIngredientStatus.edit) {
      var newIngredient = GroceryItem.fromRawQty(
        category: state.section,
        name: state.name,
        rawQty: state.quantity,
      );

      emit(state.copyWith(status: AddIngredientStatus.add));
      emit(AddIngredientState());
    } else if (state.section.isEmpty) {
      emit(state.copyWith(
        sectionErrorText: "Choose a section the ingredient can be found in.",
      ));
      emit(state.copyWith(
        sectionErrorText: "",
      ));
    }
  }

  void editIngredient(GroceryItem originalItem) {
    //TODO delete original item from shopping list
    emit(state.copyWith(status: AddIngredientStatus.edit, oldId: originalItem.id));

    addIngredient();
  }
}
