part of 'add_meal_bloc.dart';

enum AddMealStatus { initialized, valid, invalid, error, success }

class AddMealState extends Equatable {
  const AddMealState({
    this.status = AddMealStatus.initialized,
    this.items = const [],
    this.mealName = '',
    this.nameErrorText = '',
  });

  final AddMealStatus status;
  final List<GroceryItem> items;
  final String mealName;
  final String nameErrorText;

  AddMealState copyWith({
    AddMealStatus? status,
    List<GroceryItem>? items,
    String? nameErrorText,
    String? mealName,
  }) {
    return AddMealState(
      status: status ?? this.status,
      items: items ?? this.items,
      nameErrorText: nameErrorText ?? this.nameErrorText,
      mealName: mealName ?? this.mealName,
    );
  }

  @override
  List<Object> get props => [
        status,
        items,
        nameErrorText,
        mealName,
      ];
}
