import 'package:flutter/material.dart';
import 'package:grocery_helper_app/data/models/grocery_item.dart';

class AddIngredientModal extends StatelessWidget {
  const AddIngredientModal({Key? key, GroceryItem? item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const Text('Modal BottomSheet'),
          ElevatedButton(
            child: const Text('Close BottomSheet'),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
}
