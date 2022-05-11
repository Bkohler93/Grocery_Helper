import 'package:grocery_helper_app/data/models/section.dart';
import 'package:grocery_helper_app/data/providers/sqlite_mixin.dart';

class SectionProvider with SQLite {
  static Future<int> insertSection(String name) async {
    final db = await SQLite.db();

    Section section = Section(name: name);

    return await db.insert('sections', section.toMap(),
        conflictAlgorithm: SQLite.conflictAlgorithmAbort);
  }

  static Future<void> reorderSections(List<Section> sections) async {
    final db = await SQLite.db();

    var batch = db.batch();
    for (var section in sections) {
      await db.update('sections', section.toMap(), where: 'rowid = ?', whereArgs: [section.id]);
    }
    await batch.commit(noResult: true);
  }

  static Future<List<Section>> getSections() async {
    final db = await SQLite.db();

    var data =
        await db.query('sections', columns: ['rowid', 'name', 'priority'], orderBy: 'priority');
    return [for (var datum in data) Section.fromMap(datum)];
  }

  static Future<void> deleteSection(Section section) async {
    final db = await SQLite.db();

    await db.delete('sections', where: 'rowid = ?', whereArgs: [section.id]);
  }

  static Future<void> updateSection(Section section) async {
    final db = await SQLite.db();

    await db.update('sections', section.toMap(), where: 'rowid = ?', whereArgs: [section.id]);
  }
}
