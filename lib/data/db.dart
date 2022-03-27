import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:grocery_helper_app/models/ingredient.dart';
import 'package:grocery_helper_app/models/meal.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:grocery_helper_app/models/grocery_list.dart';
import 'dart:async';

class SQLHelper {
  static Future<void> createTables(sql.Database db) async {
    await db.execute("""CREATE TABLE meals(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
      name TEXT NOT NULL UNIQUE
      )
      """);
    await db.execute("""CREATE TABLE ingredients(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        name TEXT NOT NULL UNIQUE,
        category TEXT
      )
      """);
    await db.execute("""
      CREATE TABLE meal_ingredients(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        meal_id INTEGER NOT NULL, 
        ingredient_id INTEGER NOT NULL, 
        qty TEXT,
        qty_unit TEXT,
        FOREIGN KEY (meal_id) REFERENCES meals (id) 
          ON DELETE NO ACTION ON UPDATE NO ACTION,
        FOREIGN KEY (ingredient_id) REFERENCES ingredients (id)
          ON DELETE NO ACTION ON UPDATE NO ACTION
      )""");
    await db.execute("""
      CREATE TABLE shopping_list(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        checked INTEGER NOT NULL,
        qty TEXT,
        qty_unit TEXT
      )
    """);
  }

  static Future<void> fillTables(sql.Database db) async {
    await db.execute("""
      INSERT INTO meals(name) VALUES ("Cheese and Potatoes"), ("Beans and Rice")
    """);

    await db.execute("""
      INSERT INTO ingredients(name, category) VALUES ("potato", "produce"), ("cheese","produce"), ("beans", "canned"), ("rice","bulk")
    """);

    await db.execute("""
      INSERT INTO meal_ingredients(meal_id, ingredient_id, qty, qty_unit) VALUES
        ((SELECT id from meals WHERE name="Cheese and Potatoes"),
          (SELECT id from ingredients WHERE name="potato"), "3", ""),
        ((SELECT id from meals WHERE name="Cheese and Potatoes"),
          (SELECT id from ingredients WHERE name="cheese"),"12", "oz"),
        ((SELECT id from meals WHERE name="Beans and Rice"),
          (SELECT id from ingredients WHERE name="beans"),"1","can"),
        ((SELECT id from meals WHERE name="Beans and Rice"),
          (SELECT id from ingredients WHERE name="rice"),"1","cup")
    """);
    await db.execute("""
      INSERT INTO shopping_list(name, category, checked, qty, qty_unit) 
      VALUES ("broccoli",   "produce",  0, "1", "head"),
            ("grapes",      "produce",  0, " ", " "),
            ("mini wheats", "breakfast",1, " ", " "),
            ("rice",        "bulk",     0, "2", "cups")
    """);
  }

  //retrieve database
  static Future<sql.Database> db() async {
    //!sql.databaseFactory.deleteDatabase(join(await sql.getDatabasesPath(), 'grocery.db'));
    return sql.openDatabase(join(await sql.getDatabasesPath(), 'grocery.db'), version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
      await fillTables(database);
    });
  }

  //insert new meal into meals table, and insert ingredients into
  // ingredients and meal_ingredients table.
  static Future<int> insertMeal(Meal meal, List<GroceryItem> items) async {
    final db = await SQLHelper.db();
    //check if meal already in db
    var mealCheckResults = await db.rawQuery("""
      SELECT * FROM meals
      WHERE meals.name = ?
    """, [meal.name]);

    //meal already exists
    if (mealCheckResults.isNotEmpty) {
      return -1;
    }

    var id = await db.rawInsert("""
      INSERT INTO meals (name) VALUES (?)
    """, [meal.name]);

    //check if ingredient already exists before adding new entry to
    // ingredients table. Then add all items to meal_ingredients table
    for (GroceryItem item in items) {
      //get ingredient matching name from db, in order to get ingredientId
      List<Map> results = await db.query("ingredients",
          columns: Ingredient.columns, where: "name = ?", whereArgs: [item.name]);

      int ingredientId = results.isNotEmpty ? results[0]["id"] : await db.rawInsert("""
          INSERT INTO ingredients(name, category)
          VALUES (?, ?)
        """, [item.name, item.category]);

      //insert with 'id' and ingredientId
      await db.rawInsert("""
        INSERT INTO meal_ingredients(
          meal_id, ingredient_id, qty_unit, qty) 
        VALUES(
          ?, ?, ?, ?
      )""", [id, ingredientId, item.qtyUnit, item.qty]);
    }

    return id;
  }

  //insert new ingredient
  static Future<int> insertIngredient(Ingredient ingredient) async {
    final db = await SQLHelper.db();

    final id = await db.insert('ingredients', ingredient.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  //retrieve list of meals
  static Future<List<Meal>> getMeals() async {
    // sql.databaseFactory
    //     .deleteDatabase(join(await sql.getDatabasesPath(), 'grocery.db'));
    final db = await SQLHelper.db();
    var result = await db.query('meals');

    List<Meal> meals = [];
    for (var meal in result) {
      meals.add(Meal.fromMap(meal));
    }

    return meals;
  }

  // retrieve entire list of grocery items from db using list of meals selected. All ingredients are already store in database.
  static Future<List<GroceryItem>> getIngredients(List<String> mealNames) async {
    final db = await SQLHelper.db();
    List<GroceryItem> items = [];

    for (String name in mealNames) {
      List<Map> data = await db.rawQuery("""
        SELECT m.name, ingredients.name, ingredients.category, meal_ingredients.qty, meal_ingredients.qty_unit 
        FROM (SELECT * FROM meals where meals.name = ?) as m
        INNER JOIN meal_ingredients ON m.id = meal_ingredients.meal_id
        INNER JOIN ingredients on meal_ingredients.ingredient_id = ingredients.id
      """, [name]);

      for (var item in data) {
        items.add(GroceryItem(item['category'], item["name"],
            qty: item['qty'], qtyUnit: item['qty_unit']));
      }
    }

    return items;
  }

  //insert single grocery item

  //insert grocery list into database, check if grocery list is already empty or not.
  static Future<void> insertGroceries(
      UnmodifiableMapView<String, GroupedGroceryList> groceries) async {
    final db = await SQLHelper.db();

    var batch = db.batch();
    for (GroupedGroceryList g in groceries.values) {
      for (GroceryItem gItem in g.groceryItems.values) {
        db.insert('shopping_list', gItem.toMap());
      }
    }
    await batch.commit(noResult: true);
  }

  static Future<List<GroceryItem>> retrieveGroceries() async {
    List<GroceryItem> items = [];
    final db = await SQLHelper.db();

    List<Map> data = await db.rawQuery("""
      SELECT * FROM shopping_list
    """);

    for (var row in data) {
      items.add(
        GroceryItem(row["category"], row["name"],
            checkedOff: row["checked"] == 1 ? true : false,
            qty: row["qty"],
            qtyUnit: row["qty_unit"]),
      );
    }

    return items;
  }

  static Future<void> clearGroceryList() async {
    final db = await SQLHelper.db();

    await db.delete('shopping_list');
  }

  static Future<void> updateCheckedItem(String name) async {
    final db = await SQLHelper.db();
  }

  static Future<void> deleteMeal(String name) async {
    final db = await SQLHelper.db();

    var id = await db.rawQuery("""
      SELECT meals.id FROM meals WHERE meals.name = ?
    """, [name]);

    await db.rawDelete("""
      DELETE FROM meal_ingredients WHERE meal_ingredients.meal_id = ?  
    """, [id.first.values.first]);

    await db.rawDelete("""
      DELETE FROM meals WHERE meals.id = ?
    """, [id.first.values.first]);
  }
}
