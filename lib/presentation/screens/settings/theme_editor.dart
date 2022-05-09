import 'package:flutter/material.dart';
import 'package:grocery_helper_app/business_logic/notifiers/section_notifier.dart';
import 'package:grocery_helper_app/data/repositories/section/section_repository.dart';
import 'package:provider/provider.dart';

class ThemeEditorPage extends StatelessWidget {
  const ThemeEditorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) =>
            SectionNotifier(context: context, sectionRepository: SectionRepository()),
        child: const ThemeEditor());
  }
}

class ThemeEditor extends StatefulWidget {
  const ThemeEditor({Key? key}) : super(key: key);

  @override
  State<ThemeEditor> createState() => _ThemeEditorState();
}

class _ThemeEditorState extends State<ThemeEditor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: const Text('Theme Editor'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 30.0),
        child: themePicker(),
      ),
    );
  }

  Widget themePicker() {
    return Text("Theme Picker goes here!");
  }
}
