import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/extensions/string.dart';
import 'package:progress_indicators/progress_indicators.dart';

import 'package:grocery_helper_app/data/db_provider.dart';
import 'package:grocery_helper_app/data/models/meal.dart';

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

  void _handleSavePress() async {
    if (_formKey.currentState!.validate() && _ingredients.isNotEmpty) {
      UnmodifiableListView<GroceryItem> ingredientsView = UnmodifiableListView(_ingredients);
      setState(() {
        _loading = true;
      });
      // await SQLHelper.insertMeal(Meal(name: mealNameController.text), ingredientsView);
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
  }

  void _addGroceryItem() {
    String itemName = ingredientNameController.text.capitalize();
    List<String> itemQtyUnit = qtyController.text.split(' ');
    String category = categoryController.text.capitalize();

    if (itemQtyUnit.length > 1) {
      // setState(() {
      //   _ingredients.add(GroceryItem(
      //     category,
      //     itemName,
      //     qty: itemQtyUnit[0].capitalize(),
      //     qtyUnit: itemQtyUnit[1].capitalize(),
      //   ));
      // });
    } else if (itemQtyUnit.length == 1) {
      // setState(() {
      //   _ingredients.add(GroceryItem(
      //     category,
      //     itemName,
      //     qty: itemQtyUnit[0].capitalize(),
      //     qtyUnit: " ",
      //   ));
      // });
    } else {
      // setState(() {
      //   _ingredients.add(GroceryItem(
      //     category,
      //     itemName,
      //     qty: " ",
      //     qtyUnit: " ",
      //   ));
      // });
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
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: const Icon(Icons.save),
                onPressed: () async => _handleSavePress(),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(
              child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MealName(mealNameController: mealNameController),
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: const Padding(
                              child: Text(
                                'Ingredients',
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                              ),
                              padding: EdgeInsets.only(bottom: 10.0))),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Form(
                          key: _ingredientFormKey,
                          child: Row(children: [
                            IngredientField(
                              validatorMsg: 'Enter name',
                              hintText: 'Banana',
                              ingredientFieldController: ingredientNameController,
                            ),
                            IngredientField(
                              validatorMsg: 'Enter quantity',
                              hintText: '1 bunch',
                              ingredientFieldController: qtyController,
                            ),
                            IngredientField(
                              hintText: 'produce',
                              validatorMsg: 'Enter category',
                              ingredientFieldController: categoryController,
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
                        return IngredientBadge(groceryItem: ingredient);
                      }).toList()),
                      const Spacer(),
                    ],
                  ))),
        ));
  }
}

class IngredientBadge extends StatelessWidget {
  const IngredientBadge({
    Key? key,
    required this.groceryItem,
  }) : super(key: key);

  final GroceryItem groceryItem;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          //TODO remove item from list of ingredients
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
                  text: groceryItem.name,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
                const WidgetSpan(
                  child: SizedBox(width: 15),
                ),
                TextSpan(
                  text: "${groceryItem.qty} ${groceryItem.qtyUnit}",
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
  }
}

class IngredientField extends StatelessWidget {
  const IngredientField({
    Key? key,
    required this.validatorMsg,
    required this.hintText,
    required this.ingredientFieldController,
  }) : super(key: key);

  final TextEditingController ingredientFieldController;
  final String hintText;
  final String validatorMsg;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
          controller: ingredientFieldController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return validatorMsg;
            }
            return null;
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
          )),
      width: MediaQuery.of(context).size.width * 0.24,
    );
  }
}

class MealName extends StatelessWidget {
  const MealName({
    Key? key,
    required this.mealNameController,
  }) : super(key: key);

  final TextEditingController mealNameController;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                borderSide: const BorderSide(color: Colors.lightBlue, width: 1.0))),
      ),
    );
  }
}
