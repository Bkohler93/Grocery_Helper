part of 'meal_bloc.dart';

abstract class MealEvent {}

class GetMealsEvent extends MealEvent {
  GetMealsEvent();
}

class AddMealEvent extends MealEvent {
  String name;
  List<GroceryItem> items;

  AddMealEvent(this.name, this.items);
}

class DeleteMealEvent extends MealEvent {
  String name;

  DeleteMealEvent(this.name);
}

class PopulateGroceryList extends MealEvent {
  List<String> mealNames;

  PopulateGroceryList(this.mealNames);
}
