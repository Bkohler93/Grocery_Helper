import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_helper_app/business_logic/blocs/add_meal_bloc/add_meal_bloc.dart';
import 'package:grocery_helper_app/business_logic/blocs/meal_bloc/meal_bloc.dart';
import 'package:grocery_helper_app/business_logic/cubits/ingredient_cubit/add_ingredient_cubit.dart';
import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/repositories/meal/meal_repository.dart';
import 'package:grocery_helper_app/presentation/widgets/ingredient_category_dropdown.dart';

class AddMealPage extends StatelessWidget {
  const AddMealPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddIngredientCubit>(
          create: (context) => AddIngredientCubit(),
        ),
        BlocProvider<AddMealBloc>(
          create: (context) => AddMealBloc(
              addIngredientCubit: context.read<AddIngredientCubit>(),
              mealRepository: MealRepository()),
        )
      ],
      child: AddMealForm(),
    );
  }
}

class AddMealForm extends StatelessWidget {
  AddMealForm({Key? key}) : super(key: key);
  final ingredientNameController = TextEditingController();
  final ingredientQtyController = TextEditingController();
  final ingredientNameFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                context.read<MealBloc>().add(GetMealsEvent());
                Navigator.pop(context);
              }),
          title: const Text('Add Meals'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: BlocBuilder<AddMealBloc, AddMealState>(
                builder: (context, state) {
                  if (state.status == AddMealStatus.success) {
                    return IconButton(
                      icon: const Icon(Icons.check_circle),
                      onPressed: () {
                        context.read<AddMealBloc>().add(const InitializeForm());
                      },
                    );
                  } else {
                    return IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () {
                        if (state.status == AddMealStatus.valid) {
                          context.read<AddMealBloc>().add(const SaveMealEvent());
                        }
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: MealNameField(),
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
                        padding: EdgeInsets.only(bottom: 10.0))),
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
                          child: const Text('Add'))
                    ],
                  ),
                ]),
              ),
              BlocBuilder<AddMealBloc, AddMealState>(
                builder: (context, state) {
                  if (state.status != AddMealStatus.initialized) {
                    return Wrap(
                        children: state.items.map((ingredient) {
                      return IngredientBadge(groceryItem: ingredient);
                    }).toList());
                  } else {
                    return const Expanded(
                      child: Center(child: Text("Add some ingredients!")),
                    );
                  }
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
          context.read<AddMealBloc>().add(DeleteIngredientEvent(groceryItem));
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
  IngredientNameField({
    Key? key,
    this.item,
  }) : super(key: key);
  GroceryItem? item;

  @override
  State<IngredientNameField> createState() => _IngredientNameFieldState();
}

class _IngredientNameFieldState extends State<IngredientNameField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.item != null) {
      _controller.text = widget.item!.name;
      context
          .read<AddIngredientCubit>()
          .editIngredientName(widget.item!.name, widget.item!.checkedOff);
    }
  }

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
                context
                    .read<AddIngredientCubit>()
                    .editIngredientName(text, widget.item?.checkedOff ?? false);
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
  IngredientQtyField({
    this.item,
    Key? key,
  }) : super(key: key);
  GroceryItem? item;
  @override
  State<IngredientQtyField> createState() => _IngredientQtyFieldState();
}

class _IngredientQtyFieldState extends State<IngredientQtyField> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null && widget.item!.qty != " ") {
      _controller.text = widget.item!.qty + ' ' + widget.item!.qtyUnit;
      context
          .read<AddIngredientCubit>()
          .editIngredientQty(widget.item!.qty + ' ' + widget.item!.qtyUnit);
    }
  }

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
  }) : super(key: key);

  @override
  State<MealNameField> createState() => _MealNameFieldState();
}

class _MealNameFieldState extends State<MealNameField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: BlocConsumer<AddMealBloc, AddMealState>(listener: (context, state) {
        if (state.status == AddMealStatus.success) {
          _controller.clear();
          _focusNode.requestFocus();
        }
      }, builder: (context, state) {
        return TextField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: (text) {
            context.read<AddMealBloc>().add(EditMealNameEvent(text));
          },
          decoration: InputDecoration(
            hintText: 'Sloppy Joes',
            labelText: 'Name',
            errorText: state.nameErrorText == '' ? null : state.nameErrorText,
          ),
        );
      }),
    );
  }
}
