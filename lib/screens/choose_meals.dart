import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/db.dart';
import '../models/grocery_list.dart';
import '../widgets/meal_card.dart';

class ChooseMealsPage extends StatefulWidget {
  const ChooseMealsPage({Key? key}) : super(key: key);

  @override
  _ChooseMealsPageState createState() => _ChooseMealsPageState();
}

class _ChooseMealsPageState extends State<ChooseMealsPage> {
  List<Map<String, dynamic>> mealViews = [];

  void _refreshMeals() async {
    final data = await SQLHelper.getMeals();

    var _mealViews = [
      for (var meal in data)
        {
          "isSelected": false,
          "isEditing": false,
          "name": meal.name,
        }
    ];

    setState(() {
      mealViews = _mealViews;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshMeals();
    Provider.of<GroceryListModel>(context, listen: false).wakeUp();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    void _handleMealSelected(int idx) {
      setState(() {
        mealViews[idx]['isSelected'] = !mealViews[idx]['isSelected'];
      });
    }

    void _handleDeleteMeal(String name) async {
      await SQLHelper.deleteMeal(name);

      _refreshMeals();
    }

    void _handleEditingMeal(int idx) {
      setState(() {
        mealViews[idx]['isEditing'] = !mealViews[idx]['isEditing'];
      });
    }

    void _handleBuildGroceryList() async {
      List<String> mealsToAdd = [];
      for (var mealView in mealViews) {
        if (mealView['isSelected']) {
          mealsToAdd.add(mealView['name']);
        }
      }
      await Provider.of<GroceryListModel>(context, listen: false).addMealsToList(mealsToAdd);
    }

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        ListView(
          children: mealViews
              .asMap()
              .entries
              .map((entry) => MealCard(
                    entry.value['name'],
                    entry.value['isSelected'],
                    entry.value['isEditing'],
                    _handleMealSelected,
                    _handleEditingMeal,
                    _handleDeleteMeal,
                    entry.key,
                  ))
              .toList(),
        ),
        Positioned(
          bottom: 50.0,
          width: 300.0,
          height: 60.0,
          child: ElevatedButton(
            style: style,
            onPressed: _handleBuildGroceryList,
            child: const Text("Build Grocery List"),
          ),
        ),
        Positioned(
          bottom: 150,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
                color: Colors.blue,
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    _refreshMeals();
                  },
                  child: RichText(
                    text: const TextSpan(
                      children: [WidgetSpan(child: Icon(Icons.refresh, size: 24))],
                    ),
                  ),
                )),
          ),
        ),
      ],
    );
  }
}
