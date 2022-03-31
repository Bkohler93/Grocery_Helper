part of "grocery_bloc.dart";

abstract class GroceryState {
  const GroceryState();
}

class GroceryInitial extends GroceryState {
  const GroceryInitial();
}

class GroceryLoading extends GroceryState {
  const GroceryLoading();
}

class GroceryLoaded extends GroceryState {
  final List<GroceryItem> groceries;
  const GroceryLoaded(this.groceries);
}
