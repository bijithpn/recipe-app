import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String email;
  String profileImg;
  MealPlanner? mealPlanner;
  String name;
  List<String> mealTypes;
  List<String> tastePreferences;
  List<String> dietaryPreferences;
  List<String> dietaryRestrictions;
  List<String> cuisineList;

  UserModel({
    required this.uid,
    required this.email,
    required this.profileImg,
    this.mealPlanner,
    required this.name,
    this.mealTypes = const <String>[],
    this.tastePreferences = const <String>[],
    this.dietaryPreferences = const <String>[],
    this.dietaryRestrictions = const <String>[],
    this.cuisineList = const <String>[],
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'profileImg': profileImg,
      'mealPlanner': mealPlanner,
      "mealTypes": mealTypes,
      "tastePreferences": tastePreferences,
      "dietaryPreferences": dietaryPreferences,
      "dietaryRestrictions": dietaryRestrictions,
      "cuisineList": cuisineList,
    };
  }

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final List<String> mealTypes = listMethod(data, 'mealTypes');
    final List<String> tastePreferences = listMethod(data, 'tastePreferences');
    final List<String> cuisineList = listMethod(data, 'cuisineList');
    final List<String> dietaryPreferences =
        listMethod(data, 'dietaryPreferences');
    final List<String> dietaryRestrictions =
        listMethod(data, 'dietaryRestrictions');
    final mealPlanner = data['mealPlanner'] != null
        ? MealPlanner.fromMap(data['mealPlanner'] as Map<String, dynamic>)
        : null;

    return UserModel(
      uid: doc.id,
      email: data['email'] as String,
      profileImg: data['profileImg'] as String,
      mealPlanner: mealPlanner, // Could be null if not present in Firestore
      name: data['name'] as String,
      mealTypes: mealTypes,
      tastePreferences: tastePreferences,
      dietaryPreferences: dietaryPreferences,
      dietaryRestrictions: dietaryRestrictions,
      cuisineList: cuisineList,
    );
  }
}

class MealPlanner {
  String username;
  String spoonacularPassword;
  String hash;

  MealPlanner({
    required this.username,
    required this.spoonacularPassword,
    required this.hash,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'spoonacularPassword': spoonacularPassword,
      'hash': hash,
    };
  }

  factory MealPlanner.fromMap(Map<String, dynamic> data) {
    return MealPlanner(
      username: data['username'] as String,
      spoonacularPassword: data['spoonacularPassword'] as String,
      hash: data['hash'] as String,
    );
  }
}

List<String> listMethod(Map<String, dynamic> data, String key) {
  if (data.containsKey(key)) {
    return (data[key] ?? []).cast<String>();
  } else {
    return [];
  }
}
