import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/models/meal.dart';
import 'dart:async';

import 'package:grocery_helper_app/data/repositories/meal/i_meal_repository.dart';

var mockMeals = <Meal>[
  Meal(name: "Meatballs with Bulgogi Sauce", id: 1, checked: false),
  Meal(name: "Cheesy  Beef Tostadas", id: 2, checked: false),
  Meal(name: "Chicken Pineapple Quesadillas", id: 3, checked: false),
  Meal(name: "Parmesan-Crusted Chicken", id: 4, checked: false)
];

var mockGroceryList = <GroceryItem>[
  GroceryItem(
      category: 'meat', name: 'ground beef', qty: '1', qtyUnit: 'lb', id: 1, checkedOff: false),
  GroceryItem(category: 'produce', name: 'lemon', qty: '1', qtyUnit: '', id: 2, checkedOff: false),
  GroceryItem(category: 'bread', name: 'buns', qty: '', qtyUnit: '', id: 3, checkedOff: false),
  GroceryItem(
      category: 'asian', name: 'asian', qty: '3', qtyUnit: 'tbsp', id: 4, checkedOff: false),
];

Map<String, List<GroceryItem>> mockMealIngredients = {
  "Meatballs with Bulgogi Sauce": [
    GroceryItem(category: 'meat', name: 'ground beef', qty: '1', qtyUnit: 'lb'),
    GroceryItem(category: 'asian', name: 'bulgogi sauce', qty: '2', qtyUnit: 'tbsp'),
  ],
  "Cheesy Beef Tostadas": [
    GroceryItem(category: 'deli', name: 'mexican cheese blend', qty: '12', qtyUnit: 'oz'),
    GroceryItem(category: 'bread', name: 'tortillas', qty: '10', qtyUnit: ''),
  ]
};

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

    mockMeals.add(Meal(name: name, id: mockMeals.length + 1, checked: false));

    return true;
  }

  @override
  Future<void> update(String name, List<GroceryItem> items) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<void> populateGroceryList(List<String> mealNames) async {
    await Future.delayed(const Duration(microseconds: 500));

    for (var name in mealNames) {
      for (GroceryItem item in mockMealIngredients[name]!) {
        mockGroceryList.add(item);
      }
    }
  }

  @override
  Future<Meal> checkMeal(Meal meal) {
    // TODO: implement checkMeal
    throw UnimplementedError();
  }
}
