class Meal {
  final String name;
  final bool checked;
  final int? id;

  static final columns = ["id", "name"];

  Meal({required this.name, this.id, required this.checked});

  Meal checkOff() {
    return Meal(checked: !checked, id: id, name: name);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {"name": name, "checked": checked};

    if (id != null) {
      map["id"] = id;
    }

    return map;
  }

  static fromMap(Map map) {
    return Meal(name: map["name"], id: map["id"], checked: map['checked'] == 1 ? true : false);
  }
}
