part of 'meal_bloc.dart';

abstract class MealState {
  const MealState();
}

class MealInitial extends MealState {
  const MealInitial();
}

class MealLoading extends MealState {
  const MealLoading();
}

class MealLoaded extends MealState {
  final List<Meal> meals;
  const MealLoaded(this.meals);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MealLoaded && o.meals == meals;
  }

  @override
  int get hashcode => meals.hashCode;
}

class MealError extends MealState {
  final String message;
  const MealError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MealError && o.message == message;
  }

  @override
  int get hashcode => message.hashCode;
}
