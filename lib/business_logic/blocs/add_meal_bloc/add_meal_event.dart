part of 'add_meal_bloc.dart';

abstract class AddMealEvent extends Equatable {
  const AddMealEvent();

  @override
  List<Object> get props => [];
}

class EditMealNameEvent extends AddMealEvent {
  final String text;

  const EditMealNameEvent(this.text);

  @override
  List<Object> get props => [text];
}

class EditIngredientNameEvent extends AddMealEvent {
  final String text;

  const EditIngredientNameEvent(this.text);

  @override
  List<Object> get props => [text];
}

class EditIngredientQtyEvent extends AddMealEvent {
  final String text;

  const EditIngredientQtyEvent(this.text);

  @override
  List<Object> get props => [text];
}

class ChangeIngredientCategoryEvent extends AddMealEvent {
  final String category;

  const ChangeIngredientCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}

class AddIngredientEvent extends AddMealEvent {
  const AddIngredientEvent();

  @override
  List<Object> get props => [];
}