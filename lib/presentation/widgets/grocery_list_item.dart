import 'package:flutter/material.dart';
import 'package:grocery_helper_app/business_logic/blocs/grocery_bloc/grocery_bloc.dart';
import 'package:grocery_helper_app/business_logic/cubits/grocery_item_cubit/grocery_item_cubit.dart';
import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/presentation/widgets/add_ingredient_modal.dart';
import 'package:grocery_helper_app/presentation/widgets/edit_indredient_modal.dart';
import 'package:provider/provider.dart';

class GroceryListItem extends StatelessWidget {
  const GroceryListItem({
    Key? key,
    required this.item,
    required this.onEdit,
    required this.isEditing,
  }) : super(key: key);

  final GroceryItem item;
  final Function(String) onEdit;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
          onLongPress: () {
            onEdit(item.name);
          },
          onTap: () {
            context.read<GroceryItemCubit>().checkItem(item);
          },
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Checkbox(
                    value: item.checkedOff,
                    splashRadius: 0.0,
                    onChanged: (value) {
                      context.read<GroceryItemCubit>().checkItem(item);
                    }),
                SizedBox(
                  child: Text(
                    item.name,
                    style: TextStyle(
                      decoration: item.checkedOff ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  width: 100.0,
                ),
                isEditing
                    ? SizedBox(
                        width: 105,
                        child: ButtonBar(
                          buttonPadding: const EdgeInsets.all(0),
                          children: [
                            SizedBox(
                                width: 40,
                                child: TextButton(
                                  child: const Icon(Icons.edit, size: 20),
                                  onPressed: () {
                                    showModalBottomSheet<void>(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        return FractionallySizedBox(
                                          heightFactor: 0.7,
                                          child: EditIngredientModal(item: item),
                                        );
                                      },
                                    );
                                  },
                                )),
                            SizedBox(
                              width: 40,
                              child: TextButton(
                                onPressed: () {
                                  context.read<GroceryBloc>().add(DeleteGroceryEvent(id: item.id!));
                                },
                                child: const Icon(Icons.delete, size: 20),
                              ),
                            )
                          ],
                        ),
                      )
                    : const SizedBox(width: 105),
                Container(
                  child: Text(
                    item.qty + ' ' + item.qtyUnit,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  width: 50.0,
                  alignment: Alignment.centerRight,
                ),
              ],
            ),
          )),
    );
  }
}
