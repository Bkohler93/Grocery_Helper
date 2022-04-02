import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/repositories/grocery/i_grocery_repository.dart';

part 'grocery_state.dart';
part 'grocery_event.dart';

class GroceryBloc extends Bloc<GroceryEvent, GroceryState> {
  final IGroceryRepository _groceryRepository;

  GroceryBloc(this._groceryRepository) : super(const GroceryInitial()) {
    on<GroceryEvent>(mapEventToState);
  }

  void mapEventToState(GroceryEvent event, Emitter<GroceryState> emit) async {
    emit(GroceryLoading());
    if (event is GetGroceriesEvent) {
      await _getGroceries(event, emit);
    } else if (event is AddGroceryEvent) {
      await _addGrocery(event, emit);
    } else if (event is DeleteGroceryEvent) {
      await _deleteGrocery(event, emit);
    } else if (event is UpdateGroceryEvent) {
      await _updateGrocery(event, emit);
    }
  }

  Future<void> _getGroceries(GetGroceriesEvent event, Emitter<GroceryState> emit) async {
    try {
      var groceries = await _groceryRepository.getGroceries();
      emit(GroceriesLoaded(groceries));
    } catch (error) {
      emit(GroceriesError("Failed to retrieve groceries"));
    }
  }

  Future<void> _addGrocery(AddGroceryEvent event, Emitter<GroceryState> emit) async {
    try {
      var id = await _groceryRepository.addGroceryItem(event.item);
      emit(GroceryAdded(id));
    } catch (error) {
      emit(GroceriesError("Failed to add item to list"));
    }
  }

  Future<void> _deleteGrocery(DeleteGroceryEvent event, Emitter<GroceryState> emit) async {
    try {
      var id = await _groceryRepository.deleteGroceryItem(event.id);
      emit(GroceryDeleted(id));
    } catch (error) {
      emit(GroceriesError("failed to delete grocery item"));
    }
  }

  Future<void> _updateGrocery(UpdateGroceryEvent event, Emitter<GroceryState> emit) async {
    try {
      var id = await _groceryRepository.updateGroceryItem(event.item);
      emit(GroceryUpdated(id));
    } catch (error) {
      emit(GroceriesError("Failed to update item"));
    }
  }
}
