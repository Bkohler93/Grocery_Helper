import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/models/meal.dart';
import 'package:grocery_helper_app/data/repositories/grocery/i_grocery_repository.dart';

part 'grocery_item_state.dart';

class GroceryItemCubit extends Cubit<GroceryItemState> {
  final IGroceryRepository _groceryRepository;

  GroceryItemCubit({required IGroceryRepository groceryRepository})
      : _groceryRepository = groceryRepository,
        super(GroceryItemInitial());

  void checkItem(GroceryItem item) {
    _groceryRepository.checkOffGroceryItem(item);
    emit(GroceryItemUpdated(item));
    emit(GroceryItemInitial());
  }
}
