import 'package:flutter_hive_db_blog/user_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class HiveDataStore {
  static const boxName = "userBox";

  // Get reference to an already opened box
  static Box box = Hive.box(boxName);

  /// Add new user
  Future<void> addUser({required UserModel userModel}) async {
    await box.add(userModel);
  }

  /// show user list
  Future<void> getUser({required String id})async{
    await box.get(id);
  }

  /// update user data
  Future<void> updateUser({required int index,required UserModel userModel}) async {
    await box.putAt(index,userModel);
  }

  /// delete user
  Future<void> deleteUser({required int index}) async {
    await box.deleteAt(index);
  }

}
