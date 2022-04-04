import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_helper_app/business_logic/blocs/add_meal_bloc/add_meal_bloc.dart';
import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/repositories/meal/meal_repository.dart';
import 'package:grocery_helper_app/extensions/string.dart';
import 'package:grocery_helper_app/presentation/widgets/ingredient_category_dropdown.dart';
import 'package:progress_indicators/progress_indicators.dart';

import 'package:grocery_helper_app/data/db_provider.dart';
import 'package:grocery_helper_app/data/models/meal.dart';

class AddMealPage extends StatelessWidget {
  const AddMealPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return AddMealBloc(MealRepository());
      },
      child: AddMealForm(),
    );
  }
}

class AddMealForm extends StatelessWidget {
  AddMealForm({Key? key}) : super(key: key);
  final ingredientNameController = TextEditingController();
  final ingredientQtyController = TextEditingController();
  final ingredientNameFocusNode = FocusNode();

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
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    IngredientNameField(
                        controller: ingredientNameController, focusNode: ingredientNameFocusNode),
                    Row(
                      children: [
                        IngredientQtyField(controller: ingredientQtyController),
                        CategoryDropdown(),
                      ],
                    ),
                  ]),
                  TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      onPressed: () {
                        context.read<AddMealBloc>().add(AddIngredientEvent());
                        ingredientNameController.clear();
                        ingredientQtyController.clear();
                        ingredientNameFocusNode.requestFocus();
                      },
                      child: const Text('Add'))
                ]),
              ),
              BlocBuilder<AddMealBloc, AddMealState>(
                builder: (context, state) {
                  if (state.items.isNotEmpty) {
                    return Wrap(
                        children: state.items.map((ingredient) {
                      return IngredientBadge(groceryItem: ingredient);
                    }).toList());
                  } else {
                    return Text("Add some ingredients!");
                  }
                },
              ),
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

class IngredientNameField extends StatefulWidget {
  const IngredientNameField({
    Key? key,
    required this.controller,
    required this.focusNode,
  }) : super(key: key);
  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  State<IngredientNameField> createState() => _IngredientNameFieldState();
}

class _IngredientNameFieldState extends State<IngredientNameField> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: BlocBuilder<AddMealBloc, AddMealState>(
        builder: (context, state) {
          return TextField(
              focusNode: widget.focusNode,
              controller: widget.controller,
              onChanged: (text) {
                context.read<AddMealBloc>().add(EditIngredientNameEvent(text));
              },
              maxLength: 25,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Name',
                counterText: "",
              ));
        },
      ),
      width: MediaQuery.of(context).size.width * 0.7,
    );
  }
}

class IngredientQtyField extends StatelessWidget {
  const IngredientQtyField({
    required this.controller,
    Key? key,
  }) : super(key: key);
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: BlocBuilder<AddMealBloc, AddMealState>(
        builder: (context, state) {
          return TextField(
              controller: controller,
              onChanged: (text) {
                context.read<AddMealBloc>().add(EditIngredientQtyEvent(text));
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Quantity',
                errorText: state.ingredientQtyErrorText == '' ? null : state.ingredientQtyErrorText,
              ));
        },
      ),
      width: MediaQuery.of(context).size.width * 0.4,
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
            context.read<AddMealBloc>().add(EditMealNameEvent(text));
          },
          decoration: InputDecoration(
            hintText: 'Sloppy Joes',
            labelText: 'Name',
            errorText: state.nameErrorText == '' ? null : state.nameErrorText,
          ),
        );
      }),
    );
  }
}
