import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/models/meal.dart';
import 'dart:async';

import 'package:grocery_helper_app/data/repositories/meal/i_meal_repository.dart';

var mockMeals = <Meal>[
  Meal(name: "Meatballs with Bulgogi Sauce", id: 1),
  Meal(name: "Cheesy  Beef Tostadas", id: 2),
  Meal(name: "Chicken Pineapple Quesadillas", id: 3),
  Meal(name: "Parmesan-Crusted Chicken", id: 4)
];

class MockMealRepository implements IMealRepository {
  @override
  Future<void> delete(String name) async {
    await Future.delayed(const Duration(microseconds: 500));

    if (!mockMeals.any((element) => element.name == name)) {
      throw Error();
    }
    mockMeals.removeWhere((element) => element.name == name);
  }

  @override
  Future<Meal?> getMeal({int? id, String? name}) {
    // TODO: implement getMeal
    throw UnimplementedError();
  }

  @override
  Future<List<Meal>> getMeals() async {
    await Future.delayed(const Duration(microseconds: 500));

    return [...mockMeals];
  }

  @override
  Future<bool> insert(String name, List<GroceryItem> items) async {
    await Future.delayed(const Duration(microseconds: 500));

    for (var meal in mockMeals) {
      if (meal.name == name) {
        return false;
      }
    }

    mockMeals.add(Meal(name: name, id: mockMeals.length + 1));

    return true;
  }

  @override
  Future<void> update(String name, List<GroceryItem> items) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
