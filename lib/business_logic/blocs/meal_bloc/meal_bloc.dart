import 'dart:async';

import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/models/meal.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_helper_app/data/repositories/meal/i_meal_repository.dart';

part 'meal_event.dart';
part 'meal_state.dart';

class MealBloc extends Bloc<MealEvent, MealState> {
  final IMealRepository _mealRepository;

  MealBloc(this._mealRepository) : super(const MealInitial()) {
    on<MealEvent>(mapEventToState);
  }

  void mapEventToState(MealEvent event, Emitter<MealState> emit) async {
    if (event is GetMealsEvent) {
      await _getMeals(emit);
    } else if (event is AddMealEvent) {
      await _addMeal(emit, event);
    } else if (event is DeleteMealEvent) {
      await _deleteMeal(emit, event);
    } else if (event is PopulateGroceryList) {
      await _populateGroceryList(emit, event);
    }
  }

  Future<void> _getMeals(Emitter emit) async {
    emit(const MealLoading());
    try {
      final meals = await _mealRepository.getMeals();
      emit(MealLoaded(meals));
    } catch (error) {
      emit(MealError(error.toString()));
    }
  }

  Future<void> _addMeal(emit, event) async {
    emit(const MealLoading());
    try {
      final success = await _mealRepository.insert(event.name, event.items);

      if (success) {
        emit(MealAdded(true));
      } else {
        throw (Error());
      }
    } catch (error) {
      emit(MealError('A meal with that name already exists'));
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
    emit(const MealLoading());
    try {
      await _mealRepository.populateGroceryList(event.mealNames);

      emit(GroceryListPopulated());
    } catch (error) {
      emit(MealError('There were some errors adding grocery items to your shopping list'));
    }
  }
}
