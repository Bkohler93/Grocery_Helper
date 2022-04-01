part of 'grocery_bloc.dart';

abstract class GroceryEvent {}

class GetGroceriesEvent extends GroceryEvent {
  GetGroceriesEvent();
}

class AddGroceryEvent extends GroceryEvent {
  final GroceryItem item;

  AddGroceryEvent(this.item);
}

class DeleteGroceryEvent extends GroceryEvent {
  final int id;

  DeleteGroceryEvent(this.id);
}

class UpdateGroceryEvent extends GroceryEvent {
  final GroceryItem item;

  UpdateGroceryEvent(this.item);
}
