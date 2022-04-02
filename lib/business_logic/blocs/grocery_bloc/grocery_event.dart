part of 'grocery_bloc.dart';

abstract class GroceryEvent extends Equatable {}

class GetGroceriesEvent extends GroceryEvent {
  GetGroceriesEvent();

  @override
  List<Object> get props => [];
}

class AddGroceryEvent extends GroceryEvent {
  final GroceryItem item;

  AddGroceryEvent(this.item);

  @override
  List<Object> get props => [item];
}

class DeleteGroceryEvent extends GroceryEvent {
  final int id;

  DeleteGroceryEvent(this.id);

  @override
  List<Object> get props => [id];
}

class UpdateGroceryEvent extends GroceryEvent {
  final GroceryItem item;

  UpdateGroceryEvent(this.item);

  @override
  List<Object> get props => [item];
}
