class Section {
  String name;
  int? priority;
  final int? id;

  static final columns = ["rowid", "name"];

  Section({required this.name, this.id, this.priority});

  setPriority(int _priority) {
    priority = _priority;
  }

  setname(String _name) {
    name = _name;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {"name": name};

    if (id != null) {
      map["rowid"] = id;
    }

    if (priority != null) {
      map["priority"] = priority;
    }

    return map;
  }

  static fromMap(Map map) {
    return Section(name: map["name"], id: map["rowid"], priority: map['priority']);
  }
}
