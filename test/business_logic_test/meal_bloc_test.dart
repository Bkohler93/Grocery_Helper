import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_helper_app/business_logic/meal_bloc/meal_bloc.dart';
import 'package:grocery_helper_app/data/models/grocery_item.dart';
import 'package:grocery_helper_app/data/repositories/meal/mock_meal_repository.dart';

void main() {
  group('MealBloc', () {
    late MealBloc mealBloc;
    MockMealRepository mockMealRepository;

    setUp(() {
      EquatableConfig.stringify = true;
      mockMealRepository = MockMealRepository();
      mealBloc = MealBloc(mockMealRepository);
    });

    blocTest<MealBloc, MealState>(
      'emits [MealLoading, MealLoaded] states for successful meals load',
      build: () => mealBloc,
      act: (bloc) => bloc.add(GetMealsEvent()),
      expect: () => [
        const MealLoading(),
        MealLoaded(mockMeals),
      ],
    );

    blocTest<MealBloc, MealState>(
      'emits [MealLoading, MealAdded] states after adding new meal',
      build: () => mealBloc,
      act: (bloc) => bloc.add(AddMealEvent('Spaghetti Squash', <GroceryItem>[
        GroceryItem(category: 'produce', name: 'spaghetti'),
        GroceryItem(category: 'produce', name: 'squash'),
      ])),
      expect: () => [
        const MealLoading(),
        const MealAdded(true),
      ],
    );

    blocTest<MealBloc, MealState>(
      'emits [MealLoading, MealError] states after trying to add duplicate meal',
      build: () => mealBloc,
      act: (bloc) => bloc.add(AddMealEvent('Meatballs with Bulgogi Sauce', <GroceryItem>[
        GroceryItem(category: "meat", name: 'ground beef'),
      ])),
      expect: () => [const MealLoading(), const MealError('A meal with that name already exists')],
    );

    blocTest<MealBloc, MealState>(
      'emits [MealLoading, MealDeleted] states after deleting meal',
      build: () => mealBloc,
      act: (bloc) => bloc.add(DeleteMealEvent('Meatballs with Bulgogi Sauce')),
      expect: () => [const MealLoading(), const MealDeleted()],
    );

    blocTest<MealBloc, MealState>(
      'emits [MealLoading, MealError] states after deleting meal that doesn\'t exist',
      build: () => mealBloc,
      act: (bloc) => bloc.add(DeleteMealEvent('Ravioli Ravioli Meatballs Meatballs')),
      expect: () => [const MealLoading(), const MealError('No meal with that name exists')],
    );

    tearDown(() {
      mealBloc.close();
    });
  });
}
