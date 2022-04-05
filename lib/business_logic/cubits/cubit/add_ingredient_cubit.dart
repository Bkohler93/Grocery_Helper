import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_helper_app/data/models/grocery_item.dart';

part 'add_ingredient_state.dart';

class AddIngredientCubit extends Cubit<AddIngredientState> {
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
        ),
      ));
    }
  }

  AddIngredientStatus _validateFields({
    required String quantityErrorText,
    required String nameErrorText,
  }) {
    if (quantityErrorText.isNotEmpty) {
      return AddIngredientStatus.invalid;
    } else if (nameErrorText.isNotEmpty) {
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
    } else if (!qty.contains(RegExp(r"^([0-9A-Za-z/.]*)$"))) {
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
        ),
      ));
    }
  }

  void changeSection(String text) {
    final String section = text.toLowerCase();

    emit(state.copyWith(section: section));
  }

  void addIngredient() {
    var newIngredient = GroceryItem.fromRawQty(
      category: state.section,
      name: state.name,
      rawQty: state.quantity,
    );

    emit(state.copyWith(status: AddIngredientStatus.add));
    emit(AddIngredientState());
  }
}
