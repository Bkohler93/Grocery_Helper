import 'package:grocery_helper_app/data/models/grocery_item.dart';

abstract class IGroceryRepository {
  Future<List<GroceryItem>> getGroceries();
  Future<int> addGroceryItem(GroceryItem item);
  Future<int> deleteGroceryItem(int id);
  Future<int> updateGroceryItem(GroceryItem item);
  Future<int> addGroceryItems(List<GroceryItem> items);
}
