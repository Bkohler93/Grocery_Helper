import 'package:grocery_helper_app/data/db_provider.dart';
import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/models/section.dart';

class SectionRepository {
  Future<List<Section>> getSections() async {
    return await SQLHelper.getSections();
  }

  Future<void> reorderSections(List<Section> sections) async {
    await SQLHelper.reorderSections(sections);
  }

  Future<void> deleteSection(Section section) async {
    await SQLHelper.deleteSection(section);
  }

  Future<int> addSection(String name) async {
    try {
      return await SQLHelper.insertSection(name);
    } catch (err) {
      return -1;
    }
  }

  Future<void> editSection(Section section) async {
    await SQLHelper.updateSection(section);
  }
}
