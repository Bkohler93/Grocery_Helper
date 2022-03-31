import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_helper_app/data/models/meal.dart';
import '../../business_logic/meal_bloc/meal_bloc.dart';
import '../widgets/meal_card.dart';

class ChooseMealsPage extends StatefulWidget {
  const ChooseMealsPage({Key? key}) : super(key: key);

  @override
  _ChooseMealsPageState createState() => _ChooseMealsPageState();
}

class _ChooseMealsPageState extends State<ChooseMealsPage> {
  final Map<String, bool> mealsSelected = {};
  final Map<String, bool> mealsEditing = {};

  @override
  void initState() {
    final mealBloc = context.read<MealBloc>();
    mealBloc.add(GetMealsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        BlocConsumer<MealBloc, MealState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is MealInitial) {
                return buildInitialInput();
              } else if (state is MealLoading) {
                return buildLoading();
              } else if (state is MealLoaded) {
                return buildListWithData(state.meals);
              } else {
                return buildInitialInput();
              }
            }),
        Positioned(
          bottom: 50.0,
          width: 300.0,
          height: 60.0,
          child: ElevatedButton(
            style: style,
            onPressed: () {} /*_handleBuildGroceryList*/,
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
                    /*_refreshMeals();*/
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

  Widget buildInitialInput() {
    return const Center(
      child: CircularProgressIndicator(color: Colors.green),
    );
  }

  Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: Colors.blue),
    );
  }

  Widget buildListWithData(List<Meal> meals) {
    return ListView(
        scrollDirection: Axis.vertical,
        children: meals.map((meal) {
          //initialize selected/editing values only if unitialized
          if (mealsSelected[meal.name] == null || mealsEditing[meal.name] == null) {
            mealsSelected[meal.name] = false;
            mealsEditing[meal.name] = false;
          }

          return MealCard(meal.name, mealsSelected[meal.name]!, _handleMealClicked,
              mealsEditing[meal.name]!, _handleMealEditing);
        }).toList());
  }

  void _handleMealClicked(String name) {
    setState(() {
      mealsEditing.updateAll((key, value) => false);
      mealsSelected[name] = !mealsSelected[name]!;
    });
  }

  //disable editing on any meals that currently have editing enabled
  void _handleMealEditing(String name) {
    mealsEditing.forEach((key, value) {
      if (value == true && key != name) {
        setState(() {
          mealsEditing[key] = false;
        });
      }
    });
    bool currentValue = mealsEditing[name]!;

    setState(() {
      mealsEditing[name] = !currentValue;
    });
  }
}
