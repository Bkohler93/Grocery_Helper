import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:grocery_helper_app/data/models/section.dart';
import 'package:grocery_helper_app/data/repositories/section/section_repository.dart';

enum SectionNotifierState {
  initialized,
  loading,
  errorReordering,
  errorDeleting,
  addSectionError,
  editError,
}

class SectionNotifier extends ChangeNotifier {
  final SectionRepository _sectionRepository;
  late final List<Section> _sections;
  late SectionNotifierState state;

  SectionNotifier({
    required SectionRepository sectionRepository,
    required BuildContext context,
  }) : _sectionRepository = sectionRepository {
    state = SectionNotifierState.loading;
    _sections = [];
    notifyListeners();

    var initFuture = init(context);
    initFuture.then((voidValue) {
      state = SectionNotifierState.initialized;

      notifyListeners();
    });
  }

  Future<void> init(BuildContext context) async {
    var loadedSections = await _sectionRepository.getSections();

    _sections.addAll(loadedSections);
  }

  UnmodifiableListView<Section> get sections => UnmodifiableListView(_sections);

  void updateSectionOrder(int oldIndex, int newIndex) {
    int tmp = _sections[oldIndex].priority!;
    _sections[oldIndex].setPriority(_sections[newIndex].priority!);
    _sections[newIndex].setPriority(tmp);

    _sections.sort((a, b) => a.priority!.compareTo(b.priority!));

    notifyListeners();

    _sectionRepository.reorderSections(_sections).then((voidValue) {}, onError: (error) {
      state = SectionNotifierState.errorReordering;
      notifyListeners();
    });
  }

  void removeSection(int index) {
    Section removed = _sections.removeAt(index);

    notifyListeners();

    _sectionRepository.deleteSection(removed).then((voidValue) {}, onError: (error) {
      state = SectionNotifierState.errorDeleting;
      notifyListeners();
    });
  }

  void addSection(String name) {
    var newSection = Section(name: name, priority: _sections.last.priority! + 1);

    _sections.add(newSection);

    notifyListeners();

    _sectionRepository.addSection(name).then((id) {
      if (id == -1) {
        state = SectionNotifierState.addSectionError;
        notifyListeners();
      }
    });
  }

  void editSection(String name, int index) {
    _sections[index].setname(name);

    notifyListeners();

    _sectionRepository.editSection(_sections[index]).then((voidValue) {}, onError: (err) {
      state = SectionNotifierState.editError;
      notifyListeners();
    });
  }
}