import 'package:flutter/material.dart';
import 'package:grocery_helper_app/business_logic/notifiers/section_notifier.dart';
import 'package:grocery_helper_app/data/models/section.dart';
import 'package:provider/provider.dart';

class SectionList extends StatelessWidget {
  const SectionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SectionNotifier>(builder: (context, sections, child) {
      return Stack(
        children: <Widget>[
          ReorderableListView(
            children: <Widget>[
              for (int index = 0; index < sections.sections.length; index += 1)
                ListTile(
                  key: Key('$index'),
                  title: Text(sections.sections[index].name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          edit(
                            context: context,
                            section: sections.sections[index],
                            onPressed: (text, section) {
                              context.read<SectionNotifier>().editSection(text, section);
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          sections.removeSection(index);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
            ],
            onReorder: (int oldIndex, int newIndex) {
              final index = newIndex > oldIndex ? newIndex - 1 : newIndex;

              sections.updateSectionOrder(oldIndex, index);
            },
          ),
          Positioned(
            right: 0,
            bottom: 30,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(15),
              ),
              child: const Icon(Icons.add, size: 45.0),
              onPressed: () {
                add(
                    onPressed: (name) {
                      context.read<SectionNotifier>().addSection(name);
                    },
                    context: context);
              },
            ),
          ),
        ],
      );
    });
  }

  void edit(
      {required Section section, required Function onPressed, required BuildContext context}) {
    final textController = TextEditingController();
    textController.text = section.name;

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
                      onPressed(textController.text, section);
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.save_outlined),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void add({required Function onPressed, required BuildContext context}) {
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
                    child: const Icon(Icons.save_outlined),
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
