class Section {
  final String name;
  final int? priority;
  final int? id;

  static final columns = ["id", "name"];

  Section({required this.name, this.id, this.priority});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {"name": name};

    if (id != null) {
      map["id"] = id;
    }

    if (priority != null) {
      map["priority"] = priority;
    }

    return map;
  }

  static fromMap(Map map) {
    return Section(name: map["name"], id: map["id"], priority: map['priority']);
  }
}
