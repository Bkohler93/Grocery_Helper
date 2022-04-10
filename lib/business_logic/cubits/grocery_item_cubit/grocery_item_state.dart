part of 'grocery_item_cubit.dart';

abstract class GroceryItemState extends Equatable {
  const GroceryItemState();

  @override
  List<Object> get props => [];
}

class GroceryItemInitial extends GroceryItemState {}

class GroceryItemUpdated extends GroceryItemState {
  final GroceryItem item;

  GroceryItemUpdated(this.item);

  @override
  List<Object> get props => [];
}
