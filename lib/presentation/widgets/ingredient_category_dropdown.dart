import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_helper_app/business_logic/blocs/add_meal_bloc/add_meal_bloc.dart';
import 'package:grocery_helper_app/business_logic/cubits/cubit/add_ingredient_cubit.dart';

class CategoryDropdown extends StatefulWidget {
  const CategoryDropdown({Key? key}) : super(key: key);

  @override
  State<CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddIngredientCubit, AddIngredientState>(
      listener: (context, state) {
        if (state.status == AddIngredientStatus.initialized) {
          setState(() {
            dropdownValue = null;
          });
        } else if (state.sectionErrorText.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              state.sectionErrorText,
            ),
          ));
        }
      },
      child: DropdownButton<String>(
        value: dropdownValue,
        hint: const Text("Section"),
        iconSize: 35,
        elevation: 8,
        style: TextStyle(color: Colors.grey.shade800, fontSize: 16),
        underline: Container(
          height: 0,
        ),
        onChanged: (String? newValue) {
          context.read<AddIngredientCubit>().changeSection(newValue!);
          setState(() {
            dropdownValue = newValue;
          });
        },
        items: <String>[
          'Produce',
          'Meat',
          'Deli',
          'Dairy',
          'Bread',
          'Bulk',
          'Asian',
          'Mexican',
          'Canned',
          'Personal',
          'Baking',
          'Frozen',
          'Household',
          'Other'
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
