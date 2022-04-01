class Ingredient {
  final int? id;
  final String category;
  final String name;

  static final columns = ["id", "category", "name"];

  const Ingredient({
    this.id,
    required this.category,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "category": category,
      "name": name,
    };

    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  static fromMap(Map map) {
    return Ingredient(
      category: map["category"],
      name: map["name"],
      id: map["id"],
    );
  }
}
