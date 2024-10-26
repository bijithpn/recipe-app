import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/data/models/user_model.dart';
import 'package:recipe_app/main.dart';

import '../../core/core.dart';
import '../../utils/utils.dart';
import '../services/api_service.dart';

class UserRespository {
  static final apiClient = getIt<ApiClient>();
  static final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  static Future<void> updateUserData(
      String userId, Map<String, dynamic> userData) async {
    try {
      await _usersCollection.doc(userId).update(userData);
    } catch (e) {
      debugPrint('Error adding task list: $e');
      rethrow;
    }
  }

  static Future<UserModel?> getUserData(
    String userId,
  ) async {
    try {
      DocumentSnapshot userData = await _usersCollection.doc(userId).get();
      return UserModel.fromDocument(userData);
    } catch (e) {
      debugPrint('Error adding task list: $e');
      rethrow;
    }
  }

  static Future<void> genUserData(String ingredients) async {
    try {
      final userData = Utils.getFomLocalStorage(key: StorageStrings.userData);
      final res =
          await apiClient.get(ApiEndpoint.genUserData, queryParameters: {
        "firstName": userData['name'],
        "email": userData['email'],
      });
      Utils.saveToLocalStorage(key: StorageStrings.mealData, data: res.data);
      // return res.data ?? {};
    } catch (e) {
      rethrow;
    }
  }
}
