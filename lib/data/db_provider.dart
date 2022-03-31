import 'package:grocery_helper_app/data/models/ingredient.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'dart:async';

//TODO All returns should be RAW DATA from database, NOT MODELS like how it is now
//! This shoudl be instantiated INSIDE the REPOSITORY (currently grocer_list)
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
      INSERT INTO meals(name) VALUES ("Meatballs with Bulgogi Sauce"), ("Cheesy Beef Tostadas"), ("Chicken Pineapple Quesadillas"), ("Parmesan-Crusted Chicken")
    """);

    await db.execute("""
      INSERT INTO ingredients(name, category) VALUES ("Lemon", "Produce"), ("Panko Breadcrumbs","Asian"), ("Fry Seasoning", "Spices"), ("Parmesan Cheese","Deli"), ("Chicken Breast","Meat"), ("Dijon Mustard", "Condiments"), ("Mayonnaise","Condiments"), ("Spaghetti","Pasta"),("Grape Tomatoes","Produce"), ("Garlic", "Produce"), ("Cream Cheese","Dairy"), ("Green Beans","Produce"),("Ginger","Produce"), ("Scallions", "Produce"), ("Jasmine Rice","Bulk"), ("Ground Beef","Meat"), ("Bulgogi Sauce", "Asian"), ("Yogurt","Dairy"), ("Sriracha","Asian"),("Sesame Seeds","Spices"), ("Roma Tomato", "Produce"), ("Cilantro","Produce"), ("Lime","Produce"),("Long Green Pepper","Produce"), ("Yellow Onion", "Produce"), ("Hot Sauce","Condiments"), ("Southwest Spice Blend","Spices"),("Chili Powder","Spices"), ("Beef Stock", "Soup"), ("Flour Tortillas","Mexican"), ("Mexican Cheese Blend","Dairy"), ("Green Bell Pepper", "Produce"), ("Pineapple","Produce"),("Canned Pineapple","Canned"), ("Mozzarella Cheese", "Deli"), ("Paprika","Spices"), ("Milk","Dairy")
    """);

    // await db.execute("""
    //   INSERT INTO meal_ingredients(meal_id, ingredient_id, qty, qty_unit) VALUES
    //     ((SELECT id from meals WHERE name="Cheesy Beef Tostadas"),
    //       (SELECT id from ingredients WHERE name="Roma Tomato"), "2", ""),
    //     ((SELECT id from meals WHERE name="Cheesy Beef Tostadas"),
    //       (SELECT id from ingredients WHERE name="Cilantro"),"1/2", "oz"),
    //     ((SELECT id from meals WHERE name="Cheesy Beef Tostadas"),
    //       (SELECT id from ingredients WHERE name="Lime"),"2",""),
    //     ((SELECT id from meals WHERE name="Cheesy Beef Tostadas"),
    //       (SELECT id from ingredients WHERE name="Long Green Pepper"),"2",""),
    //     ((SELECT id from meals WHERE name="Cheesy Beef Tostadas"),
    //       (SELECT id from ingredients WHERE name="Yellow Onion"), "1", ""),
    //     ((SELECT id from meals WHERE name="Cheesy Beef Tostadas"),
    //       (SELECT id from ingredients WHERE name="Yogurt"),"8", "Tbsp"),
    //     ((SELECT id from meals WHERE name="Cheesy Beef Tostadas"),
    //       (SELECT id from ingredients WHERE name="Hot Sauce"),"2","Tsp"),
    //     ((SELECT id from meals WHERE name="Cheesy Beef Tostadas"),
    //       (SELECT id from ingredients WHERE name="Ground Beef"),"1","lb"),
    //       ((SELECT id from meals WHERE name="Cheesy Beef Tostadas"),
    //       (SELECT id from ingredients WHERE name="Southwest Spice Blend"),"2","Tbsp"),
    //     ((SELECT id from meals WHERE name="Cheesy Beef Tostadas"),
    //       (SELECT id from ingredients WHERE name="Chili Powder"), "2", "Tsp"),
    //     ((SELECT id from meals WHERE name="Cheesy Beef Tostadas"),
    //       (SELECT id from ingredients WHERE name="Beef Stock Concentrate"),"1/2", "cup"),
    //     ((SELECT id from meals WHERE name="Cheesy Beef Tostadas"),
    //       (SELECT id from ingredients WHERE name="Flour Tortillas"),"12",""),
    //     ((SELECT id from meals WHERE name="Cheesy Beef Tostadas"),
    //       (SELECT id from ingredients WHERE name="Mexican Cheese Blend"),"1","cup"),
    //     ((SELECT id from meals WHERE name="Meatballs with Bulgogi Sauce"),
    //       (SELECT id from ingredients WHERE name="Mexican Cheese Blend"),"1","cup"),
    //     ((SELECT id from meals WHERE name="Meatballs with Bulgogi Sauce"),
    //       (SELECT id from ingredients WHERE name="Green Beans"),"12","oz"),
    //     ((SELECT id from meals WHERE name="Meatballs with Bulgogi Sauce"),
    //       (SELECT id from ingredients WHERE name="Ginger"),"1","Thumb"),
    //     ((SELECT id from meals WHERE name="Meatballs with Bulgogi Sauce"),
    //       (SELECT id from ingredients WHERE name="Scallions"),"2",""),
    //     ((SELECT id from meals WHERE name="Meatballs with Bulgogi Sauce"),
    //       (SELECT id from ingredients WHERE name="Jasmine Rice"),"3/2","cup"),
    //     ((SELECT id from meals WHERE name="Meatballs with Bulgogi Sauce"),
    //       (SELECT id from ingredients WHERE name="Ground Beef"),"20","oz"),
    //     ((SELECT id from meals WHERE name="Meatballs with Bulgogi Sauce"),
    //       (SELECT id from ingredients WHERE name="Panko Breadcrumbs"),"1/2","cup"),
    //     ((SELECT id from meals WHERE name="Meatballs with Bulgogi Sauce"),
    //       (SELECT id from ingredients WHERE name="Bulgogi Sauce"),"8","oz"),
    //     ((SELECT id from meals WHERE name="Meatballs with Bulgogi Sauce"),
    //       (SELECT id from ingredients WHERE name="Yogurt"),"4","Tbsp"),
    //     ((SELECT id from meals WHERE name="Meatballs with Bulgogi Sauce"),
    //       (SELECT id from ingredients WHERE name="Sriracha"),"1","Tsp"),
    //     ((SELECT id from meals WHERE name="Meatballs with Bulgogi Sauce"),
    //       (SELECT id from ingredients WHERE name="Sesame Seeds"),"1","Tbsp"),
    //     ((SELECT id from meals WHERE name="Parmesan-Crusted Chicken"),
    //       (SELECT id from ingredients WHERE name="Lemon"),"1",""),
    //     ((SELECT id from meals WHERE name="Parmesan-Crusted Chicken"),
    //       (SELECT id from ingredients WHERE name="Panko Breadcrumbs"),"1/2","cup"),
    //     ((SELECT id from meals WHERE name="Parmesan-Crusted Chicken"),
    //       (SELECT id from ingredients WHERE name="Fry Seasoning"),"1","cup"),
    //     ((SELECT id from meals WHERE name="Parmesan-Crusted Chicken"),
    //       (SELECT id from ingredients WHERE name="Parmesan Cheese"),"1","cup"),
    //     ((SELECT id from meals WHERE name="Parmesan-Crusted Chicken"),
    //       (SELECT id from ingredients WHERE name="Chicken Breast"),"1","lb"),
    //     ((SELECT id from meals WHERE name="Parmesan-Crusted Chicken"),
    //       (SELECT id from ingredients WHERE name="Dijon Mustard"),"2","Tsp"),
    //     ((SELECT id from meals WHERE name="Parmesan-Crusted Chicken"),
    //       (SELECT id from ingredients WHERE name="Mayonnaise"),"2","Tbsp"),
    //     ((SELECT id from meals WHERE name="Parmesan-Crusted Chicken"),
    //       (SELECT id from ingredients WHERE name="Spaghetti"),"6","oz"),
    //     ((SELECT id from meals WHERE name="Parmesan-Crusted Chicken"),
    //       (SELECT id from ingredients WHERE name="Grape Tomatoes"),"8","oz"),
    //     ((SELECT id from meals WHERE name="Parmesan-Crusted Chicken"),
    //       (SELECT id from ingredients WHERE name="Garlic"),"2","cloves"),
    //     ((SELECT id from meals WHERE name="Parmesan-Crusted Chicken"),
    //       (SELECT id from ingredients WHERE name="Cream Cheese"),"2","Tbsp")
    // """);
  }

  //retrieve database
  static Future<sql.Database> db() async {
    sql.databaseFactory.deleteDatabase(join(await sql.getDatabasesPath(), 'grocery.db'));
    return sql.openDatabase(join(await sql.getDatabasesPath(), 'grocery.db'), version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
      await fillTables(database);
    });
  }

  //insert new meal into meals table, and insert ingredients into
  // ingredients and meal_ingredients table.
  static Future<int> insertMeal(String mealName, List<Map> ingredients) async {
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
      INSERT INTO meals (name) VALUES (?)
    """, [mealName]);

    //check if ingredient already exists before adding new entry to
    // ingredients table. Then add all items to meal_ingredients table
    for (Map ingredient in ingredients) {
      //get ingredient matching name from db, in order to get ingredientId
      List<Map> results = await db.query("ingredients",
          columns: Ingredient.columns, where: "name = ?", whereArgs: [ingredient["name"]]);

      int ingredientId = results.isNotEmpty ? results[0]["id"] : await db.rawInsert("""
          INSERT INTO ingredients(name, category)
          VALUES (?, ?)
        """, [ingredient["name"], ingredient["category"]]);

      //insert with 'id' and ingredientId
      await db.rawInsert("""
        INSERT INTO meal_ingredients(
          meal_id, ingredient_id, qty_unit, qty) 
        VALUES(
          ?, ?, ?, ?
      )""", [id, ingredientId, ingredient["qty_unit"], ingredient["qty"]]);
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
  static Future<List<Map>> getMeals() async {
    // sql.databaseFactory
    //     .deleteDatabase(join(await sql.getDatabasesPath(), 'grocery.db'));
    final db = await SQLHelper.db();
    var result = await db.query('meals');

    List<Map> meals = [];
    for (var meal in result) {
      meals.add(meal);
    }

    return meals;
  }

  // retrieve entire list of grocery items from db using list of meals selected. All ingredients are already store in database.
  static Future<List<Map>> getIngredients(List<String> mealNames) async {
    final db = await SQLHelper.db();
    List<Map> items = [];

    for (String name in mealNames) {
      List<Map> data = await db.rawQuery("""
        SELECT m.name, ingredients.name, ingredients.category, meal_ingredients.qty, meal_ingredients.qty_unit 
        FROM (SELECT * FROM meals where meals.name = ?) as m
        INNER JOIN meal_ingredients ON m.id = meal_ingredients.meal_id
        INNER JOIN ingredients on meal_ingredients.ingredient_id = ingredients.id
      """, [name]);

      for (var item in data) {
        items.add({
          "category": item['category'],
          "item": item["name"],
          "qty": item['qty'],
          "qtyUnit": item['qty_unit']
        });
      }
    }

    return items;
  }

  //insert single grocery item

  //insert grocery list into database, check if grocery list is already empty or not.
  static Future<void> insertGroceries(List<Map<String, Object?>> groceries) async {
    final db = await SQLHelper.db();

    var batch = db.batch();
    for (Map<String, Object?> groceryItem in groceries) {
      db.insert('shopping_list', groceryItem);
    }
    await batch.commit(noResult: true);
  }

  static Future<List<Map<String, Object?>>> retrieveGroceries() async {
    List<Map<String, Object?>> items = [];
    final db = await SQLHelper.db();

    List<Map> data = await db.rawQuery("""
      SELECT * FROM shopping_list
    """);

    for (var row in data) {
      items.add(
        {
          "category": row["category"],
          "name": row["name"],
          "checked": row["checked"] == 1 ? true : false,
          "qty": row["qty"],
          "qtyUnit": row["qty_unit"]
        },
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

    // retrieve checked property from shopping_list
    var results = await db.rawQuery("""
      SELECT checked FROM shopping_list WHERE
      shopping_list.name = ?
    """, [name]);

    var checkedValue = results.first.values.first;

    // update item in shopping_list to be !checked
    await db.rawUpdate("""
      UPDATE shopping_list SET checked = ? WHERE name = ?
    """, [checkedValue == 1 ? 0 : 1, name]);
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

  static Future<void> removeShoppingItem(String name) async {
    final db = await SQLHelper.db();

    await db.rawDelete("""
      DELETE FROM shopping_list WHERE shopping_list.name = ?
    """, [name]);
  }
}

//TODO Create Models NEXT!!!! Then Repositories (groceries and one for meals)!!!