part of 'add_meal_bloc.dart';

enum AddMealStatus { initialized, valid, invalid, error }

class AddMealState extends Equatable {
  const AddMealState({
    this.status = AddMealStatus.initialized,
    this.items = const [],
    this.nameErrorText = '',
    this.ingredientNameErrorText = '',
    this.ingredientQtyErrorText = '',
    this.mealName = '',
    this.ingredientName = '',
    this.ingredientQty = '',
    this.ingredientCategory = '',
  });

  final AddMealStatus status;
  final List<GroceryItem> items;
  final String nameErrorText;
  final String ingredientNameErrorText;
  final String ingredientQtyErrorText;
  final String mealName;
  final String ingredientName;
  final String ingredientQty;
  final String ingredientCategory;

  AddMealState copyWith({
    AddMealStatus? status,
    List<GroceryItem>? items,
    String? nameErrorText,
    String? ingredientNameErrorText,
    String? ingredientQtyErrorText,
    String? mealName,
    String? ingredientName,
    String? ingredientQty,
    String? ingredientCategory,
  }) {
    return AddMealState(
      status: status ?? this.status,
      items: items ?? this.items,
      nameErrorText: nameErrorText ?? this.nameErrorText,
      ingredientNameErrorText: ingredientNameErrorText ?? this.ingredientNameErrorText,
      ingredientQtyErrorText: ingredientQtyErrorText ?? this.ingredientQtyErrorText,
      mealName: mealName ?? this.mealName,
      ingredientName: ingredientName ?? this.ingredientName,
      ingredientQty: ingredientQty ?? this.ingredientQty,
      ingredientCategory: ingredientCategory ?? this.ingredientCategory,
    );
  }

  bool ingredientFieldsComplete() {
    return (ingredientName.isNotEmpty &&
        ingredientNameErrorText.isEmpty &&
        ingredientQtyErrorText.isEmpty);
  }

  @override
  List<Object> get props => [
        status,
        items,
        nameErrorText,
        ingredientNameErrorText,
        ingredientQtyErrorText,
        mealName,
        ingredientName,
        ingredientQty,
      ];
}
