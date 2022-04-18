part of 'edit_meal_bloc.dart';

abstract class EditMealEvent extends Equatable {
  const EditMealEvent();

  @override
  List<Object> get props => [];
}

class InitializeForm extends EditMealEvent {
  const InitializeForm();

  @override
  List<Object> get props => [];
}

class EditMealNameEvent extends EditMealEvent {
  final String text;

  const EditMealNameEvent(this.text);

  @override
  List<Object> get props => [text];
}

class EditIngredientNameEvent extends EditMealEvent {
  final String text;

  const EditIngredientNameEvent(this.text);

  @override
  List<Object> get props => [text];
}

class EditIngredientQtyEvent extends EditMealEvent {
  final String text;

  const EditIngredientQtyEvent(this.text);

  @override
  List<Object> get props => [text];
}

class ChangeIngredientCategoryEvent extends EditMealEvent {
  final String category;

  const ChangeIngredientCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}

class AddIngredientEvent extends EditMealEvent {
  const AddIngredientEvent({required this.name, required this.rawQty, required this.category});

  final String name;
  final String rawQty;
  final String category;

  @override
  List<Object> get props => [name, rawQty, category];
}

class DeleteIngredientEvent extends EditMealEvent {
  const DeleteIngredientEvent(this.groceryItem);
  final GroceryItem groceryItem;

  @override
  List<Object> get props => [groceryItem];
}

class SaveMealEvent extends EditMealEvent {
  const SaveMealEvent();

  @override
  List<Object> get props => [];
}

class LoadIngredientsEvent extends EditMealEvent {
  final String mealName;
  const LoadIngredientsEvent({required this.mealName});

  @override
  List<Object> get props => [mealName];
}
