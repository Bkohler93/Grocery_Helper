part of 'grocery_bloc.dart';

abstract class GroceryEvent extends Equatable {}

class GetGroceriesEvent extends GroceryEvent {
  GetGroceriesEvent();

  @override
  List<Object> get props => [];
}

class RefreshGroceriesEvent extends GroceryEvent {
  RefreshGroceriesEvent();

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
  final String name;

  DeleteGroceryEvent({this.id = 0, this.name = ""});

  @override
  List<Object> get props => [id];
}

class UpdateGroceryEvent extends GroceryEvent {
  final GroceryItem item;

  UpdateGroceryEvent(this.item);

  @override
  List<Object> get props => [item];
}

class CheckOffGroceryItemEvent extends GroceryEvent {
  final GroceryItem item;

  CheckOffGroceryItemEvent(this.item);

  @override
  List<Object> get props => [item];
}

class AllGroceriesCheckedEvent extends GroceryEvent {
  AllGroceriesCheckedEvent();

  @override
  List<Object> get props => [];
}

class EditGroceryEvent extends GroceryEvent {
  final String name;

  EditGroceryEvent(this.name);

  @override
  List<Object> get props => [name];
}
