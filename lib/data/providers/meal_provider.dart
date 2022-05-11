import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/models/meal.dart';
import 'package:grocery_helper_app/data/providers/grocery_provider.dart';
import 'package:grocery_helper_app/data/providers/sqlite_mixin.dart';

class MealProvider with SQLite {
  //retrieve list of meals
  static Future<List<Meal>> getMeals() async {
    // sql.databaseFactory
    //     .deleteDatabase(join(await sql.getDatabasesPath(), 'grocery.db'));
    final db = await SQLite.db();
    var result = await db.query('meals', columns: ['name', 'checked', 'rowid']);

    List<Meal> meals = [];
    for (var meal in result) {
      meals.add(Meal.fromMap(meal));
    }
    return meals;
  }

  static Future<void> deleteMeal(Meal meal) async {
    final db = await SQLite.db();

    await db.rawDelete("""
      DELETE FROM meal_ingredients WHERE meal_ingredients.meal_id = ?  
    """, [meal.id]);
    await db.rawDelete("""
      DELETE FROM meals WHERE meals.rowid = ?
    """, [meal.id]);
  }

  //insert new meal into meals table, and insert ingredients into
  // ingredients and meal_ingredients table.
  static Future<int> insertMeal(String mealName, List<GroceryItem> ingredients) async {
    final db = await SQLite.db();
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
      List<Map> results = await db.rawQuery("""
        SELECT rowid, name FROM ingredients WHERE name = ?
      """, [ingredient.name]);
      // List<Map> results = await db.query("ingredients",
      //     columns: GroceryItem.ingredientColumns, where: "name = ?", whereArgs: [ingredient.name]);

      int ingredientId = results.isNotEmpty ? results[0]["rowid"] : await db.rawInsert("""
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
    final db = await SQLite.db();

    final id = await db.insert('ingredients', ingredient,
        conflictAlgorithm: SQLite.conflictAlgorithmReplace);
    return id;
  }

  // retrieve entire list of grocery items from db using list of meals selected. All ingredients are already store in database.
  static Future<List<GroceryItem>> getIngredients(List<String> mealNames) async {
    final db = await SQLite.db();
    List<GroceryItem> items = [];

    for (String name in mealNames) {
      // List<Map> data = await db.rawQuery("""
      //   SELECT m.name, ingredients.name, ingredients.category, meal_ingredients.qty, meal_ingredients.qty_unit, meal_ingredients.rowid
      //   FROM (SELECT * FROM meals where meals.name = ?) as m
      //   INNER JOIN meal_ingredients ON m.rowid = meal_ingredients.meal_id
      //   INNER JOIN ingredients on meal_ingredients.ingredient_id = ingredients.rowid
      // """, [name]);

      // List<Map> data = await db.rawQuery("""
      //   SELECT .OrderID, o.OrderDate, c.CustomerName
      //   FROM Customers AS c, Orders AS o
      //   WHERE c.CustomerName="Around the Horn" AND c.CustomerID=o.CustomerID;
      // """, [name]);

      List<Map> data = await db.rawQuery("""
        SELECT i.category, i.name, mi.qty, mi.qty_unit, mi.rowid
        FROM ingredients AS i, meal_ingredients AS mi, meals as m
        WHERE m.name=? AND mi.meal_id=m.rowid AND mi.ingredient_id=i.rowid
      """, [name]);

      for (var item in data) {
        items.add(GroceryItem.fromMap({
          "category": item['category'],
          "name": item["name"],
          "qty": item['qty'],
          "qty_unit": item['qty_unit'],
          "rowid": item['rowid'],
          "checked": 0,
        }));
      }
    }

    return items;
  }

  static Future<int> updateMeal(Meal meal) async {
    final db = await SQLite.db();

    return await db.rawUpdate("""
      UPDATE meals SET name = ?, checked = ?
      WHERE rowid = ?
    """, [meal.name, meal.checked ? 1 : 0, meal.id]);
  }

  static Future<bool> mealExists(String name, int id) async {
    final db = await SQLite.db();

    var results = await db.rawQuery("""
      SELECT * FROM meals WHERE name = ? AND rowid != ?
    """, [name, id]);

    return results.isNotEmpty;
  }

  static Future<void> updateMealAndIngredients(Meal meal, List<GroceryItem> items) async {
    final db = await SQLite.db();

    await db.rawDelete("""
      DELETE FROM meal_ingredients WHERE meal_id = ?
    """, [meal.id]);

    await db.rawDelete("""
      DELETE FROM meals WHERE rowid = ?
    """, [meal.id]);

    await insertMeal(meal.name, items);
  }

  //insert grocery list into database
  static Future<void> insertGroceries(List<GroceryItem> groceries) async {
    final db = await SQLite.db();

    var batch = db.batch();
    for (var groceryItem in groceries) {
      await GroceryProvider.insertGrocery(groceryItem);
    }
    await batch.commit(noResult: true);
  }
}
