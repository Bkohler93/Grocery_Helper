import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_helper_app/business_logic/cubits/ingredient_cubit/add_ingredient_cubit.dart';
import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/providers/theme_provider.dart';
import 'package:grocery_helper_app/presentation/screens/add_meal.dart';
import 'package:grocery_helper_app/presentation/widgets/ingredient_category_dropdown.dart';

class AddIngredientModal extends StatefulWidget {
  const AddIngredientModal({Key? key, this.item}) : super(key: key);
  final GroceryItem? item;
  @override
  _AddIngredientModalState createState() => _AddIngredientModalState();
}

class _AddIngredientModalState extends State<AddIngredientModal> {
  final ingredientNameController = TextEditingController();
  final ingredientQtyController = TextEditingController();
  final ingredientNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<AddIngredientCubit>().reset();
    ingredientNameController.text = widget.item?.name ?? "";
    ingredientQtyController.text = widget.item?.qty ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: <Widget>[
      Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(children: [
            Row(children: [
              IngredientNameField(item: widget.item),
              TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primary),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.secondary),
                ),
                onPressed: () {
                  context.read<AddIngredientCubit>().addIngredient();
                  ingredientNameController.clear();
                  ingredientQtyController.clear();
                  ingredientNameFocusNode.requestFocus();
                },
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ]),
            Row(
              children: const [
                IngredientQtyField(),
                CategoryDropdownWidget(),
              ],
            ),
          ]),
        ),
      ),
      const Positioned(
          child: Icon(
            Icons.keyboard_arrow_down_outlined,
            size: 30,
          ),
          top: 0)
    ]);
  }
}
