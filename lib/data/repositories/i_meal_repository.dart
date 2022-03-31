import '../models/grocery_item.dart';
import '../models/meal.dart';

abstract class IMealRepository {
  Future<List<Meal>> getMeals();

  Future<Meal?> getMeal({int id, String name});
  Future<bool> insert(String name, List<GroceryItem> items);
  Future<void> update(String name, List<GroceryItem> items);
  Future<void> delete(String name);
}
