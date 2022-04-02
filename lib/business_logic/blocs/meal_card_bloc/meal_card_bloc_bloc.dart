import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_helper_app/data/repositories/meal/i_meal_repository.dart';
import 'package:grocery_helper_app/data/repositories/meal/meal_repository.dart';

part 'meal_card_bloc_event.dart';
part 'meal_card_bloc_state.dart';

class MealCardBloc extends Bloc<MealCardEvent, MealCardState> {
  final IMealRepository _mealRepository;

  MealCardBloc(this._mealRepository) : super(MealCardInitial()) {
    on<MealCardEvent>(mapEventToState);
  }

  void mapEventToState(MealCardEvent event, Emitter<MealCardState> emit) async {
    if (event is SelectMealEvent) {
      await _selectMeal(emit, event);
    } else if (event is EditMealEvent) {
      await _addMeal(emit, event);
    }
  }

  _selectMeal(Emitter<MealCardState> emit, SelectMealEvent event) {}

  _addMeal(Emitter<MealCardState> emit, EditMealEvent event) {}
}
