part of 'add_ingredient_cubit.dart';

enum AddIngredientStatus { initialized, valid, invalid, error, add }

class IngredientState extends Equatable {
  const IngredientState();

  copyWith() {}

  @override
  List<Object> get props => [];
}

class AddIngredientState extends IngredientState {
  const AddIngredientState({
    this.status = AddIngredientStatus.initialized,
    this.name = '',
    this.quantity = '',
    this.section = '',
    this.nameErrorText = '',
    this.quantityErrorText = '',
  });
  final AddIngredientStatus status;
  final String name;
  final String quantity;
  final String section;
  final String nameErrorText;
  final String quantityErrorText;

  @override
  AddIngredientState copyWith({
    AddIngredientStatus? status,
    String? name,
    String? quantity,
    String? section,
    String? nameErrorText,
    String? quantityErrorText,
  }) {
    return AddIngredientState(
      status: status ?? this.status,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      section: section ?? this.section,
      nameErrorText: nameErrorText ?? this.nameErrorText,
      quantityErrorText: quantityErrorText ?? this.quantityErrorText,
    );
  }

  @override
  List<Object> get props => [name, quantity, section, status, nameErrorText, quantityErrorText];
}

class SendIngredientState extends IngredientState {
  const SendIngredientState(this.groceryItem);

  final GroceryItem groceryItem;

  @override
  List<Object> get props => [groceryItem];
}
