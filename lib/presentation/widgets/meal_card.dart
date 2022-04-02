import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_helper_app/business_logic/blocs/meal_card_bloc/meal_card_bloc.dart';
import 'package:grocery_helper_app/data/models/meal.dart';

class MealCard extends StatefulWidget {
  const MealCard(this.meal, {Key? key}) : super(key: key);

  final Meal meal;
  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  late bool isSelected;
  late bool isEditing;

  @override
  initState() {
    super.initState();
    isSelected = widget.meal.checked;
    isEditing = false;
  }

  //tell parent this widget to edit
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () => {
          context.read<MealCardBloc>().add(SelectMealEvent(widget.meal)),
          setState(() {
            isSelected = !isSelected;
          })
        },
        onLongPress: () => setState(() {
          isEditing = !isEditing;
        }),
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
                  color: isSelected ? Colors.blue : null,
                  shape: BoxShape.circle,
                ),
              ),
              Text(widget.meal.name),
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
                                onPressed: () {},
                              )),
                          SizedBox(
                            width: 40,
                            child: TextButton(
                              onPressed: () {},
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
