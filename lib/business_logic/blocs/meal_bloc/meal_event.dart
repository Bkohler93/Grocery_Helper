part of 'meal_bloc.dart';

abstract class MealEvent extends Equatable {}

class GetMealsEvent extends MealEvent {
  GetMealsEvent();

  @override
  List<Object> get props => [];
}

class AddMealEvent extends MealEvent {
  final String name;
  final List<GroceryItem> items;

  AddMealEvent(this.name, this.items);

  @override
  List<Object> get props => [name, items];
}

class DeleteMealEvent extends MealEvent {
  final String name;

  DeleteMealEvent(this.name);

  @override
  List<Object> get props => [name];
}

class PopulateGroceryList extends MealEvent {
  PopulateGroceryList();

  @override
  List<Object> get props => [];
}

class CheckOffMealEvent extends MealEvent {
  CheckOffMealEvent(this.meal);

  final Meal meal;

  @override
  List<Object> get props => [meal];
}
