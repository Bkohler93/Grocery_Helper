part of 'meal_card_bloc.dart';

abstract class MealCardEvent extends Equatable {
  const MealCardEvent();

  @override
  List<Object> get props => [];
}

class SelectMealEvent extends MealCardEvent {
  final Meal meal;

  const SelectMealEvent(this.meal);

  @override
  List<Object> get props => [meal];
}

class EditMealEvent extends MealCardEvent {
  final Meal meal;

  const EditMealEvent(this.meal);

  @override
  List<Object> get props => [meal];
}
