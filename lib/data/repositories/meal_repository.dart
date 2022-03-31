import 'package:grocery_helper_app/data/db_provider.dart';

import '../models/grocery_item.dart';
import '../models/meal.dart';
import 'i_meal_repository.dart';

class MealRepository implements IMealRepository {
  @override
  Future<List<Meal>> getMeals() async {
    List<Meal> meals = [];
    var rawMealData = await SQLHelper.getMeals();
    for (var row in rawMealData) {
      meals.add(Meal.fromMap(row));
    }

    return meals;
  }

  @override
  Future<void> delete(String name) async {
    await SQLHelper.deleteMeal(name);
  }

  @override
  Future<Meal?> getMeal({int? id, String? name}) {
    // TODO: implement getMeal
    throw UnimplementedError();
  }

  @override
  Future<bool> insert(String name, List<GroceryItem> items) async {
    int mealId = await SQLHelper.insertMeal(name, items.map((item) => item.toMap()).toList());

    return (mealId > 0);
  }

  @override
  Future<void> update(String name, List<GroceryItem> items) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
