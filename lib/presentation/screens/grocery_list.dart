import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_helper_app/business_logic/blocs/grocery_bloc/grocery_bloc.dart';
import 'package:grocery_helper_app/business_logic/cubits/grocery_item_cubit/grocery_item_cubit.dart';
import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/repositories/grocery/grocery_repository.dart';

import 'package:grocery_helper_app/presentation/widgets/grocery_list_item.dart';

class GroceryListPage extends StatefulWidget {
  const GroceryListPage({Key? key}) : super(key: key);

  @override
  _GroceryListPageState createState() => _GroceryListPageState();
}

class _GroceryListPageState extends State<GroceryListPage> {
  final textNameController = TextEditingController();
  final textQtyController = TextEditingController();
  final textCategoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    textNameController.dispose();
    textQtyController.dispose();
    textCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroceryBloc, GroceryState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is GroceryInitial) {
          context.read<GroceryBloc>().add(GetGroceriesEvent());
          return buildInitial();
        } else if (state is GroceryLoading) {
          return buildInitial();
        } else if (state is GroceriesLoaded) {
          return buildGroceryList(state.groceries);
        } else if (state is AllGroceriesChecked) {
          return buildCompletedAnimation();
        } else if (state is AwaitingGroceries) {
          return buildWaitingGroceries();
        } else {
          return buildErrorDisplay();
        }
      },
    );
  }

  Widget buildInitial() {
    return const Center(
      child: CircularProgressIndicator(color: Colors.green),
    );
  }

  Widget buildErrorDisplay() {
    return const Text("Something went wrong.");
  }

  Widget buildGroceryList(List<GroceryItem> items) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: items.map((item) {
        return GroceryListItem(item: item);
      }).toList(),
    );
  }

  Widget buildCompletedAnimation() {
    return Container(alignment: Alignment.center, child: Text("YAY!"));
  }

  Widget buildWaitingGroceries() {
    return Container(alignment: Alignment.center, child: Text("Add some groceries first!"));
  }
}
