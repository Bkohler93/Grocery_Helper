import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_helper_app/business_logic/blocs/meal_bloc/meal_bloc.dart';
import 'package:grocery_helper_app/data/models/meal.dart';
import '../widgets/meal_card.dart';

class ChooseMealsPage extends StatefulWidget {
  const ChooseMealsPage({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);
  final Function onSubmit;

  @override
  State<ChooseMealsPage> createState() => _ChooseMealsPageState();
}

class _ChooseMealsPageState extends State<ChooseMealsPage> {
  String mealEditing = "";

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
                context.read<MealBloc>().add(GetMealsEvent());
                return buildInitialInput();
              } else if (state is MealLoading) {
                return buildLoading();
              } else if (state is MealLoaded) {
                return buildListWithData(state.meals, context);
              } else {
                return const Text("Something went wrong");
              }
            }),
        Positioned(
          bottom: 50.0,
          width: 300.0,
          height: 60.0,
          child: ElevatedButton(
            style: style,
            onPressed: () {
              context.read<MealBloc>().add(PopulateGroceryList());
              widget.onSubmit();
              //move to other tab
            },
            child: const Text("Build Grocery List"),
          ),
        ),
      ],
    );
  }

  Widget buildInitialInput() {
    return Center(
      child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
    );
  }

  Widget buildListWithData(List<Meal> meals, context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.only(bottom: 120.0),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: meals.map((meal) {
          return MealCard(
            meal: meal,
            onEdit: handleEdit,
            isEditing: mealEditing == meal.name ? true : false,
          );
        }).toList(),
      ),
    );
  }

  handleEdit(String name) {
    setState(() {
      mealEditing = (mealEditing == name) ? "" : name;
    });
  }
}
