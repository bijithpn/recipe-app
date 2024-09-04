import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:recipe_app/data/api/auth_api.dart';
import 'package:recipe_app/utils/utils.dart';

import '../core/core.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool? _isFirstTime = Utils.getFomLocalStorage(key: StorageStrings.firstTime);
  final _authApi = AuthApi();

  AuthProvider() {
    _checkFirstTime();
    _authApi.auth.authStateChanges().listen(_onAuthStateChanged);
  }

  User? get user => _user;
  bool? get isFirstTime => _isFirstTime;

  String getIntialPath(BuildContext context) {
    if (isFirstTime == null) {
      return Routes.onboarding;
    }
    if (user == null || isSessionExpired) {
      return Routes.authScreen;
    } else {
      return Routes.home;
    }
  }

  Future<void> _checkFirstTime() async {
    final box = await Hive.openBox('settings');
    _isFirstTime = box.get('isFirstTime', defaultValue: true);
  }

  Future<void> markAsOpened() async {
    final box = await Hive.openBox('settings');
    box.put('isFirstTime', false);
  }

  void _onAuthStateChanged(User? user) {
    _user = user;
    notifyListeners();
  }

  Future<void> signInWithEmail(String email, String password) async {
    await _authApi.login(email, password);
    _startSession();
  }

  Future<void> signUpWithEmail(
      {required String name,
      required String email,
      required String password}) async {
    await _authApi.signup(name, email, password);
    _startSession();
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);

    _startSession();
  }

  Future<bool> signInAnonymously() async {
    try {
      await _authApi.signInAnonymously();
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          debugPrint("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          debugPrint("Unknown error.");
      }
    }
    _startSession();
    return false;
  }

  Future<void> _startSession() async {
    final box = await Hive.openBox('settings');
    box.put('sessionStart', DateTime.now());
  }

  bool get isSessionExpired {
    final box = Hive.box('settings');
    final sessionStart = box.get('sessionStart');
    if (sessionStart == null) return true;
    return DateTime.now().difference(sessionStart).inDays > 5;
  }

  Future<void> signOut() async {
    await _authApi.signout();
    notifyListeners();
  }
}
