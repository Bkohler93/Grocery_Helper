import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_helper_app/business_logic/blocs/grocery_bloc/grocery_bloc.dart';
import 'package:grocery_helper_app/business_logic/blocs/meal_bloc/meal_bloc.dart';
import 'package:grocery_helper_app/business_logic/cubits/grocery_item_cubit/grocery_item_cubit.dart';
import 'package:grocery_helper_app/business_logic/cubits/ingredient_cubit/add_ingredient_cubit.dart';
import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/repositories/grocery/grocery_repository.dart';
import 'package:grocery_helper_app/presentation/screens/add_meal.dart';
import 'package:grocery_helper_app/presentation/widgets/ingredient_category_dropdown.dart';

class AddIngredientModal extends StatefulWidget {
  AddIngredientModal({Key? key, this.item}) : super(key: key);
  GroceryItem? item;
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
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    context.read<AddIngredientCubit>().addIngredient();
                    ingredientNameController.clear();
                    ingredientQtyController.clear();
                    ingredientNameFocusNode.requestFocus();
                  },
                  child: const Text('Add')),
            ]),
            Row(
              children: [
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
