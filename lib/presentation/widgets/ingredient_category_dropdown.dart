import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_helper_app/business_logic/blocs/add_meal_bloc/add_meal_bloc.dart';
import 'package:grocery_helper_app/business_logic/cubits/ingredient_cubit/add_ingredient_cubit.dart';
import 'package:grocery_helper_app/business_logic/notifiers/section_notifier.dart';
import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/models/section.dart';
import 'package:grocery_helper_app/data/repositories/section/section_repository.dart';
import 'package:provider/provider.dart';

class CategoryDropdownWidget extends StatelessWidget {
  CategoryDropdownWidget({Key? key, this.item}) : super(key: key);
  final GroceryItem? item;
  @override
  Widget build(BuildContext context) {
    return CategoryDropdown(item: item);
  }
}

class CategoryDropdown extends StatefulWidget {
  CategoryDropdown({Key? key, this.item}) : super(key: key);
  GroceryItem? item;
  @override
  State<CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  String? dropdownValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.item != null) {
      dropdownValue = widget.item?.category;
      context.read<AddIngredientCubit>().changeSection(widget.item!.category);
    }
  }

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
      child: Consumer<SectionNotifier>(
        builder: (context, sections, child) {
          return DropdownButton<String>(
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
            items: sections.sections.map<DropdownMenuItem<String>>((Section value) {
              return DropdownMenuItem<String>(
                value: value.name,
                child: Text(value.name),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
