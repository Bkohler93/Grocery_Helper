import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/grocery_list.dart';

class GroceryListItem extends StatefulWidget {
  const GroceryListItem(
      this.name, this.qty, this.qtyUnit, this.category, this.checkedOff, this.handleCheckedOff,
      {Key? key})
      : super(key: key);

  final String name;
  final String qtyUnit;
  final String qty;
  final String category;
  final bool checkedOff;
  final ValueChanged<bool> handleCheckedOff;

  @override
  _GroceryItemState createState() => _GroceryItemState();
}

class _GroceryItemState extends State<GroceryListItem> {
  late bool _checkedOff;
  bool _isEditing = false;

  _GroceryItemState();

  @override
  void initState() {
    super.initState();
    _checkedOff = widget.checkedOff;
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
            Provider.of<GroceryListModel>(context, listen: false).checkItem(
              name: widget.name,
              category: widget.category,
            );
            setState(() {
              _checkedOff = !_checkedOff;
              widget.handleCheckedOff(_checkedOff);
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
                    value: _checkedOff,
                    splashRadius: 0.0,
                    onChanged: (value) {
                      Provider.of<GroceryListModel>(context, listen: false).checkItem(
                        name: widget.name,
                        category: widget.category,
                      );
                      setState(() {
                        _checkedOff = !_checkedOff;
                        widget.handleCheckedOff(_checkedOff);
                      });
                    }),
                SizedBox(
                  child: Text(
                    widget.name,
                    style: TextStyle(
                      decoration: _checkedOff ? TextDecoration.lineThrough : null,
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
                                  onPressed: () {},
                                )),
                            SizedBox(
                              width: 40,
                              child: TextButton(
                                onPressed: () {
                                  Provider.of<GroceryListModel>(context, listen: false)
                                      .deleteItem(name: widget.name, category: widget.category);
                                  setState(() {
                                    _isEditing = !_isEditing;
                                    _checkedOff = !_checkedOff;
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
                    widget.qty + ' ' + widget.qtyUnit,
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
