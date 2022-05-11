import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/repositories/grocery/i_grocery_repository.dart';

var mockGroceries = <GroceryItem>[
  GroceryItem(category: 'produce', name: 'banana', qty: '1', qtyUnit: '', id: 1, checkedOff: false),
  GroceryItem(
      category: 'meat', name: 'ground beef', qty: '1', qtyUnit: 'lb', id: 2, checkedOff: false),
  GroceryItem(category: 'deli', name: 'cheese', qty: '10', qtyUnit: 'oz', id: 3, checkedOff: false),
];

class MockGroceryRepository implements IGroceryRepository {
  @override
  Future<int> addGroceryItem(GroceryItem item) async {
    await Future.delayed(const Duration(microseconds: 500));

    var newId = mockGroceries.length + 1;

    mockGroceries.add(GroceryItem(
        category: item.category,
        name: item.name,
        qty: item.qty,
        qtyUnit: item.qtyUnit,
        id: newId,
        checkedOff: false));

    return newId;
  }

  @override
  Future<void> addGroceryItems(List<GroceryItem> items) async {
    await Future.delayed(const Duration(microseconds: 500));

    for (var item in items) {
      await addGroceryItem(item);
    }
  }

  @override
  Future<void> checkOffGroceryItem(GroceryItem item) async {
    await Future.delayed(const Duration(microseconds: 500));
  }

  @override
  Future<int> deleteGroceryItem({int? id, String? name}) {
    throw UnimplementedError();
  }

  @override
  Future<List<GroceryItem>> getGroceries() {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, List<GroceryItem>>> getGroceriesByCategory() {
    throw UnimplementedError();
  }

  @override
  Future<int> updateGroceryItem(GroceryItem item) {
    throw UnimplementedError();
  }

  @override
  Future<void> clearGroceryItems() {
    throw UnimplementedError();
  }
}
