import 'package:cloud_firestore/cloud_firestore.dart';

class DbService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late final CollectionReference _ref = _db.collection('tasks');
}
