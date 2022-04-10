import 'package:grocery_helper_app/data/db_provider.dart';
import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/repositories/grocery/i_grocery_repository.dart';

class GroceryRepository implements IGroceryRepository {
  @override
  Future<int> addGroceryItem(GroceryItem item) async {
    var id = await SQLHelper.insertGrocery(item);
    return id;
  }

  @override
  Future<void> addGroceryItems(List<GroceryItem> items) async {
    await SQLHelper.insertGroceries(items);
  }

  @override
  Future<int> deleteGroceryItem(int id) async {
    return await SQLHelper.removeShoppingItem(id);
  }

  @override
  Future<List<GroceryItem>> getGroceries() async {
    return await SQLHelper.retrieveGroceries();
  }

  @override
  Future<int> updateGroceryItem(GroceryItem item) async {
    return await SQLHelper.updateShoppingItem(item);
  }

  @override
  Future<Map<String, List<GroceryItem>>> getGroceriesByCategory() async {
    List<GroceryItem> items = await SQLHelper.retrieveGroceries();

    Map<String, List<GroceryItem>> groupedList = {};
    for (var item in items) {
      if (groupedList[item.category] == null) {
        groupedList[item.category] = [];
      }
      groupedList[item.category]!.add(item);
    }

    return groupedList;
  }

  @override
  Future<void> checkOffGroceryItem(GroceryItem item) async {
    GroceryItem checkedItem = GroceryItem.fromMap({
      'category': item.category,
      'name': item.name,
      'checked': item.checkedOff ? 0 : 1, //flip sign of checked since checking item
      'id': item.id,
      'qty': item.qty,
      'qty_unit': item.qtyUnit,
    });
    await SQLHelper.updateCheckedItem(checkedItem);
  }

  @override
  Future<void> clearGroceryItems() async {
    await SQLHelper.clearGroceryList();
  }
}
