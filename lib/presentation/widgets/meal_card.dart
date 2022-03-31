import 'package:flutter/material.dart';

class MealCard extends StatelessWidget {
  const MealCard(this.name, this.isSelected, this.isEditing, this.onSelected, this.onEditingMeal,
      this.onDeleteMeal, this.idx,
      {Key? key})
      : super(key: key);

  final String name;
  final bool isSelected;
  final bool isEditing;
  final ValueChanged<int> onSelected;
  final ValueChanged<int> onEditingMeal;
  final ValueChanged<String> onDeleteMeal;
  final int idx;

  void _handleTap() {
    onSelected(idx);
  }

  void _handleLongPress() {
    onEditingMeal(idx);
  }

  void _handleDelete() {
    onDeleteMeal(name);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
          onTap: _handleTap,
          onLongPress: _handleLongPress,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 15.0,
              bottom: 15.0,
              left: 10.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(15.0),
                  height: 18.0,
                  width: 18.0,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : null,
                    shape: BoxShape.circle,
                  ),
                ),
                Text(name),
                const Spacer(),
                isEditing
                    ? SizedBox(
                        height: 50,
                        child: ButtonBar(
                          children: [
                            SizedBox(
                                width: 40,
                                child: TextButton(
                                  child: const Icon(Icons.edit, size: 20),
                                  onPressed: () {},
                                )),
                            SizedBox(
                              width: 40,
                              child: TextButton(
                                onPressed: _handleDelete,
                                child: const Icon(Icons.delete, size: 20),
                              ),
                            )
                          ],
                        ),
                      )
                    : const SizedBox(height: 50.0)
              ],
            ),
          )),
    );
  }
}
