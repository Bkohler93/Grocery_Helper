import 'package:grocery_helper_app/data/models/section.dart';
import 'package:grocery_helper_app/data/providers/section_provider.dart';

class SectionRepository {
  Future<List<Section>> getSections() async {
    return await SectionProvider.getSections();
  }

  Future<void> reorderSections(List<Section> sections) async {
    await SectionProvider.reorderSections(sections);
  }

  Future<void> deleteSection(Section section) async {
    await SectionProvider.deleteSection(section);
  }

  Future<int> addSection(String name) async {
    try {
      return await SectionProvider.insertSection(name);
    } catch (err) {
      return -1;
    }
  }

  Future<void> editSection(Section section) async {
    await SectionProvider.updateSection(section);
  }
}
