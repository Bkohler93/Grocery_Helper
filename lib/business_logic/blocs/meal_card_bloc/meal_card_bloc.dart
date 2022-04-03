import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_helper_app/data/models/meal.dart';
import 'package:grocery_helper_app/data/repositories/meal/i_meal_repository.dart';
import 'package:grocery_helper_app/data/repositories/meal/meal_repository.dart';

part 'meal_card_event.dart';
part 'meal_card_state.dart';

class MealCardBloc extends Bloc<MealCardEvent, MealCardState> {
  final IMealRepository _mealRepository;

  MealCardBloc(this._mealRepository) : super(MealCardInitial()) {
    on<MealCardEvent>(mapEventToState);
  }

  void mapEventToState(MealCardEvent event, Emitter<MealCardState> emit) async {
    if (event is SelectMealEvent) {
      await _selectMeal(emit, event);
    } else if (event is DeleteMealCardEvent) {
      await _deleteMeal(emit, event);
    }
  }

  Future<void> _selectMeal(Emitter<MealCardState> emit, SelectMealEvent event) async {
    try {
      Meal meal = await _mealRepository.checkMeal(event.meal);
      emit(MealCardSelected(meal));
    } catch (error) {
      emit(MealCardError("Unable to select meal"));
    }
  }

  Future<void> _deleteMeal(Emitter<MealCardState> emit, DeleteMealCardEvent event) async {
    try {
      await _mealRepository.delete(event.meal);
      emit(MealCardDeleted());
    } catch (error) {
      emit(MealCardError("Unable to delete meal"));
    }
  }
}
