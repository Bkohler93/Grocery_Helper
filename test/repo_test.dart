import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_helper_app/data/models/section.dart';
import 'package:grocery_helper_app/data/repositories/grocery/grocery_repository.dart';
import 'package:grocery_helper_app/data/repositories/meal/meal_repository.dart';
import 'package:grocery_helper_app/data/repositories/section/section_repository.dart';

void main() {
  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
  });
  test('meals retrieved from database', () async {
    final repository = MealRepository();

    var meals = await repository.getMeals();

    expect(meals.isNotEmpty, true);
  });

  test('grocery list retrieve from database', () async {
    final repository = GroceryRepository();

    var groceries = await repository.getGroceries();

    expect(groceries.isNotEmpty, true);
  });

  test('retrieve all sections', () async {
    final sectionRepository = SectionRepository();

    var sections = await sectionRepository.getSections();
    expect(sections.isNotEmpty, true);
  });

  test('change priorities on section items results in swapped order', () async {
    final sectionRepository = SectionRepository();
    var sections = await sectionRepository.getSections();
    var originalFirstid = sections[0].id;

    //swap prioirities for first and second element
    var tmp = sections[0].priority;
    sections[0] = Section.fromMap(
        {'name': sections[0].name, 'rowid': sections[0].id, 'priority': sections[1].priority});
    sections[1] =
        Section.fromMap({'name': sections[1].name, 'rowid': sections[1].id, 'priority': tmp});

    await sectionRepository.reorderSections(sections);

    var newSections = await sectionRepository.getSections();
    expect(newSections[1].id, originalFirstid);
  });

  test('delete section results in fewer sections from db', () async {
    final sectionRepository = SectionRepository();
    var sections = await sectionRepository.getSections();
    int firstLength = sections.length;

    await sectionRepository.deleteSection(sections[0]);

    sections = await sectionRepository.getSections();
    int newLength = sections.length;

    expect(newLength, firstLength - 1);
  });

  test('add section results in more sections from db', () async {
    final sectionRepository = SectionRepository();
    var sections = await sectionRepository.getSections();
    int firstLength = sections.length;

    await sectionRepository.addSection('ethnic');

    sections = await sectionRepository.getSections();

    int newLength = sections.length;

    //cleanup
    try {
      Section ethnicSection = sections.firstWhere((section) => section.name == 'ethnic');
      await sectionRepository.deleteSection(ethnicSection);
    } catch (err) {
      expect(err, err);
    }

    expect(newLength, firstLength + 1);
  });

  test('change name of section persists', () async {
    final sectionRepository = SectionRepository();

    int id = await sectionRepository.addSection('test');

    await sectionRepository.editSection(Section(name: 'testerr', id: id));

    var sections = await sectionRepository.getSections();

    bool foundTesterr = sections.any((section) => section.name == 'testerr');

    //cleanup
    try {
      Section testSection = sections.firstWhere((section) => section.name == 'testerr');
      await sectionRepository.deleteSection(testSection);
    } catch (err) {
      expect(err, err);
    }

    expect(foundTesterr, true);
  });
}
