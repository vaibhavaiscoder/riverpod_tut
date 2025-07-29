import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodbeginner/todo/toDoModel.dart';

class TaskNotifier extends StateNotifier<List<Tasks>> {
  TaskNotifier() : super([]);

  void addTask(Tasks task) {
    state = [...state, task];
  }

  void removeTask(String id) {
    state = state.where((task) => task.id != id).toList();
  }
}

final taskProvider = StateNotifierProvider<TaskNotifier, List<Tasks>>((ref) {
  return TaskNotifier();
});
