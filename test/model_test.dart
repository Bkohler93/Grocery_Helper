// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_helper_app/data/models/grocery_list.dart';
import 'package:grocery_helper_app/data/repositories/meal_repository.dart';

void main() {
  // test('adding new grocery item to grocery list increases grocery list size', () {
  //   final groceries = GroceryListModel();
  //   final numGroceries = groceries.groceryListSize;

  //   groceries.addListener(() {
  //     expect(groceries.groceryListSize, greaterThan(numGroceries));
  //   });
  //   groceries.add(GroceryItem("produce", "apple", qty: "1"));
  // });

  // test('adding repeated grocery item to grocery list increases grocery list size', () {
  //   final groceries = GroceryListModel();
  //   groceries.add(GroceryItem("produce", "apple", qty: "1"));
  //   groceries.add(GroceryItem("produce", "apple", qty: "1"));

  //   expect(groceries.groceryListSize, 2);
  // });

  // test('clear grocery list results in a grocery list size of 0', () {
  //   final groceries = GroceryListModel();
  //   groceries.add(GroceryItem("produce", "apple", qty: "1"));

  //   groceries.removeAll();
  //   expect(groceries.groceryListSize, 0);
  // });

  // test('adding repeated grocery items to grocery list increase grocery list item quantity', () {
  //   final groceriesModel = GroceryListModel();
  //   groceriesModel.add(GroceryItem("produce", "apple", qty: "1"));
  //   groceriesModel.add(GroceryItem("produce", "apple", qty: "1"));

  //   String? result = groceriesModel.groceries["produce"]!.groceryItems["apple"]!.qty;
  //   expect(result, "2");
  // });

  // test('adding repeated grocery item to list with fractional quantity increases existing quantity',
  //     () {
  //   final groceriesModel = GroceryListModel();
  //   groceriesModel.add(GroceryItem("baking", "flour", qty: "1/2", qtyUnit: "cup"));
  //   groceriesModel.add(GroceryItem("baking", "flour", qty: "1/3", qtyUnit: "cup"));

  //   String? result = groceriesModel.groceries["baking"]!.groceryItems["flour"]!.qty;
  //   expect(result, "5/6");
  // });

  // test('item can be checked off', () {
  //   final groceriesModel = GroceryListModel();
  //   groceriesModel.add(GroceryItem("baking", "flour"));

  //   groceriesModel.checkItem(name: "flour", category: "baking");

  //   bool? result = groceriesModel.groceries["baking"]?.groceryItems["flour"]?.checkedOff;
  //   expect(result, true);
  // });

  test('meals retrieved from database', () async {
    final repository = MealRepository();

    var meals = await repository.getMeals();

    expect(meals.length > 0, true);
  });
}
