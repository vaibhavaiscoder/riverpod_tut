import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_tut2/models/taskModel.dart';

class DbService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late final CollectionReference _ref = _db.collection('tasks');

  // add dat to collection tasks
  Future<void> addNewTask(Task task) async {
    await _ref.doc(task.id).set(task.toMap());
  }

  //get list of tasks

  Stream<List<Task>> fetchAllTasks() {
    return _ref.snapshots().map(
      (snap) => snap.docs
          .map(
            (doc) => Task.fromMap(doc.id, doc.data() as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  //update
  Future<void> updateTask(Task task) async {
    await _ref.doc(task.id).update(task.toMap());
  }
  //delete
  Future<void> deleteTask(Task task) async {
    await _ref.doc(task.id).delete();
  }
}
