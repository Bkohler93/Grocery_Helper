part of 'meal_card_bloc.dart';

abstract class MealCardState extends Equatable {
  const MealCardState();

  @override
  List<Object> get props => [];
}

class MealCardInitial extends MealCardState {}

class MealCardSelected extends MealCardState {
  final Meal meal;

  const MealCardSelected(this.meal);

  @override
  List<Object> get props => [meal];
}

class MealCardError extends MealCardState {
  final String msg;

  const MealCardError(this.msg);

  @override
  List<Object> get props => [msg];
}

class MealCardDeleted extends MealCardState {
  const MealCardDeleted();

  @override
  List<Object> get props => [];
}
