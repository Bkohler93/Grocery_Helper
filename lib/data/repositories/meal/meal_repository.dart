import 'package:grocery_helper_app/data/db_provider.dart';
import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/models/meal.dart';

import 'i_meal_repository.dart';

class MealRepository implements IMealRepository {
  @override
  Future<List<Meal>> getMeals() async {
    List<Meal> meals = [];
    var rawMealData = await SQLHelper.getMeals();
    for (var meal in rawMealData) {
      meals.add(meal);
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
    int mealId = await SQLHelper.insertMeal(name, items);

    return (mealId > 0);
  }

  @override
  Future<void> update(String name, List<GroceryItem> items) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<void> populateGroceryList(List<String> mealNames) async {
    //get list of ingredients
    List<GroceryItem> mealIngredients = await SQLHelper.getIngredients(mealNames);

    //insert groceries into shopping_list
    await SQLHelper.insertGroceries(mealIngredients);
  }

  @override
  Future<Meal> checkMeal(Meal meal) async {
    Meal mealChecked = meal.checkOff();
    await SQLHelper.updateMeal(mealChecked);
    return mealChecked;
  }
}
