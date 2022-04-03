import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_helper_app/business_logic/blocs/add_meal_bloc/add_meal_bloc.dart';
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
  final List<GroceryItem> _ingredients = [];

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
                onPressed: () {},
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const MealNameField(),
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
                child: Row(children: [
                  const IngredientField(
                    validatorMsg: 'Enter name',
                    hintText: 'Banana',
                  ),
                  const IngredientField(
                    validatorMsg: 'Enter quantity',
                    hintText: '1 bunch',
                  ),
                  const IngredientField(
                    hintText: 'produce',
                    validatorMsg: 'Enter category',
                  ),
                  const Spacer(),
                  TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      onPressed: () {},
                      child: const Text('Add'))
                ]),
              ),
              Wrap(
                  children: _ingredients.map((ingredient) {
                return IngredientBadge(groceryItem: ingredient);
              }).toList()),
              const Spacer(),
            ],
          )),
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
  }) : super(key: key);

  final String hintText;
  final String validatorMsg;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextField(
          onChanged: (text) {
            print(text);
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
          )),
      width: MediaQuery.of(context).size.width * 0.24,
    );
  }
}

class MealNameField extends StatelessWidget {
  const MealNameField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: BlocBuilder<AddMealBloc, AddMealState>(builder: (context, state) {
        return TextField(
          onChanged: (text) {
            print(text);
          },
          decoration: InputDecoration(
              hintText: 'Sloppy Joes',
              labelText: 'Name',
              errorText: (state is MealNameInvalidated) ? state.msg : null,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(color: Colors.lightBlue, width: 1.0))),
        );
      }),
    );
  }
}
