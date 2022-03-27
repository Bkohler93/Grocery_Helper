class MealIngredient {
  final int? mealId;
  final int? ingredientId;
  String? qtyUnit;
  String? qty;

  static final columns = ["meal_id", "ingredient_id", "qty_unit", "qty"];

  MealIngredient({
    this.mealId,
    this.ingredientId,
    this.qtyUnit,
    this.qty,
  });

  Map toMap() {
    Map map = {};

    if (mealId != null) {
      map["meal_id"] = mealId;
    }
    if (ingredientId != null) {
      map["ingredient_id"] = ingredientId;
    }
    if (qtyUnit != null) {
      map["qty_unit"] = qtyUnit;
    }
    if (qty != null) {
      map["qty"] = qty;
    }

    return map;
  }

  static fromMap(Map map) {
    MealIngredient newMealIngredient = MealIngredient(
      mealId: map["meal_id"],
      ingredientId: map["ingredient_id"],
    );

    if (map["qty"] != null) {
      newMealIngredient.qty = map["qty"];
    }

    if (map["qty_unit"] != null) {
      newMealIngredient.qtyUnit = map["qty_unit"];
    }
  }
}
