import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_helper_app/business_logic/blocs/meal_bloc/meal_bloc.dart';
import 'package:grocery_helper_app/business_logic/blocs/meal_card_bloc/meal_card_bloc.dart';
import 'package:grocery_helper_app/data/models/meal.dart';
import 'package:grocery_helper_app/presentation/screens/edit_meal.dart';

class MealCard extends StatelessWidget {
  const MealCard({required this.meal, Key? key, required this.isEditing, required this.onEdit})
      : super(key: key);

  final Meal meal;
  final bool isEditing;
  final Function(String name) onEdit;

  //tell parent this widget to edit
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () => {
          context.read<MealCardBloc>().add(SelectMealEvent(meal)),
        },
        onLongPress: () => onEdit(meal.name),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 15.0,
            bottom: 15.0,
            left: 10.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(15.0),
                height: 18.0,
                width: 18.0,
                decoration: BoxDecoration(
                  color: meal.checked ? Theme.of(context).colorScheme.primary : null,
                  shape: BoxShape.circle,
                ),
              ),
              Text(meal.name),
              const Spacer(),
              isEditing
                  ? SizedBox(
                      height: 50,
                      child: ButtonBar(
                        children: [
                          SizedBox(
                              width: 40,
                              child: TextButton(
                                child: const Icon(Icons.edit, size: 20),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditMealPage(
                                              meal: meal,
                                            )),
                                  );
                                },
                              )),
                          SizedBox(
                            width: 40,
                            child: TextButton(
                              onPressed: () {
                                context.read<MealCardBloc>().add(DeleteMealCardEvent(meal));
                              },
                              child: const Icon(Icons.delete, size: 20),
                            ),
                          )
                        ],
                      ),
                    )
                  : const SizedBox(height: 50.0)
            ],
          ),
        ),
      ),
    );
  }
}
