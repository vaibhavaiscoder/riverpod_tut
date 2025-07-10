
// create db service instance
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_tut2/models/taskModel.dart';
import 'package:riverpod_tut2/services/db_service.dart';

final taskDBServiceProvider = Provider<DbService>((ref){
  return DbService();
});

//stream provider to get the list of tasks
final taskStreamProvider = StreamProvider<List<Task>>((ref){
  final dbService = ref.watch(taskDBServiceProvider);
  return dbService.fetchAllTasks();
});

final favTaskStreamProvider = StreamProvider<List<Task>>((ref){
  final dbService = ref.watch(taskDBServiceProvider);
  return dbService.fetchFavoriteTasks();
});