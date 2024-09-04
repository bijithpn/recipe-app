import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:recipe_app/data/api/auth_api.dart';
import 'package:recipe_app/main.dart';

import '../data/services/notification_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  final _authApi = getIt<AuthApi>();
  final _notificationService = getIt<NotificationService>();
  AuthProvider() {
    _authApi.auth.authStateChanges().listen(_onAuthStateChanged);
  }

  User? get user => _user;

  void _onAuthStateChanged(User? user) {
    _user = user;
    notifyListeners();
  }

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      await _authApi.login(email, password);
      _startSession();
      return true;
    } catch (e) {
      _notificationService.showSnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(vertical: 20),
          context: navigatorKey.currentContext!,
          message: e.toString());
      return false;
    }
  }

  Future<bool> signUpWithEmail(
      {required String name,
      required String email,
      required String password}) async {
    try {
      await _authApi.signup(name, email, password);
      _startSession();
      return true;
    } catch (e) {
      _notificationService.showSnackBar(
          context: navigatorKey.currentContext!, message: e.toString());
      return false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      _startSession();
    } catch (e) {
      _notificationService.showSnackBar(
          context: navigatorKey.currentContext!, message: e.toString());
    }
  }

  Future<bool> signInAnonymously() async {
    try {
      await _authApi.signInAnonymously();
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          _notificationService.showSnackBar(
              context: navigatorKey.currentContext!,
              message: "Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          _notificationService.showSnackBar(
              context: navigatorKey.currentContext!, message: "Unknown error.");
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
