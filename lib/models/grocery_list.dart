import 'dart:collection';
import 'package:fraction/fraction.dart';
import 'package:flutter/foundation.dart';
import 'package:grocery_helper_app/data/db.dart';

class GroceryListModel extends ChangeNotifier {
  final Map<String, GroupedGroceryList> _groceries = {}; //category, list
  int numGroceries = 0;

  GroceryListModel() {
    var initFuture = SQLHelper.retrieveGroceries();
    initFuture.then((groceryItems) {
      for (GroceryItem item in groceryItems) {
        add(item);
      }
      notifyListeners();
    });
  }

  //view to consume
  UnmodifiableMapView<String, GroupedGroceryList> get groceries => UnmodifiableMapView(_groceries);

  bool get allGroceriesChecked => _groceries.isEmpty;

  int get groceryListSize {
    return numGroceries;
  }

  int get numGroceriesChecked {
    int _numChecked = 0;

    _groceries.entries.forEach(((element) {
      element.value.groceryItems.entries.forEach((item) {
        if (item.value.checkedOff) {
          _numChecked++;
        }
      });
    }));

    return _numChecked;
  }

  void resetGroceryListSize() {
    numGroceries = 0;
  }

  Future<void> addMealsToList(List<String> mealNames) async {
    //get all ingredients associated with meals from db (meal_ingredient table)
    List<GroceryItem> allGroceryItems = await SQLHelper.getIngredients(mealNames);

    //add condensed grocery items to condensed _groceries list
    for (GroceryItem item in allGroceryItems) {
      add(item);
    }

    //add ingredients to database (shopping list table)
    SQLHelper.insertGroceries(groceries);
  }

  //add new grocery item to groceries map
  void add(GroceryItem groceryItem) {
    //new item belongs to existing category ('produce')
    if (_groceries.containsKey(groceryItem.category)) {
      GroupedGroceryList correctCategory = _groceries[groceryItem.category] as GroupedGroceryList;

      //new item already exists in list
      if (correctCategory.groceryItems.containsKey(groceryItem.name)) {
        RegExp fractionalQtyExp = RegExp(r"(\d+)(/)(\d+)");
        String? oldQty = correctCategory.groceryItems[groceryItem.name]?.qty;

        //item has a fractional quantity ('1/2 cup')
        if (oldQty != null && oldQty != " " && fractionalQtyExp.hasMatch(oldQty)) {
          final oldQtyFrac = Fraction.fromString(oldQty);
          final incomingQtyFrac = Fraction.fromString(groceryItem.qty);

          final newQtyFrac = oldQtyFrac + incomingQtyFrac;

          correctCategory.groceryItems[groceryItem.name]?.qty = newQtyFrac.toString();
        }

        //item has whole number quantity
        else if (oldQty != null && oldQty != " ") {
          final oldQtyInt = int.parse(oldQty);
          final incomingQtyInc = int.parse(groceryItem.qty);

          final newQtyInt = oldQtyInt + incomingQtyInc;

          correctCategory.groceryItems[groceryItem.name]?.qty = newQtyInt.toString();
        }

        //new item being added to existing category
      } else {
        correctCategory.groceryItems[groceryItem.name] = groceryItem;
        numGroceries++;
      }

      //new item and category being added
    } else {
      numGroceries++;

      //create new grocery list group
      _groceries[groceryItem.category] =
          GroupedGroceryList(groceryItem.category, {groceryItem.name: groceryItem});
    }

    notifyListeners();
  }

  //add use entered item to grocery list map
  Future<void> addUserEnteredGroceryItem(GroceryItem item) async {
    add(item);
    await SQLHelper.clearGroceryList();
    await SQLHelper.insertGroceries(groceries);
  }

  // clear all groceries from map
  void removeAll() {
    _groceries.clear();
    SQLHelper.clearGroceryList();
    resetGroceryListSize();
    notifyListeners();
  }

  void checkItem(String name) {
    _groceries.entries.forEach(((element) {
      for (var item in element.value.groceryItems.entries) {
        if (item.value.name == name) {
          item.value.checkedOff = !item.value.checkedOff;
          SQLHelper.updateCheckedItem(name);
        }
      }
    }));
  }

  //cause grocery list to be built early
  void wakeUp() {}

  void deleteItem(String name) {}
}

class GroupedGroceryList {
  final String category;
  final Map<String, GroceryItem> groceryItems;
  GroupedGroceryList(this.category, this.groceryItems);
}

class GroceryItem {
  final int? id;
  final String category;
  final String name;
  String qty;
  final String qtyUnit;
  bool checkedOff = false;
  GroceryItem(this.category, this.name,
      {this.qty = ' ', this.qtyUnit = ' ', this.id, this.checkedOff = false});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "name": name,
      "category": category,
      "qty": qty,
      "checked": checkedOff ? 1 : 0,
      "qty_unit": qtyUnit
    };

    if (id != null) {
      map["id"] = id;
    }
    return map;
  }
}
