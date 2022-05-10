import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/models/meal.dart';
import 'package:grocery_helper_app/data/providers/meal_provider.dart';

import 'i_meal_repository.dart';

class MealRepository implements IMealRepository {
  @override
  Future<List<Meal>> getMeals() async {
    List<Meal> meals = [];
    var rawMealData = await MealProvider.getMeals();
    for (var meal in rawMealData) {
      meals.add(meal);
    }
    return meals;
  }

  @override
  Future<void> delete(Meal meal) async {
    await MealProvider.deleteMeal(meal);
  }

  @override
  Future<Meal?> getMeal({int? id, String? name}) {
    // TODO: implement getMeal
    throw UnimplementedError();
  }

  @override
  Future<bool> insert(String name, List<GroceryItem> items) async {
    int mealId = await MealProvider.insertMeal(name, items);

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
    List<GroceryItem> mealIngredients = await MealProvider.getIngredients(mealNames);

    //insert groceries into shopping_list
    await MealProvider.insertGroceries(mealIngredients);
  }

  @override
  Future<Meal> checkMeal(Meal meal) async {
    Meal mealChecked = meal.checkOff();
    await MealProvider.updateMeal(mealChecked);
    return mealChecked;
  }

  @override
  Future<bool> mealExists(String name, int id) async {
    return await MealProvider.mealExists(name, id);
  }

  @override
  Future<List<GroceryItem>> getMealIngredients({required String mealName}) {
    return MealProvider.getIngredients([mealName]);
  }

  @override
  Future<void> updateMeal(int mealId, String mealName, List<GroceryItem> items) async {
    await MealProvider.updateMealAndIngredients(
        Meal(name: mealName, id: mealId, checked: false), items);
  }
}
