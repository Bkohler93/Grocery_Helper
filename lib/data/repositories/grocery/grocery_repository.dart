import 'package:grocery_helper_app/data/db_provider.dart';
import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/repositories/grocery/i_grocery_repository.dart';

class GroceryRepository implements IGroceryRepository {
  @override
  Future<int> addGroceryItem(GroceryItem item) {
    int id = SQLHelper.()
  }

  @override
  Future<int> addGroceryItems(List<GroceryItem> items) {
    // TODO: implement addGroceryItems
    throw UnimplementedError();
  }

  @override
  Future<int> deleteGroceryItem(int id) {
    // TODO: implement deleteGroceryItem
    throw UnimplementedError();
  }

  @override
  Future<List<GroceryItem>> getGroceries() {
    // TODO: implement getGroceries
    throw UnimplementedError();
  }

  @override
  Future<int> updateGroceryItem(GroceryItem item) {
    // TODO: implement updateGroceryItem
    throw UnimplementedError();
  }

}