import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_helper_app/business_logic/blocs/meal_bloc/meal_bloc.dart';
import 'package:grocery_helper_app/business_logic/cubits/grocery_item_cubit/grocery_item_cubit.dart';
import 'package:grocery_helper_app/business_logic/cubits/ingredient_cubit/add_ingredient_cubit.dart';
import 'package:grocery_helper_app/business_logic/notifiers/section_notifier.dart';
import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/models/section.dart';
import 'package:grocery_helper_app/data/repositories/grocery/i_grocery_repository.dart';
import 'package:grocery_helper_app/data/repositories/section/section_repository.dart';

part 'grocery_state.dart';
part 'grocery_event.dart';

class GroceryBloc extends Bloc<GroceryEvent, GroceryState> {
  final IGroceryRepository _groceryRepository;
  final SectionRepository _sectionRepository;
  final MealBloc _mealBloc;
  late final StreamSubscription<MealState> _mealStreamSubscription;
  final GroceryItemCubit _groceryItemCubit;
  late final StreamSubscription<GroceryItemState> _groceryItemStreamSubscription;
  final AddIngredientCubit _addIngredientCubit;
  late final StreamSubscription<AddIngredientState> _addIngredientStreamSubscription;
  final SectionNotifier _sectionNotifier;

  GroceryBloc(
      {required IGroceryRepository groceryRepository,
      required SectionRepository sectionRepository,
      required GroceryItemCubit groceryItemCubit,
      required MealBloc mealBloc,
      required SectionNotifier sectionNotifier,
      required AddIngredientCubit addIngredientCubit})
      : _groceryRepository = groceryRepository,
        _sectionRepository = sectionRepository,
        _groceryItemCubit = groceryItemCubit,
        _sectionNotifier = sectionNotifier,
        _mealBloc = mealBloc,
        _addIngredientCubit = addIngredientCubit,
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
    _addIngredientStreamSubscription = _addIngredientCubit.stream.listen((addIngredientState) {
      if (addIngredientState.status == AddIngredientStatus.add) {
        GroceryItem newItem = GroceryItem.fromRawQty(
            category: addIngredientState.section,
            rawQty: addIngredientState.quantity,
            name: addIngredientState.name,
            isChecked: addIngredientState.isChecked);
        add(AddGroceryEvent(newItem));
      } else if (addIngredientState.status == AddIngredientStatus.edit) {
        add(DeleteGroceryEvent(id: addIngredientState.oldId));
      }
    });
    _sectionNotifier.addListener(() {
      //delay long enough for section reordering to complete
      Future.delayed(const Duration(milliseconds: 500), () {
        add(RefreshGroceriesEvent());
      });
    });

    on<CheckOffGroceryItemEvent>(_handleGroceryItemCheckOff);
    on<AllGroceriesCheckedEvent>(_handleAllGroceriesChecked);
    on<GetGroceriesEvent>(_getGroceries);
    on<AddGroceryEvent>(_addGrocery);
    on<DeleteGroceryEvent>(_deleteGrocery);
    on<UpdateGroceryEvent>(_updateGrocery);
    on<RefreshGroceriesEvent>(_refreshGroceries);
  }

  Future<void> _refreshGroceries(RefreshGroceriesEvent event, Emitter<GroceryState> emit) async {
    try {
      var groceries = await _groceryRepository.getGroceries();

      List<Map<String, List<GroceryItem>>> groceryList = [];

      List<Section> sections = await _sectionRepository.getSections();

      for (var section in sections) {
        var groceriesToAdd = <GroceryItem>[];

        for (var grocery in groceries) {
          if (grocery.category == section.name) {
            groceriesToAdd.add(grocery);
          }
        }

        if (groceriesToAdd.isNotEmpty) {
          groceryList.add({
            section.name: groceriesToAdd,
          });
        }
      }

      if (groceryList.isEmpty) {
        emit(AwaitingGroceries());
      } else {
        emit(GroceriesLoaded(groceryList));
      }
    } catch (error) {
      emit(GroceriesError("Failed to retrieve groceries"));
    }
  }

  Future<void> _getGroceries(GetGroceriesEvent event, Emitter<GroceryState> emit) async {
    try {
      var groceries = await _groceryRepository.getGroceries();

      List<Map<String, List<GroceryItem>>> groceryList = [];

      List<Section> sections = await _sectionRepository.getSections();

      for (var section in sections) {
        var groceriesToAdd = <GroceryItem>[];

        for (var grocery in groceries) {
          if (grocery.category == section.name) {
            groceriesToAdd.add(grocery);
          }
        }

        if (groceriesToAdd.isNotEmpty) {
          groceryList.add({
            section.name: groceriesToAdd,
          });
        }
      }

      if (groceryList.isEmpty) {
        emit(AwaitingGroceries());
      } else {
        emit(GroceriesLoaded(groceryList));
      }
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
      if (event.id == 0) {
        await _groceryRepository.deleteGroceryItem(name: event.name);
      } else {
        await _groceryRepository.deleteGroceryItem(id: event.id);
      }

      add(GetGroceriesEvent());
    } catch (error) {
      emit(GroceriesError("failed to delete grocery item"));
    }
  }

  Future<void> _updateGrocery(UpdateGroceryEvent event, Emitter<GroceryState> emit) async {
    try {
      emit(GroceryInitial());
      var id = await _groceryRepository.updateGroceryItem(event.item);
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
        List<Map<String, List<GroceryItem>>> groceryList = [];

        List<Section> sections = await _sectionRepository.getSections();

        for (var section in sections) {
          var groceriesToAdd = <GroceryItem>[];

          for (var grocery in groceries) {
            if (grocery.category == section.name) {
              groceriesToAdd.add(grocery);
            }
          }

          if (groceriesToAdd.isNotEmpty) {
            groceryList.add({
              section.name: groceriesToAdd,
            });
          }
        }

        emit(GroceriesLoaded(groceryList));
      }
    } catch (err) {
      emit(GroceriesError("Failed to handle grocery item check off"));
    }
  }

  @override
  Future<void> close() {
    _addIngredientStreamSubscription.cancel();
    _groceryItemStreamSubscription.cancel();
    _mealStreamSubscription.cancel();
    _sectionNotifier.removeListener(() {});
    return super.close();
  }

  FutureOr<void> _handleAllGroceriesChecked(
      AllGroceriesCheckedEvent event, Emitter<GroceryState> emit) async {
    emit(AllGroceriesChecked());
    //TODO maybe incorporate animation!?!?!?
    await Future.delayed(const Duration(seconds: 4));
    emit(AwaitingGroceries());
  }
}
