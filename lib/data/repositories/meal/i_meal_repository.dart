import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/models/meal.dart';

abstract class IMealRepository {
  Future<List<Meal>> getMeals();
  Future<Meal?> getMeal({int id, String name});
  Future<bool> insert(String name, List<GroceryItem> items);
  Future<void> update(String name, List<GroceryItem> items);
  Future<void> delete(Meal meal);
  Future<void> populateGroceryList(List<String> mealNames);
  Future<Meal> checkMeal(Meal meal);
  Future<bool> mealExists(String name);
  Future<List<GroceryItem>> getMealIngredients({required String mealName});
  Future<void> updateMeal(int mealId, String mealName, List<GroceryItem> items);
}
