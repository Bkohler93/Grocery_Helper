import 'dart:async';

import 'package:grocery_helper_app/data/repositories/meal_repository.dart';
import 'package:grocery_helper_app/data/models/meal.dart';
import 'package:bloc/bloc.dart';

part 'meal_event.dart';
part 'meal_state.dart';

class MealBloc extends Bloc<MealEvent, MealState> {
  final MealRepository _mealRepository;

  MealBloc(this._mealRepository) : super(MealInitial()) {
    on<GetMeals>((event, emit) => _getMeals(emit));
  }

  @override
  void _getMeals(Emitter emit) async {
    emit(MealLoading());
    try {
      final meals = await _mealRepository.getMeals();
      emit(MealLoaded(meals));
    } catch (error) {
      emit(MealError(error.toString()));
    }
  }
}
