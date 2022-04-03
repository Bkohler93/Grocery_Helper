part of 'add_meal_bloc.dart';

abstract class AddMealState extends Equatable {
  const AddMealState();

  @override
  List<Object> get props => [];
}

class AddMealInitial extends AddMealState {}

class MealNameInvalidated extends AddMealState {
  final String msg;
  const MealNameInvalidated(this.msg);

  @override
  List<Object> get props => [msg];
}

class MealNameValidated extends AddMealState {
  const MealNameValidated();

  @override
  List<Object> get props => [];
}

class AddMealError extends AddMealState {
  final String msg;
  const AddMealError(this.msg);

  @override
  List<Object> get props => [msg];
}
