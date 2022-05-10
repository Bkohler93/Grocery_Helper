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

  static final shoppingListColumns = ["rowid", "category", "name", "qty", "qty_unit", "checked"];
  static final ingredientColumns = ["rowid", "name"];

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "name": name,
      "category": category,
      "qty": qty,
      "checked": checkedOff ? 1 : 0,
      "qty_unit": qtyUnit
    };

    if (id != null) {
      map["rowid"] = id;
    }
    return map;
  }

  static fromRawQty({
    required String rawQty,
    required String category,
    required String name,
    required bool isChecked,
  }) {
    String? qty;
    String? qtyUnit;

    qty = RegExp(r"([0-9]* [0-9]*/[0-9]*)|([0-9]*/[0-9]*)|([0-9]?.[0-9]*)|([0-9]*)")
        .firstMatch(rawQty)
        ?.group(0);

    qtyUnit = rawQty.replaceAll(qty ?? ' ', '').replaceFirst(' ', '');

    return GroceryItem(
      category: category,
      name: name,
      checkedOff: isChecked,
      qty: qty ?? ' ',
      qtyUnit: qtyUnit,
    );
  }

  static fromMap(Map data) {
    return GroceryItem(
        category: data['category'],
        name: data['name'],
        checkedOff: data['checked'] == 1 ? true : false,
        id: data['rowid'] ?? data['id'],
        qty: data['qty'] ?? ' ',
        qtyUnit: data['qty_unit'] ?? ' ');
  }
}
