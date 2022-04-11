import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_helper_app/business_logic/blocs/meal_bloc/meal_bloc.dart';
import 'package:grocery_helper_app/business_logic/cubits/grocery_item_cubit/grocery_item_cubit.dart';
import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/repositories/grocery/i_grocery_repository.dart';

part 'grocery_state.dart';
part 'grocery_event.dart';

class GroceryBloc extends Bloc<GroceryEvent, GroceryState> {
  final IGroceryRepository _groceryRepository;
  final MealBloc _mealBloc;
  late final StreamSubscription<MealState> _mealStreamSubscription;
  final GroceryItemCubit _groceryItemCubit;
  late final StreamSubscription<GroceryItemState> _groceryItemStreamSubscription;

  GroceryBloc(
      {required IGroceryRepository groceryRepository,
      required GroceryItemCubit groceryItemCubit,
      required MealBloc mealBloc})
      : _groceryRepository = groceryRepository,
        _groceryItemCubit = groceryItemCubit,
        _mealBloc = mealBloc,
        super(const GroceryInitial()) {
    _groceryItemStreamSubscription = _groceryItemCubit.stream.listen((groceryItemState) {
      if (groceryItemState is GroceryItemUpdated) {
        add(CheckOffGroceryItemEvent(groceryItemState.item));
      }
    });
    _mealStreamSubscription = _mealBloc.stream.listen((mealState) {
      if (mealState is GroceryListPopulated) {
        add(GetGroceriesEvent());
      }
    });
    on<GroceryEvent>(mapEventToState);
    on<CheckOffGroceryItemEvent>(_handleGroceryItemCheckOff);
    on<AllGroceriesCheckedEvent>(_handleAllGroceriesChecked);
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
      add(GetGroceriesEvent());
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
      var id = await _groceryRepository.checkOffGroceryItem(event.item);
      add(GetGroceriesEvent());
    } catch (error) {
      emit(GroceriesError("Failed to update item"));
    }
  }

  FutureOr<void> _handleGroceryItemCheckOff(
      CheckOffGroceryItemEvent event, Emitter<GroceryState> emit) async {
    try {
      var groceries = await _groceryRepository.getGroceries();
      int count = 0;

      for (GroceryItem grocery in groceries) {
        if (grocery.checkedOff) count++;
      }

      if (count == groceries.length) {
        add(AllGroceriesCheckedEvent());
        await _groceryRepository.clearGroceryItems();
      } else {
        add(GetGroceriesEvent());
      }
    } catch (err) {
      emit(GroceriesError("Failed to handle grocery item check off"));
    }
  }

  FutureOr<void> _handleAllGroceriesChecked(
      AllGroceriesCheckedEvent event, Emitter<GroceryState> emit) async {
    emit(AllGroceriesChecked());
    //TODO maybe incorporate animation!?!?!?
    await Future.delayed(const Duration(seconds: 2));
    emit(AwaitingGroceries());
  }
}
