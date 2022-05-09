import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_helper_app/business_logic/blocs/meal_bloc/meal_bloc.dart';
import 'package:grocery_helper_app/business_logic/notifiers/section_notifier.dart';
import 'package:grocery_helper_app/data/models/meal.dart';
import 'package:grocery_helper_app/data/repositories/section/section_repository.dart';
import 'package:grocery_helper_app/presentation/widgets/section_list.dart';
import 'package:grocery_helper_app/presentation/widgets/settings_choice.dart';
import 'package:provider/provider.dart';

class SectionEditorPage extends StatelessWidget {
  const SectionEditorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) =>
            SectionNotifier(context: context, sectionRepository: SectionRepository()),
        child: const SectionEditor());
  }
}

class SectionEditor extends StatefulWidget {
  const SectionEditor({Key? key}) : super(key: key);

  @override
  State<SectionEditor> createState() => _SectionEditorState();
}

class _SectionEditorState extends State<SectionEditor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: const Text('Section Editor'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 30.0),
        child: SectionList(),
      ),
    );
  }

  void edit({required Function onPressed}) {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 5,
                  child: TextFormField(
                    controller: textController,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: TextButton(
                    onPressed: () {
                      onPressed(textController.text);
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.save_outlined),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
