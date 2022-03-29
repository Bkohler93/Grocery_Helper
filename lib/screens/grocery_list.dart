import 'package:flutter/material.dart';
import 'package:grocery_helper_app/extensions/string.dart';
import 'package:provider/provider.dart';

import '../models/grocery_list.dart';
import '../widgets/grocery_list_item.dart';

class GroceryListPage extends StatefulWidget {
  const GroceryListPage({Key? key}) : super(key: key);

  @override
  _GroceryListPageState createState() => _GroceryListPageState();
}

class _GroceryListPageState extends State<GroceryListPage> {
  int _numCheckedOff = 0;
  late final int _numGroceries;
  final textNameController = TextEditingController();
  final textQtyController = TextEditingController();
  final textCategoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void incrementNumCheckedOff(bool isIncreasing) {
    setState(() {
      _numCheckedOff += isIncreasing ? 1 : -1;
    });
    if (_numCheckedOff == _numGroceries) {
      Provider.of<GroceryListModel>(context, listen: false).removeAll();
    }
  }

  void _addGroceryItem() {
    String itemName = textNameController.text.capitalize();
    List<String> itemQtyUnit = textQtyController.text.split(' ');
    String category = textCategoryController.text.capitalize();

    if (itemQtyUnit.length > 1) {
      Provider.of<GroceryListModel>(context, listen: false).addUserEnteredGroceryItem(GroceryItem(
        category,
        itemName,
        qty: itemQtyUnit[0].capitalize(),
        qtyUnit: itemQtyUnit[1].capitalize(),
      ));
    } else if (itemQtyUnit.length == 1) {
      Provider.of<GroceryListModel>(context, listen: false).addUserEnteredGroceryItem(GroceryItem(
        category,
        itemName,
        qty: itemQtyUnit[0].capitalize(),
      ));
    } else {
      Provider.of<GroceryListModel>(context, listen: false)
          .addUserEnteredGroceryItem(GroceryItem(category, itemName));
    }
  }

  @override
  void initState() {
    super.initState();
    _numGroceries = Provider.of<GroceryListModel>(context, listen: false).groceryListSize;
    _numCheckedOff = Provider.of<GroceryListModel>(context, listen: false).numGroceriesChecked;
  }

  @override
  void dispose() {
    textNameController.dispose();
    textQtyController.dispose();
    textCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GroceryListModel>(builder: (context, groceryList, child) {
      return Stack(
        children: <Widget>[
          ListView(
            children: groceryList.groceries.entries.map((e) {
              return Column(children: [
                Padding(
                  child: Text(
                    e.key,
                    style: const TextStyle(color: Colors.black26),
                  ),
                  padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                ),
                Column(
                  children: e.value.groceryItems.entries.map((en) {
                    return GroceryListItem(
                      en.value.name,
                      en.value.qty,
                      en.value.qtyUnit,
                      en.value.category,
                      en.value.checkedOff,
                      incrementNumCheckedOff,
                    );
                  }).toList(),
                ),
              ]);
            }).toList(),
          ),
          Positioned(
            child: ElevatedButton(
              child: const Text(
                '+',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.w300),
              ),
              onPressed: () {
                _addGroceryItemModal(context, _addGroceryItem);
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(75, 75),
                shape: const CircleBorder(),
              ),
            ),
            bottom: 40,
            right: 40,
          )
        ],
      );
    });
  }

  void _addGroceryItemModal(BuildContext context, Function _addGroceryItem) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Form(
            key: _formKey,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 6 / 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Text("Add an item"),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 25,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                  Row(children: <Widget>[
                    SizedBox(
                      child: TextFormField(
                          controller: textNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter name';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Banana',
                          )),
                      width: MediaQuery.of(context).size.width * 0.26,
                    ),
                    SizedBox(
                      child: TextFormField(
                        controller: textQtyController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter a quantity';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '1 bunch',
                        ),
                      ),
                      width: MediaQuery.of(context).size.width * 0.26,
                    ),
                    SizedBox(
                      child: TextFormField(
                        controller: textCategoryController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter a category';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'produce',
                        ),
                      ),
                      width: MediaQuery.of(context).size.width * 0.26,
                    ),
                    const Spacer(),
                    TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _addGroceryItem();
                            textNameController.clear();
                            textQtyController.clear();
                            textCategoryController.clear();
                          }
                        },
                        child: const Text('Add'))
                  ]),
                ]),
              ),
            ),
          );
        });
  }
}
