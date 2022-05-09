import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_helper_app/business_logic/blocs/grocery_bloc/grocery_bloc.dart';
import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/presentation/widgets/add_ingredient_modal.dart';
import 'package:grocery_helper_app/presentation/widgets/celebrate.dart';
import 'package:grocery_helper_app/presentation/widgets/edit_indredient_modal.dart';

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
    return BlocBuilder<GroceryBloc, GroceryState>(
      builder: (context, state) {
        if (state is GroceryInitial) {
          context.read<GroceryBloc>().add(GetGroceriesEvent());
        }
        return Stack(
          children: [
            (state is GroceryInitial || state is GroceryLoading)
                ? buildInitial()
                : (state is GroceriesLoaded)
                    ? buildGroceryList(state.groceries)
                    : (state is AllGroceriesChecked)
                        ? buildCompletedAnimation()
                        : (state is AwaitingGroceries)
                            ? buildWaitingGroceries()
                            : buildErrorDisplay(),
            Positioned(
              right: 30,
              bottom: 30,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                ),
                child: const Icon(Icons.add, size: 35.0),
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    isDismissible: true,
                    builder: (context) {
                      return FractionallySizedBox(
                        heightFactor: 0.7,
                        child: AddIngredientModal(),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
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
    return Container(
      margin: const EdgeInsets.only(bottom: 120),
      child:
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
    );
  }

  Widget buildCompletedAnimation() {
    return const CelebrateConfetti();
  }

  Widget buildWaitingGroceries() {
    return Container(alignment: Alignment.center, child: const Text("Add some groceries first!"));
  }
}
