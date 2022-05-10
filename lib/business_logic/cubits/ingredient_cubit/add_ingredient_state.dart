part of 'add_ingredient_cubit.dart';

enum AddIngredientStatus { initialized, valid, invalid, error, add, edit }

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
    this.isChecked = false,
    this.section = '',
    this.sectionErrorText = '',
    this.nameErrorText = '',
    this.quantityErrorText = '',
    this.oldId = 0,
  });
  final AddIngredientStatus status;
  final String name;
  final String quantity;
  final bool isChecked;
  final String section;
  final String sectionErrorText;
  final String nameErrorText;
  final String quantityErrorText;
  final int oldId;

  @override
  AddIngredientState copyWith({
    AddIngredientStatus? status,
    String? name,
    String? quantity,
    bool? isChecked,
    String? section,
    String? sectionErrorText,
    String? nameErrorText,
    String? quantityErrorText,
    int? oldId,
  }) {
    return AddIngredientState(
      status: status ?? this.status,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      isChecked: isChecked ?? this.isChecked,
      section: section ?? this.section,
      sectionErrorText: sectionErrorText ?? this.sectionErrorText,
      nameErrorText: nameErrorText ?? this.nameErrorText,
      quantityErrorText: quantityErrorText ?? this.quantityErrorText,
      oldId: oldId ?? this.oldId,
    );
  }

  @override
  List<Object> get props => [
        name,
        quantity,
        section,
        status,
        nameErrorText,
        quantityErrorText,
        sectionErrorText,
        oldId,
        isChecked
      ];
}

class SendIngredientState extends IngredientState {
  const SendIngredientState(this.groceryItem);

  final GroceryItem groceryItem;

  @override
  List<Object> get props => [groceryItem];
}
