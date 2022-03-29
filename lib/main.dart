import 'package:grocery_helper_app/models/grocery_list.dart';
import 'package:flutter/material.dart';
import 'package:grocery_helper_app/screens/choose_meals.dart';
import 'package:provider/provider.dart';

import 'screens/add_meal.dart';
import 'screens/grocery_list.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) => GroceryListModel(),
      child: MaterialApp(
          home: const MyApp(),
          title: "Grocery Helper",
          theme: ThemeData(primarySwatch: Colors.blue)),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<GroceryListModel>(context, listen: false).wakeUp();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(tabs: [
              Tab(icon: Icon(Icons.restaurant_menu)),
              Tab(
                icon: Icon(Icons.checklist),
              )
            ]),
            title: const Text('Grocery Helper'),
            actions: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 3, 10, 0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(4.0),
                        primary: Colors.white,
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddMealPage()),
                        );
                      },
                      child: const Text('Add Meal'),
                    )),
              ),
            ],
          ),
          body: const TabBarView(
            children: [ChooseMealsPage(), GroceryListPage()],
          )),
    );
  }
}
