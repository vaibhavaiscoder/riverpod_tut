import 'package:flutter_riverpod/flutter_riverpod.dart';

/// This is the state provider (holds an integer value).
final counterProvider = StateProvider<int>((ref) => 0);
