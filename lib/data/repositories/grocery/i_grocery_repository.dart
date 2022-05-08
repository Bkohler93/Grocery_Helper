import 'package:grocery_helper_app/data/models/grocery_item.dart';

abstract class IGroceryRepository {
  Future<List<GroceryItem>> getGroceries();
  //TODO implement user settings provider that has their preferred order of categories
  Future<Map<String, List<GroceryItem>>> getGroceriesByCategory();
  Future<int> addGroceryItem(GroceryItem item);
  Future<int> deleteGroceryItem({int? id, String? name});
  Future<int> updateGroceryItem(GroceryItem item);
  Future<void> addGroceryItems(List<GroceryItem> items);
  Future<void> checkOffGroceryItem(GroceryItem item);
  Future<void> clearGroceryItems();
}
