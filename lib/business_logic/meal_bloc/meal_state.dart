part of 'meal_bloc.dart';

abstract class MealState extends Equatable {
  const MealState();
}

class MealInitial extends MealState {
  const MealInitial();

  @override
  List<Object> get props => [];
}

class MealLoading extends MealState {
  const MealLoading();

  @override
  List<Object> get props => [];
}

class MealLoaded extends MealState {
  final List<Meal> meals;
  const MealLoaded(this.meals);

  @override
  List<Object> get props => [meals];
}

class MealError extends MealState {
  final String message;
  const MealError(this.message);

  @override
  List<Object> get props => [message];
}

class MealAdded extends MealState {
  final bool success;

  const MealAdded(this.success);

  @override
  List<Object> get props => [success];
}

class MealDeleted extends MealState {
  const MealDeleted();

  @override
  List<Object> get props => [];
}
