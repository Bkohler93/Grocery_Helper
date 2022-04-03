part of 'add_meal_bloc.dart';

abstract class AddMealEvent extends Equatable {
  const AddMealEvent();

  @override
  List<Object> get props => [];
}

class EditMealNameEvent extends AddMealEvent {
  final String text;

  EditMealNameEvent(this.text);

  @override
  List<Object> get props => [text];
}
