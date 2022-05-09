import 'dart:async';

import 'package:grocery_helper_app/business_logic/blocs/meal_card_bloc/meal_card_bloc.dart';
import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/models/meal.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_helper_app/data/repositories/meal/i_meal_repository.dart';

part 'meal_event.dart';
part 'meal_state.dart';

class MealBloc extends Bloc<MealEvent, MealState> {
  final IMealRepository _mealRepository;
  final MealCardBloc _mealCardBloc;
  late final StreamSubscription<MealCardState> _mealCardStreamSubscription;

  MealBloc({required IMealRepository mealRepository, required MealCardBloc mealCardBloc})
      : _mealRepository = mealRepository,
        _mealCardBloc = mealCardBloc,
        super(const MealInitial()) {
    _mealCardStreamSubscription = _mealCardBloc.stream.listen((mealCardState) {
      if (mealCardState is MealCardDeleted) {
        add(GetMealsEvent());
      } else if (mealCardState is MealCardSelected) {
        add(CheckOffMealEvent(mealCardState.meal));
      }
    });
    on<MealEvent>(mapEventToState);
  }

  void mapEventToState(MealEvent event, Emitter<MealState> emit) async {
    if (event is GetMealsEvent) {
      await _getMeals(emit, event);
    } else if (event is DeleteMealEvent) {
      await _deleteMeal(emit, event);
    } else if (event is PopulateGroceryList) {
      await _populateGroceryList(emit, event);
    } else if (event is CheckOffMealEvent) {
      _checkOffMeal(emit, event);
    }
  }

  Future<void> _getMeals(emit, event) async {
    emit(const MealLoading());
    try {
      final meals = await _mealRepository.getMeals();
      emit(MealLoaded(meals));
    } catch (error) {
      emit(MealError(error.toString()));
    }
  }

  Future<void> _deleteMeal(emit, event) async {
    emit(const MealLoading());
    try {
      await _mealRepository.delete(event.name);

      emit(MealDeleted());
    } catch (error) {
      emit(MealError('No meal with that name exists'));
    }
  }

  Future<void> _populateGroceryList(Emitter<MealState> emit, PopulateGroceryList event) async {
    if (state is MealLoaded) {
      MealLoaded trueState = state as MealLoaded;

      List<Meal> meals = [];
      for (var meal in trueState.meals) {
        if (meal.checked) {
          meals.add(meal);
        }
      }

      try {
        await _mealRepository.populateGroceryList(meals.map((e) => e.name).toList());
        emit(GroceryListPopulated());
        add(GetMealsEvent());
      } catch (error) {
        emit(MealError('There were some errors adding grocery items to your shopping list'));
      }
    }
  }

  void _checkOffMeal(Emitter<MealState> emit, CheckOffMealEvent event) {
    if (state is MealLoaded) {
      MealLoaded trueState = state as MealLoaded;

      List<Meal> meals = trueState.meals.map((meal) {
        if (meal.name == event.meal.name) {
          return Meal(checked: !meal.checked, id: meal.id, name: meal.name);
        } else {
          return meal;
        }
      }).toList();

      emit(MealLoaded(meals));
    }
  }

  @override
  Future<void> close() {
    _mealCardStreamSubscription.cancel();
    return super.close();
  }
}
