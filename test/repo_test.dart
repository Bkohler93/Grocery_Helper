// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_helper_app/data/repositories/grocery/grocery_repository.dart';
import 'package:grocery_helper_app/data/repositories/meal/meal_repository.dart';

void main() {
  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
  });
  test('meals retrieved from database', () async {
    final repository = MealRepository();

    var meals = await repository.getMeals();

    expect(meals.isNotEmpty, true);
  });

  test('grocery list retrieve from database', () async {
    final repository = GroceryRepository();

    var groceries = await repository.getGroceries();

    expect(groceries.isNotEmpty, true);
  });

  test('submit a list of meal names to add to grocery list and receive new list of groceries',
      () async {
    final mealRepository = MealRepository();
    final groceryRepository = GroceryRepository();

    var initialGroceries = await groceryRepository.getGroceries();
    var initialLemonCount =
        int.parse(initialGroceries.firstWhere((element) => element.name == 'lemon').qty);

    await mealRepository.populateGroceryList(["meatballs with bulgogi sauce"]);

    var finalGroceries = await groceryRepository.getGroceries();
    var finalLemonCount =
        int.parse(finalGroceries.firstWhere((element) => element.name == 'lemon').qty);

    expect(finalLemonCount, initialLemonCount + 2);
  });
}
