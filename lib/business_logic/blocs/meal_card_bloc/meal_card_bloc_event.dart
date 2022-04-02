part of 'meal_card_bloc_bloc.dart';

abstract class MealCardEvent extends Equatable {
  const MealCardEvent();

  @override
  List<Object> get props => [];
}

class SelectMealEvent extends MealCardEvent {
  final String name;

  const SelectMealEvent(this.name);

  @override
  List<Object> get props => [name];
}

class EditMealEvent extends MealCardEvent {
  final String name;

  const EditMealEvent(this.name);

  @override
  List<Object> get props => [name];
}
