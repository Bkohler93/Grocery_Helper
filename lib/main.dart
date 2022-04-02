import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_helper_app/business_logic/blocs/grocery_bloc/grocery_bloc.dart';
import 'package:grocery_helper_app/business_logic/blocs/meal_bloc/meal_bloc.dart';
import 'package:grocery_helper_app/business_logic/blocs/meal_card_bloc/meal_card_bloc.dart';
import 'package:grocery_helper_app/data/repositories/grocery/grocery_repository.dart';
import 'package:grocery_helper_app/data/repositories/meal/meal_repository.dart';
import 'package:grocery_helper_app/presentation/screens/add_meal.dart';

// import 'package:grocery_helper_app/data/models/grocery_list.dart';
import 'package:grocery_helper_app/presentation/screens/choose_meals.dart';

// import 'presentation/screens/add_meal.dart';
// import 'presentation/screens/grocery_list.dart';

void main() {
  runApp(
    // ChangeNotifierProvider(
    //   create: (BuildContext context) => GroceryListModel(),
    // child:
    MaterialApp(
        home: const MyApp(),
        title: "Grocery Helper",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        )),
  );
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MealBloc>(
          create: (context) => MealBloc(MealRepository()),
        ),
        BlocProvider<GroceryBloc>(
          create: (context) => GroceryBloc(GroceryRepository()),
        ),
        BlocProvider<MealCardBloc>(
          create: (context) => MealCardBloc(MealRepository()),
        )
      ],
      child: DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(tabs: [
              Tab(icon: Icon(Icons.restaurant_menu)),
              // Tab(
              //   icon: Icon(Icons.checklist),
              // )
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
          body: TabBarView(
            children: [ChooseMealsPage() /*, GroceryListPage()*/],
          ),
        ),
      ),
    );
  }
}
