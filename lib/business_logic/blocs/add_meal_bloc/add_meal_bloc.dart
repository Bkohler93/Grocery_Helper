import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_helper_app/data/repositories/meal/i_meal_repository.dart';

part 'add_meal_event.dart';
part 'add_meal_state.dart';

class AddMealBloc extends Bloc<AddMealEvent, AddMealState> {
  final IMealRepository _mealRepository;

  AddMealBloc(this._mealRepository) : super(AddMealInitial()) {
    on<EditMealNameEvent>((event, emit) async {
      await _validateName(event, emit);
    });
  }

  Future<void> _validateName(EditMealNameEvent event, Emitter<AddMealState> emit) async {
    final String name = event.text.toLowerCase();

    try {
      bool nameExists = await _mealRepository.mealExists(name);
      if (nameExists) {
        emit(MealNameInvalidated("A meal with that name already exists."));
      } else if (name.length > 30) {
        emit(MealNameInvalidated("Maximum of 30 characters."));
      } else if (name.length < 1) {
        emit(MealNameInvalidated("Give your meal a name."));
      } else {
        emit(MealNameValidated());
      }
    } catch (error) {
      emit(AddMealError("Something went wrong"));
    }
  }
}
