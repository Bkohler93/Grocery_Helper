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

class DeleteMealCardEvent extends MealCardEvent {
  final Meal meal;

  const DeleteMealCardEvent(this.meal);

  @override
  List<Object> get props => [meal];
}
