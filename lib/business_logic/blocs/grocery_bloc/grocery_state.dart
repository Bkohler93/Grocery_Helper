part of "grocery_bloc.dart";

abstract class GroceryState extends Equatable {
  const GroceryState();

  @override
  List<Object> get props => [];
}

class GroceryInitial extends GroceryState {
  const GroceryInitial();

  @override
  List<Object> get props => [];
}

class GroceryLoading extends GroceryState {
  const GroceryLoading();

  @override
  List<Object> get props => [];
}

class GroceriesLoaded extends GroceryState {
  final List<Map<String, List<GroceryItem>>> groceries;
  const GroceriesLoaded(this.groceries);

  @override
  List<Object> get props => [groceries];
}

class GroceryAdded extends GroceryState {
  final int id;
  const GroceryAdded(this.id);

  @override
  List<Object> get props => [id];
}

class GroceryDeleted extends GroceryState {
  final int id;
  const GroceryDeleted(this.id);

  @override
  List<Object> get props => [id];
}

class GroceriesError extends GroceryState {
  final String msg;
  const GroceriesError(this.msg);

  @override
  List<Object> get props => [msg];
}

class GroceryUpdated extends GroceryState {
  final int id;
  const GroceryUpdated(this.id);

  @override
  List<Object> get props => [id];
}

class AllGroceriesChecked extends GroceryState {
  const AllGroceriesChecked();

  @override
  List<Object> get props => [];
}

class AwaitingGroceries extends GroceryState {
  const AwaitingGroceries();

  @override
  List<Object> get props => [];
}
