class GroceryItem {
  final int? id;
  final String category;
  final String name;
  String qty;
  final String qtyUnit;
  bool checkedOff = false;
  GroceryItem(
      {required this.category,
      required this.name,
      this.qty = ' ',
      this.qtyUnit = ' ',
      this.id,
      this.checkedOff = false});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "name": name,
      "category": category,
      "qty": qty,
      "checked": checkedOff ? 1 : 0,
      "qty_unit": qtyUnit
    };

    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  static fromMap(Map data) {
    return GroceryItem(
        category: data['category'],
        name: data['name'],
        qty: data['qty'] ?? ' ',
        qtyUnit: data['qty_unit'] ?? ' ');
  }
}
