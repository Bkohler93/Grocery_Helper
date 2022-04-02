import 'package:fraction/fraction.dart';
import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/models/meal.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'dart:async';

//TODO All returns should be RAW DATA from database, NOT MODELS like how it is now
//! This shoudl be instantiated INSIDE the REPOSITORY (currently grocer_list)
class SQLHelper {
  static Future<void> createTables(sql.Database db) async {
    await db.execute("""CREATE TABLE meals(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
      name TEXT NOT NULL UNIQUE,
      checked INTEGER NOT NULL
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
      INSERT INTO meals(name, checked) 
      VALUES ("meatballs with bulgogi sauce", 0), ("lemon chicken stock", 1)
    """);

    await db.execute("""
      INSERT INTO ingredients(name, category) VALUES ("lemon", "produce"), ("ground beef", "meat"), ("bulgogi sauce", "asian"), ("chicken stock", "soup")
    """);

    await db.execute("""
      INSERT INTO meal_ingredients(meal_id, ingredient_id, qty, qty_unit) VALUES
        ((SELECT id from meals WHERE name="meatballs with bulgogi sauce"),
          (SELECT id from ingredients WHERE name="lemon"), "2", ""),
        ((SELECT id from meals WHERE name="meatballs with bulgogi sauce"),
          (SELECT id from ingredients WHERE name="ground beef"),"1", "lb"),
        ((SELECT id from meals WHERE name="meatballs with bulgogi sauce"),
          (SELECT id from ingredients WHERE name="bulgogi sauce"),"3","tsp"),
        ((SELECT id from meals WHERE name="meatballs with bulgogi sauce"),
          (SELECT id from ingredients WHERE name="chicken stock"),"1/2","cup"),
        ((SELECT id from meals WHERE name="lemon chicken stock"),
          (SELECT id from ingredients WHERE name="chicken stock"),"1/2","cup"),
        ((SELECT id from meals WHERE name="lemon chicken stock"),
          (SELECT id from ingredients WHERE name="lemon"),"1","")
    """);

    await db.execute("""
      INSERT INTO shopping_list(name, category, checked, qty, qty_unit) VALUES
      ('ground beef', 'meat', 0, '1', 'lb'), ('lemon', 'produce', 1, '2', "")
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
  static Future<int> insertMeal(String mealName, List<GroceryItem> ingredients) async {
    final db = await SQLHelper.db();
    //check if meal already in db
    var mealCheckResults = await db.rawQuery("""
      SELECT * FROM meals
      WHERE meals.name = ?
    """, [mealName]);

    //meal already exists
    if (mealCheckResults.isNotEmpty) {
      return -1;
    }

    var id = await db.rawInsert("""
      INSERT INTO meals (name, checked) VALUES (?, 0)
    """, [mealName]);

    //check if ingredient already exists before adding new entry to
    // ingredients table. Then add all items to meal_ingredients table
    for (GroceryItem ingredient in ingredients) {
      //get ingredient matching name from db, in order to get ingredientId
      List<Map> results = await db.query("ingredients",
          columns: GroceryItem.ingredientColumns, where: "name = ?", whereArgs: [ingredient.name]);

      int ingredientId = results.isNotEmpty ? results[0]["id"] : await db.rawInsert("""
          INSERT INTO ingredients(name, category)
          VALUES (?, ?)
        """, [ingredient.name, ingredient.category]);

      //insert with 'id' and ingredientId
      await db.rawInsert("""
        INSERT INTO meal_ingredients(
          meal_id, ingredient_id, qty_unit, qty) 
        VALUES(
          ?, ?, ?, ?
      )""", [id, ingredientId, ingredient.qtyUnit, ingredient.qty]);
    }

    return id;
  }

  //insert new ingredient
  static Future<int> insertIngredient(Map<String, Object?> ingredient) async {
    final db = await SQLHelper.db();

    final id = await db.insert('ingredients', ingredient,
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
        items.add(GroceryItem.fromMap({
          "category": item['category'],
          "name": item["name"],
          "qty": item['qty'],
          "qty_unit": item['qty_unit'],
          "id": item['id'],
          "checked": 0,
        }));
      }
    }

    return items;
  }

  //insert grocery list into database
  static Future<void> insertGroceries(List<GroceryItem> groceries) async {
    final db = await SQLHelper.db();

    var batch = db.batch();
    for (var groceryItem in groceries) {
      await insertGrocery(groceryItem);
    }
    await batch.commit(noResult: true);
  }

  static Future<int> insertGrocery(GroceryItem item) async {
    final db = await SQLHelper.db();

    //find matching grocery item in list
    var queryResult = await db.rawQuery("""
      SELECT id, name, qty, category, qty_unit FROM shopping_list WHERE name = ?
    """, [item.name]);

    //check if qty should be updated, otherwise just insert new entry
    if (queryResult.isNotEmpty) {
      //entries must have same name, category, qtyUnit, and qty's must be valid number
      for (var entry in queryResult) {
        if (entry['name'] == item.name &&
            entry['category'] == item.category &&
            entry['qty_unit'] == item.qtyUnit &&
            item.qty != " " &&
            entry['qty'] != null) {
          //update shopping list quanty
          RegExp fractionQtyRegEx = RegExp(r"(\d+)(/)(\d+)");

          if (fractionQtyRegEx.hasMatch(item.qty) ||
              fractionQtyRegEx.hasMatch(entry['qty'].toString())) {
            final oldQtyFrac = Fraction.fromString(entry['qty'].toString());
            final newQtyFrac = Fraction.fromString(item.qty);

            final totalQtyFrac = oldQtyFrac + newQtyFrac;

            final totalQtyStr = totalQtyFrac.toString();

            return await db.rawUpdate("""
              UPDATE shopping_list SET qty = ? 
              WHERE id = ?""", [totalQtyStr, entry['id']]);
          } else {
            return await db.rawUpdate("""
              UPDATE shopping_list SET qty=? 
              WHERE id = ?
              """, [int.parse(entry['qty'].toString()) + int.parse(item.qty), entry['id']]);
          }
        }
      }
    }
    return await db.rawInsert("""
        INSERT INTO shopping_list (name, category, checked, qty, qty_unit) 
        VALUES (?, ?, ?, ?, ?)
      """, [item.name, item.category, item.checkedOff, item.qty, item.qtyUnit]);
  }

  static Future<List<GroceryItem>> retrieveGroceries() async {
    List<GroceryItem> items = [];
    final db = await SQLHelper.db();

    List<Map> data = await db.rawQuery("""
      SELECT * FROM shopping_list
    """);

    for (var row in data) {
      items.add(GroceryItem.fromMap(
        {
          "category": row["category"],
          "name": row["name"],
          "checked": row["checked"],
          'id': row['id'],
          "qty": row["qty"],
          "qty_unit": row["qty_unit"]
        },
      ));
    }

    return items;
  }

  static Future<void> clearGroceryList() async {
    final db = await SQLHelper.db();

    await db.delete('shopping_list');
  }

  static Future<void> updateCheckedItem(GroceryItem item) async {
    final db = await SQLHelper.db();

    // update item in shopping_list to be !checked
    await db.rawUpdate("""
      UPDATE shopping_list SET checked = ? WHERE id = ?
    """, [item.checkedOff ? 1 : 0, item.id]);
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

  static Future<int> removeShoppingItem(int id) async {
    final db = await SQLHelper.db();

    return await db.rawDelete("""
      DELETE FROM shopping_list WHERE shopping_list.id = ?
    """, [id]);
  }

  static Future<int> updateShoppingItem(GroceryItem item) async {
    final db = await SQLHelper.db();

    return await db.rawUpdate("""
      UPDATE shopping_list SET name = ?, qty = ?, qty_unit = ?, category = ?, checked = ? 
      WHERE id = ?
    """, [item.name, item.qty, item.qtyUnit, item.category, item.checkedOff ? 1 : 0, item.id]);
  }

  static Future<int> updateMeal(Meal meal) async {
    final db = await SQLHelper.db();

    return await db.rawUpdate("""
      UPDATE meals SET name = ?, checked = ?
      WHERE id = ?
    """, [meal.name, meal.checked, meal.id]);
  }
}
