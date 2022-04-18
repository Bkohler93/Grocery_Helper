part of 'edit_meal_bloc.dart';

enum EditMealStatus { loading, initial, valid, invalid, error, success }

class EditMealState extends Equatable {
  const EditMealState({
    this.status = EditMealStatus.loading,
    this.items = const [],
    this.mealName = '',
    required this.mealId,
    this.nameErrorText = '',
  });

  final EditMealStatus status;
  final List<GroceryItem> items;
  final String mealName;
  final String nameErrorText;
  final int mealId;

  EditMealState copyWith({
    EditMealStatus? status,
    List<GroceryItem>? items,
    String? nameErrorText,
    String? mealName,
  }) {
    return EditMealState(
      status: status ?? this.status,
      items: items ?? this.items,
      nameErrorText: nameErrorText ?? this.nameErrorText,
      mealId: mealId,
      mealName: mealName ?? this.mealName,
    );
  }

  @override
  List<Object> get props => [
        status,
        items,
        nameErrorText,
        mealId,
        mealName,
      ];
}
