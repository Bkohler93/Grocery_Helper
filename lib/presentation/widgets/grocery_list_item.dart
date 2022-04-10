import 'package:flutter/material.dart';
import 'package:grocery_helper_app/business_logic/blocs/grocery_bloc/grocery_bloc.dart';
import 'package:grocery_helper_app/business_logic/cubits/grocery_item_cubit/grocery_item_cubit.dart';
import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:provider/provider.dart';

class GroceryListItem extends StatefulWidget {
  const GroceryListItem({Key? key, required GroceryItem item})
      : item = item,
        super(key: key);

  final GroceryItem item;

  @override
  _GroceryItemState createState() => _GroceryItemState();
}

class _GroceryItemState extends State<GroceryListItem> {
  bool _isEditing = false;
  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.item.checkedOff;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
          onLongPress: () {
            setState(() {
              _isEditing = !_isEditing;
            });
          },
          onTap: () {
            context.read<GroceryItemCubit>().checkItem(widget.item);
            setState(() {
              _isSelected = !_isSelected;
            });
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
                    value: _isSelected,
                    splashRadius: 0.0,
                    onChanged: (value) {
                      context.read<GroceryItemCubit>().checkItem(widget.item);
                      setState(() {
                        _isSelected = !_isSelected;
                      });
                    }),
                SizedBox(
                  child: Text(
                    widget.item.name,
                    style: TextStyle(
                      decoration: _isSelected ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  width: 100.0,
                ),
                _isEditing
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
                                    //TODO edit ingredient page/popup
                                  },
                                )),
                            SizedBox(
                              width: 40,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isEditing = !_isEditing;
                                    //TODO Grocery Bloc delete grocery item
                                  });
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
                    widget.item.qty + ' ' + widget.item.qtyUnit,
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
