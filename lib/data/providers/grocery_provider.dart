import 'package:fraction/fraction.dart';
import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/providers/sqlite_mixin.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;

class GroceryProvider with SQLite {
  //insert grocery list into database
  static Future<void> insertGroceries(List<GroceryItem> groceries) async {
    final db = await SQLite.db();

    var batch = db.batch();
    for (var groceryItem in groceries) {
      await insertGrocery(groceryItem);
    }
    await batch.commit(noResult: true);
  }

  static Future<int> insertGrocery(GroceryItem item) async {
    final db = await SQLite.db();

    //find matching grocery item in list
    var queryResult = await db.rawQuery("""
      SELECT rowid, name, qty, category, qty_unit FROM shopping_list WHERE name = ?
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

            final totalQtyReduced = totalQtyFrac.reduce();
            final totalQtyStr = totalQtyReduced.toString();

            return await db.rawUpdate("""
              UPDATE shopping_list SET qty = ? 
              WHERE rowid = ?""", [totalQtyStr, entry['rowid']]);
          } else {
            return await db.rawUpdate("""
              UPDATE shopping_list SET qty=? 
              WHERE rowid = ?
              """, [int.parse(entry['qty'].toString()) + int.parse(item.qty), entry['rowid']]);
          }
        }
      }
    }
    return await db.rawInsert("""
        INSERT INTO shopping_list (name, category, checked, qty, qty_unit) 
        VALUES (?, ?, ?, ?, ?)
      """, [item.name, item.category, item.checkedOff, item.qty, item.qtyUnit]);
  }

  static Future<int> removeShoppingItem({int? id, String? name}) async {
    final db = await SQLite.db();
    if (id != null && id != 0) {
      return await db.rawDelete("""
      DELETE FROM shopping_list WHERE shopping_list.rowid = ?
    """, [id]);
    } else {
      return await db.rawDelete("""
      DELETE FROM shopping_list WHERE shopping_list.name = ?
    """, [name]);
    }
  }

  static Future<int> updateShoppingItem(GroceryItem item) async {
    final db = await SQLite.db();

    return await db.rawUpdate("""
      UPDATE shopping_list SET name = ?, qty = ?, qty_unit = ?, category = ?, checked = ? 
      WHERE rowid = ?
    """, [item.name, item.qty, item.qtyUnit, item.category, item.checkedOff ? 1 : 0, item.id]);
  }

  static Future<List<GroceryItem>> retrieveGroceries() async {
    List<GroceryItem> items = [];
    final db = await SQLite.db();

    List<Map> data = await db.query('shopping_list', columns: GroceryItem.ingredientColumns);

    for (var row in data) {
      items.add(GroceryItem.fromMap(
        {
          "category": row["category"],
          "name": row["name"],
          "checked": row["checked"],
          'rowid': row['rowid'],
          "qty": row["qty"],
          "qty_unit": row["qty_unit"]
        },
      ));
    }

    return items;
  }

  static Future<void> updateCheckedItem(GroceryItem item) async {
    final db = await SQLite.db();

    await db.rawUpdate("""
      UPDATE shopping_list SET checked = ? WHERE rowid = ?
    """, [item.checkedOff ? 1 : 0, item.id]);
  }

  static Future<void> clearGroceryList() async {
    final db = await SQLite.db();

    await db.delete('shopping_list');
  }
}
