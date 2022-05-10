import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_helper_app/business_logic/blocs/edit_meal_bloc/edit_meal_bloc.dart';
import 'package:grocery_helper_app/business_logic/blocs/meal_bloc/meal_bloc.dart';
import 'package:grocery_helper_app/business_logic/cubits/ingredient_cubit/add_ingredient_cubit.dart';
import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/models/meal.dart';
import 'package:grocery_helper_app/data/repositories/meal/meal_repository.dart';
import 'package:grocery_helper_app/presentation/widgets/ingredient_category_dropdown.dart';

class EditMealPage extends StatelessWidget {
  const EditMealPage({Key? key, required Meal meal})
      : _meal = meal,
        super(key: key);

  final Meal _meal;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddIngredientCubit>(
          create: (context) => AddIngredientCubit(),
        ),
        BlocProvider<EditMealBloc>(
          create: (context) => EditMealBloc(
              addIngredientCubit: context.read<AddIngredientCubit>(),
              mealRepository: MealRepository(),
              meal: _meal),
        )
      ],
      child: EditMealForm(meal: _meal),
    );
  }
}

class EditMealForm extends StatelessWidget {
  EditMealForm({Key? key, required Meal meal})
      : _meal = meal,
        super(key: key);
  final ingredientNameController = TextEditingController();
  final ingredientQtyController = TextEditingController();
  final ingredientNameFocusNode = FocusNode();
  final Meal _meal;

  @override
  Widget build(BuildContext context) {
    context.read<EditMealBloc>().add(LoadIngredientsEvent(mealName: _meal.name));

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                context.read<MealBloc>().add(GetMealsEvent());
                Future.delayed(const Duration(milliseconds: 30), () {
                  Navigator.pop(context);
                });
              }),
          title: const Text('Edit Meal'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: BlocBuilder<EditMealBloc, EditMealState>(builder: (context, state) {
                return IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    if (state.status == EditMealStatus.valid) {
                      context.read<EditMealBloc>().add(SaveMealEvent());
                      Future.delayed(const Duration(milliseconds: 30), () {
                        context.read<MealBloc>().add(GetMealsEvent());
                        Future.delayed(const Duration(milliseconds: 30), () {
                          Navigator.pop(context);
                        });
                      });
                    }
                  },
                );
              }),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: MealNameField(
                  mealName: _meal.name,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: const Padding(
                        child: Text(
                          'Ingredients',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                        ),
                        padding: EdgeInsets.only(bottom: 5.0))),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  IngredientNameField(),
                  IngredientQtyField(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CategoryDropdownWidget(),
                      TextButton(
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                          ),
                          onPressed: () {
                            context.read<AddIngredientCubit>().addIngredient();
                            ingredientNameController.clear();
                            ingredientQtyController.clear();
                            ingredientNameFocusNode.requestFocus();
                          },
                          child: const Text('Add')),
                    ],
                  ),
                ]),
              ),
              BlocBuilder<EditMealBloc, EditMealState>(
                builder: (context, state) {
                  return Wrap(
                      children: state.items.map((ingredient) {
                    return IngredientBadge(groceryItem: ingredient);
                  }).toList());
                },
              ),
              const Spacer(),
            ],
          )),
        ));
  }
}

class IngredientBadge extends StatelessWidget {
  const IngredientBadge({
    Key? key,
    required this.groceryItem,
  }) : super(key: key);

  final GroceryItem groceryItem;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          context.read<EditMealBloc>().add(DeleteIngredientEvent(groceryItem));
        },
        child: Container(
          margin: const EdgeInsets.fromLTRB(3.0, 3.0, 3.0, 3.0),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: groceryItem.name,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
                const WidgetSpan(
                  child: SizedBox(width: 15),
                ),
                TextSpan(
                  text: "${groceryItem.qty} ${groceryItem.qtyUnit}",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
                const WidgetSpan(
                  child: SizedBox(width: 5),
                ),
                const TextSpan(
                  text: "x",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class IngredientNameField extends StatefulWidget {
  const IngredientNameField({
    Key? key,
  }) : super(key: key);

  @override
  State<IngredientNameField> createState() => _IngredientNameFieldState();
}

class _IngredientNameFieldState extends State<IngredientNameField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: BlocConsumer<AddIngredientCubit, AddIngredientState>(
        listener: (context, state) {
          if (state.status == AddIngredientStatus.add) {
            setState(() {
              _controller.clear();
              _focusNode.requestFocus();
            });
          }
        },
        builder: (context, state) {
          return TextField(
              focusNode: _focusNode,
              controller: _controller,
              onChanged: (text) {
                context.read<AddIngredientCubit>().editIngredientName(text, false);
              },
              maxLength: 25,
              decoration: InputDecoration(
                border: InputBorder.none,
                errorText: state.nameErrorText.isEmpty ? null : state.nameErrorText,
                hintText: 'Name',
                counterText: "",
              ));
        },
      ),
      width: MediaQuery.of(context).size.width * 0.7,
    );
  }
}

class IngredientQtyField extends StatefulWidget {
  const IngredientQtyField({
    Key? key,
  }) : super(key: key);

  @override
  State<IngredientQtyField> createState() => _IngredientQtyFieldState();
}

class _IngredientQtyFieldState extends State<IngredientQtyField> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: BlocConsumer<AddIngredientCubit, AddIngredientState>(
        listener: (context, state) {
          if (state.status == AddIngredientStatus.add) {
            setState(() {
              _controller.clear();
            });
          }
        },
        builder: (context, state) {
          return TextField(
              controller: _controller,
              onChanged: (text) {
                context.read<AddIngredientCubit>().editIngredientQty(text);
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Quantity',
                errorText: state.quantityErrorText == '' ? null : state.quantityErrorText,
              ));
        },
      ),
      width: MediaQuery.of(context).size.width * 0.4,
    );
  }
}

class MealNameField extends StatefulWidget {
  const MealNameField({
    Key? key,
    required String mealName,
  })  : _mealName = mealName,
        super(key: key);
  final String _mealName;

  @override
  State<MealNameField> createState() => _MealNameFieldState();
}

class _MealNameFieldState extends State<MealNameField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.text = widget._mealName;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: BlocConsumer<EditMealBloc, EditMealState>(listener: (context, state) {
        if (state.status == EditMealStatus.success) {
          _controller.clear();
          _focusNode.requestFocus();
        }
      }, builder: (context, state) {
        return TextField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: (text) {
            context.read<EditMealBloc>().add(EditMealNameEvent(text));
          },
          decoration: InputDecoration(
            labelText: 'Name',
            errorText: state.nameErrorText == '' ? null : state.nameErrorText,
          ),
        );
      }),
    );
  }
}
