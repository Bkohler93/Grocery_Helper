import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_helper_app/business_logic/blocs/add_meal_bloc/add_meal_bloc.dart';
import 'package:grocery_helper_app/business_logic/blocs/grocery_bloc/grocery_bloc.dart';
import 'package:grocery_helper_app/business_logic/blocs/meal_bloc/meal_bloc.dart';
import 'package:grocery_helper_app/business_logic/blocs/meal_card_bloc/meal_card_bloc.dart';
import 'package:grocery_helper_app/business_logic/cubits/grocery_item_cubit/grocery_item_cubit.dart';
import 'package:grocery_helper_app/business_logic/cubits/ingredient_cubit/add_ingredient_cubit.dart';
import 'package:grocery_helper_app/data/repositories/grocery/grocery_repository.dart';
import 'package:grocery_helper_app/data/repositories/meal/meal_repository.dart';
import 'package:grocery_helper_app/presentation/screens/add_meal.dart';

// import 'package:grocery_helper_app/data/models/grocery_list.dart';
import 'package:grocery_helper_app/presentation/screens/choose_meals.dart';
import 'package:grocery_helper_app/presentation/screens/grocery_list.dart';
import 'package:grocery_helper_app/presentation/screens/settings.dart';

// import 'presentation/screens/add_meal.dart';
// import 'presentation/screens/grocery_list.dart';

void main() {
  runApp(
    // ChangeNotifierProvider(
    //   create: (BuildContext context) => GroceryListModel(),
    // child:
    MultiBlocProvider(
        providers: [
          BlocProvider<MealCardBloc>(
            create: (context) => MealCardBloc(MealRepository()),
          ),
          BlocProvider<MealBloc>(
            create: (context) => MealBloc(
              mealRepository: MealRepository(),
              mealCardBloc: context.read<MealCardBloc>(),
            ),
          ),
          BlocProvider<GroceryItemCubit>(
              create: (context) => GroceryItemCubit(groceryRepository: GroceryRepository())),
          BlocProvider<AddIngredientCubit>(create: (context) => AddIngredientCubit()),
          BlocProvider<GroceryBloc>(
            create: (context) => GroceryBloc(
              groceryItemCubit: context.read<GroceryItemCubit>(),
              groceryRepository: GroceryRepository(),
              mealBloc: context.read<MealBloc>(),
              addIngredientCubit: context.read<AddIngredientCubit>(),
            ),
          ),
        ],
        child: MaterialApp(
            home: const MyApp(),
            title: "Grocery Helper",
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ))),
  );
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Home();
  }
}

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(icon: Icon(Icons.restaurant_menu)),
            Tab(
              icon: Icon(Icons.checklist),
            )
          ],
        ),
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
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const SettingsPage()));
            },
            child: Icon(Icons.settings),
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ChooseMealsPage(
            onSubmit: () {
              _tabController.index = 1;
            },
          ),
          GroceryListPage()
        ],
      ),
    );
  }
}
