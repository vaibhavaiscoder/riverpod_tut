import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_tut/apiServices.dart';
import 'package:riverpod_tut/models/createUserModel.dart';
import 'package:riverpod_tut/models/userModel.dart';

final dataProvider = FutureProvider<List<Datum>>((ref) async {
  return ref.watch(apiServiceProvider).getUsers();
});

final userAddProvider = StateNotifierProvider<UserNotifier,CreateUser?>((ref){
  return UserNotifier(ref.read(apiServiceProvider));
});

class UserNotifier extends StateNotifier<CreateUser?>{
  final ApiServices apiServices;
  UserNotifier(this.apiServices) : super(null);

  Future<void> createUser(name, job)async{
    try{
      final user = await apiServices.createUser(name, job);
      state = user;
    }catch(e){
      state = null;
    }
  }

}
