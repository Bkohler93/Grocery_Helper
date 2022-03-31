part of 'meal_bloc.dart';

abstract class MealEvent {}

class GetMeals extends MealEvent {
  GetMeals();
}

class AddMeal extends MealEvent {
  String name;
  List<GroceryItem> items;

  AddMeal(this.name, this.items);
}

class DeleteMeal extends MealEvent {
  String name;

  DeleteMeal(this.name);
}
