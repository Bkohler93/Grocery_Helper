import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_helper_app/business_logic/blocs/grocery_bloc/grocery_bloc.dart';
import 'package:grocery_helper_app/business_logic/cubits/grocery_item_cubit/grocery_item_cubit.dart';
import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/repositories/grocery/grocery_repository.dart';
import 'package:grocery_helper_app/presentation/widgets/add_ingredient_modal.dart';

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
  final _listController = ScrollController(keepScrollOffset: true);
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    textNameController.dispose();
    textQtyController.dispose();
    textCategoryController.dispose();
    _listController.dispose();
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

  Widget buildGroceryList(List<Map<String, List<GroceryItem>>> items) {
    return Stack(
      children: <Widget>[
        ListView(scrollDirection: Axis.vertical, controller: _listController, children: <Widget>[
          ...items
              .map((category) => <Widget>[
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                      child: Text(category.keys.first,
                          style: TextStyle(fontSize: 15, color: Colors.grey[500])),
                    )),
                    ...category.values.first.map((item) => GroceryListItem(item: item))
                  ])
              .expand((element) => element)
              .toList()
        ]),
        Positioned(
            right: 30,
            bottom: 30,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
              ),
              child: const Icon(Icons.add, size: 35.0),
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return FractionallySizedBox(
                      heightFactor: 0.7,
                      child: AddIngredientModal(),
                    );
                  },
                );
              },
            ))
      ],
    );
  }

  Widget buildCompletedAnimation() {
    return Container(alignment: Alignment.center, child: Text("YAY!"));
  }

  Widget buildWaitingGroceries() {
    return Container(alignment: Alignment.center, child: Text("Add some groceries first!"));
  }
}
