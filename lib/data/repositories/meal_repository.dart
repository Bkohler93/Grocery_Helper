import 'package:grocery_helper_app/data/db_provider.dart';

import '../models/meal.dart';

abstract class IMealRepository {
  Future<List<Meal>> getMeals();
  Future<Meal?> getMeal({int id, String name});
  Future<void> insert(Meal meal);
  Future<void> update(Meal meal);
  Future<void> delete({int id, String name});
}

class MealRepository implements IMealRepository {
  Future<List<Meal>> getMeals() async {
    List<Meal> meals = [];
    var rawMealData = await SQLHelper.getMeals();
    for (var row in rawMealData) {
      meals.add(Meal.fromMap(row));
    }

    return meals;
  }

  @override
  Future<void> delete({int? id, String? name}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Meal?> getMeal({int? id, String? name}) {
    // TODO: implement getMeal
    throw UnimplementedError();
  }

  @override
  Future<void> insert(Meal meal) {
    // TODO: implement insert
    throw UnimplementedError();
  }

  @override
  Future<void> update(Meal meal) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
