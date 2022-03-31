import 'dart:async';

import 'package:grocery_helper_app/data/models/meal.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/grocery_item.dart';
import '../../data/repositories/i_meal_repository.dart';
part 'meal_event.dart';
part 'meal_state.dart';

class MealBloc extends Bloc<MealEvent, MealState> {
  final IMealRepository _mealRepository;

  MealBloc(this._mealRepository) : super(const MealInitial()) {
    on<GetMeals>((event, emit) => _getMeals(emit));
    on<AddMeal>((event, emit) => _addMeal(emit, event));
    on<DeleteMeal>((event, emit) => _deleteMeal(emit, event));
  }

  void _getMeals(Emitter emit) async {
    emit(const MealLoading());
    try {
      final meals = await _mealRepository.getMeals();
      emit(MealLoaded(meals));
    } catch (error) {
      emit(MealError(error.toString()));
    }
  }

  void _addMeal(emit, event) async {
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

  void _deleteMeal(emit, event) async {
    emit(const MealLoading());
    try {
      await _mealRepository.delete(event.name);

      emit(MealDeleted());
    } catch (error) {
      emit(MealError('No meal with that name exists'));
    }
  }
}
