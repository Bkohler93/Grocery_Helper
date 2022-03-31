import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/models/meal.dart';

abstract class IMealRepository {
  Future<List<Meal>> getMeals();
  Future<Meal?> getMeal({int id, String name});
  Future<bool> insert(String name, List<GroceryItem> items);
  Future<void> update(String name, List<GroceryItem> items);
  Future<void> delete(String name);
}
