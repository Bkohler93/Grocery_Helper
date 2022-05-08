import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/providers/grocery_provider.dart';
import 'package:grocery_helper_app/data/repositories/grocery/i_grocery_repository.dart';

class GroceryRepository implements IGroceryRepository {
  @override
  Future<int> addGroceryItem(GroceryItem item) async {
    var id = await GroceryProvider.insertGrocery(item);
    return id;
  }

  @override
  Future<void> addGroceryItems(List<GroceryItem> items) async {
    await GroceryProvider.insertGroceries(items);
  }

  @override
  Future<int> deleteGroceryItem(int id) async {
    return await GroceryProvider.removeShoppingItem(id);
  }

  @override
  Future<List<GroceryItem>> getGroceries() async {
    return await GroceryProvider.retrieveGroceries();
  }

  @override
  Future<int> updateGroceryItem(GroceryItem item) async {
    return await GroceryProvider.updateShoppingItem(item);
  }

  @override
  Future<Map<String, List<GroceryItem>>> getGroceriesByCategory() async {
    List<GroceryItem> items = await GroceryProvider.retrieveGroceries();

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
    await GroceryProvider.updateCheckedItem(checkedItem);
  }

  @override
  Future<void> clearGroceryItems() async {
    await GroceryProvider.clearGroceryList();
  }
}
