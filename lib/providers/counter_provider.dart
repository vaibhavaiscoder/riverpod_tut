import 'package:flutter_riverpod/flutter_riverpod.dart';

// A simple state provider for counter
final counterStateProvider = StateProvider<int>((ref) => 0);

// A provider that returns a static number
final numberProvider = Provider<int>((ref) {
  return 10;
});

// Correct usage of StateNotifierProvider
final numberNotifierProvider = StateNotifierProvider<NumbersNotifier, List<int>>((ref) {
  return NumbersNotifier();
});

class NumbersNotifier extends StateNotifier<List<int>> {
  NumbersNotifier() : super([]);

  // Method to add a number to the list
  void add(int number) {
    state = [...state, number];
  }

  // Method to delete a number from the list
  void delete(int number) {
    state = [
      for (final loopNumber in state)
        if (number != loopNumber) loopNumber
    ];
  }
}

