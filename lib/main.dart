import 'dart:collection';

import 'package:grocery_helper_app/models/grocery_list.dart';
import 'package:flutter/material.dart';
import 'package:grocery_helper_app/models/meal.dart';
import 'package:provider/provider.dart';
import 'package:grocery_helper_app/data/db.dart';
import 'package:progress_indicators/progress_indicators.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) => GroceryListModel(),
      child: MaterialApp(
          home: const MyApp(),
          title: "Grocery Helper",
          theme: ThemeData(primarySwatch: Colors.blue)),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<GroceryListModel>(context, listen: false).wakeUp();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
                tabs: [Tab(icon: Icon(Icons.restaurant_menu)), Tab(icon: Icon(Icons.checklist))]),
            title: const Text('Grocery Helper'),
            actions: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 3, 10, 0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(4.0),
                        primary: Colors.white,
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddMealPage()),
                        );
                      },
                      child: const Text('Add Meal'),
                    )),
              ),
            ],
          ),
          body: const TabBarView(
            children: [ChooseMealsPage(), GroceryListPage()],
          )),
    );
  }
}

class ChooseMealsPage extends StatefulWidget {
  const ChooseMealsPage({Key? key}) : super(key: key);

  @override
  _ChooseMealsPageState createState() => _ChooseMealsPageState();
}

class _ChooseMealsPageState extends State<ChooseMealsPage> {
  List<Map<String, dynamic>> mealViews = [];

  void _refreshMeals() async {
    final data = await SQLHelper.getMeals();

    var _mealViews = [
      for (var meal in data)
        {
          "isSelected": false,
          "isEditing": false,
          "name": meal.name,
        }
    ];

    setState(() {
      mealViews = _mealViews;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshMeals();
    Provider.of<GroceryListModel>(context, listen: false).wakeUp();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    void _handleMealSelected(int idx) {
      setState(() {
        mealViews[idx]['isSelected'] = !mealViews[idx]['isSelected'];
      });
    }

    void _handleDeleteMeal(String name) async {
      await SQLHelper.deleteMeal(name);

      _refreshMeals();
    }

    void _handleEditingMeal(int idx) {
      setState(() {
        mealViews[idx]['isEditing'] = !mealViews[idx]['isEditing'];
      });
    }

    void _handleBuildGroceryList() async {
      List<String> mealsToAdd = [];
      for (var mealView in mealViews) {
        if (mealView['isSelected']) {
          mealsToAdd.add(mealView['name']);
        }
      }
      await Provider.of<GroceryListModel>(context, listen: false).addMealsToList(mealsToAdd);
    }

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        ListView(
          children: mealViews
              .asMap()
              .entries
              .map((entry) => MealCard(
                    entry.value['name'],
                    entry.value['isSelected'],
                    entry.value['isEditing'],
                    _handleMealSelected,
                    _handleEditingMeal,
                    _handleDeleteMeal,
                    entry.key,
                  ))
              .toList(),
        ),
        Positioned(
          bottom: 50.0,
          width: 300.0,
          height: 60.0,
          child: ElevatedButton(
            style: style,
            onPressed: _handleBuildGroceryList,
            child: const Text("Build Grocery List"),
          ),
        ),
        Positioned(
          bottom: 150,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
                color: Colors.blue,
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    _refreshMeals();
                  },
                  child: RichText(
                    text: const TextSpan(
                      children: [WidgetSpan(child: Icon(Icons.refresh, size: 24))],
                    ),
                  ),
                )),
          ),
        ),
      ],
    );
  }
}

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
    String itemName = textNameController.text;
    List<String> itemQtyUnit = textQtyController.text.split(' ');
    String category = textCategoryController.text;

    if (itemQtyUnit.length > 1) {
      Provider.of<GroceryListModel>(context, listen: false).addUserEnteredGroceryItem(GroceryItem(
        category,
        itemName,
        qty: itemQtyUnit[0],
        qtyUnit: itemQtyUnit[1],
      ));
    } else if (itemQtyUnit.length == 1) {
      Provider.of<GroceryListModel>(context, listen: false).addUserEnteredGroceryItem(GroceryItem(
        category,
        itemName,
        qty: itemQtyUnit[0],
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

class AddMealPage extends StatefulWidget {
  const AddMealPage({Key? key}) : super(key: key);

  @override
  _AddMealPageState createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  final _ingredientFormKey = GlobalKey<FormState>();
  final ingredientNameController = TextEditingController();
  final categoryController = TextEditingController();
  final qtyController = TextEditingController();
  final mealNameController = TextEditingController();

  final List<GroceryItem> _ingredients = [];

  void _addGroceryItem() {
    String itemName = ingredientNameController.text;
    List<String> itemQtyUnit = qtyController.text.split(' ');
    String category = categoryController.text;

    if (itemQtyUnit.length > 1) {
      setState(() {
        _ingredients.add(GroceryItem(
          category,
          itemName,
          qty: itemQtyUnit[0],
          qtyUnit: itemQtyUnit[1],
        ));
      });
    } else if (itemQtyUnit.length == 1) {
      setState(() {
        _ingredients.add(GroceryItem(
          category,
          itemName,
          qty: itemQtyUnit[0],
          qtyUnit: " ",
        ));
      });
    } else {
      setState(() {
        _ingredients.add(GroceryItem(
          category,
          itemName,
          qty: " ",
          qtyUnit: " ",
        ));
      });
    }
    ingredientNameController.clear();
    qtyController.clear();
    categoryController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context)),
          title: const Text('Add Meals'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(
              child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40.0),
                        child: TextFormField(
                          controller: mealNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name for this meal';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              hintText: 'Sloppy Joes',
                              labelText: 'Name',
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide:
                                      const BorderSide(color: Colors.lightBlue, width: 1.0))),
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: const Padding(
                              child: Text(
                                'Ingredients',
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                              ),
                              padding: EdgeInsets.only(bottom: 10.0))),
                      _loading == true ? JumpingText('Loading...') : const SizedBox(height: 0.0),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Form(
                          key: _ingredientFormKey,
                          child: Row(children: [
                            SizedBox(
                              child: TextFormField(
                                  controller: ingredientNameController,
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
                              width: MediaQuery.of(context).size.width * 0.24,
                            ),
                            SizedBox(
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter quantity';
                                  }
                                  return null;
                                },
                                controller: qtyController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '1 bunch',
                                ),
                              ),
                              width: MediaQuery.of(context).size.width * 0.24,
                            ),
                            SizedBox(
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter category';
                                  }
                                  return null;
                                },
                                controller: categoryController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'produce',
                                ),
                              ),
                              width: MediaQuery.of(context).size.width * 0.24,
                            ),
                            const Spacer(),
                            TextButton(
                                style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                ),
                                onPressed: () {
                                  if (_ingredientFormKey.currentState!.validate()) {
                                    _addGroceryItem();
                                  }
                                },
                                child: const Text('Add'))
                          ]),
                        ),
                      ),
                      Wrap(
                          children: _ingredients.map((ingredient) {
                        return Material(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _ingredients
                                    .removeWhere((element) => element.name == ingredient.name);
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(3.0, 3.0, 3.0, 3.0),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: ingredient.name,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const WidgetSpan(
                                      child: SizedBox(width: 15),
                                    ),
                                    TextSpan(
                                      text: "${ingredient.qty} ${ingredient.qtyUnit}",
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const WidgetSpan(
                                      child: SizedBox(width: 5),
                                    ),
                                    const TextSpan(
                                      text: "x",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList()),
                      const Spacer(),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 3 / 7,
                          height: 40.0,
                          child: ElevatedButton(
                            child: const Text('Save + Exit'),
                            onPressed: () async {
                              if (_formKey.currentState!.validate() && _ingredients.isNotEmpty) {
                                UnmodifiableListView<GroceryItem> ingredientsView =
                                    UnmodifiableListView(_ingredients);
                                setState(() {
                                  _loading = true;
                                });
                                await SQLHelper.insertMeal(
                                    Meal(name: mealNameController.text), ingredientsView);
                                setState(() {
                                  _loading = false;
                                });
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 3 / 7,
                          height: 40.0,
                          child: ElevatedButton(
                            child: const Text('Save'),
                            onPressed: () async {
                              if (_formKey.currentState!.validate() && _ingredients.isNotEmpty) {
                                UnmodifiableListView<GroceryItem> ingredientsView =
                                    UnmodifiableListView(_ingredients);
                                setState(() {
                                  _loading = true;
                                });
                                await SQLHelper.insertMeal(
                                    Meal(name: mealNameController.text), ingredientsView);
                                mealNameController.clear();
                                qtyController.clear();
                                ingredientNameController.clear();
                                categoryController.clear();
                                setState(() {
                                  _loading = false;
                                  _ingredients.clear();
                                });
                              } else if (_ingredients.isEmpty) {
                                final snackBar = SnackBar(
                                  content: const Text("Add at least one ingredient"),
                                  action: SnackBarAction(
                                    label: 'Close',
                                    onPressed: () {},
                                  ),
                                );

                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                            },
                          ),
                        )
                      ])
                    ],
                  ))),
        ));
  }
}
