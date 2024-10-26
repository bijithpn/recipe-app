import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recipe_app/data/models/user_model.dart';

import '../../utils/utils.dart';

class AuthApi {
  final auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  UserModel? currentUser;
  bool isLoggedIn() {
    return auth.currentUser != null;
  }

  // Future<UserModel?> getUser() async {
  //   final user = auth.currentUser;
  //   if (user != null) {
  //     final userDoc = await _firestore.collection('users').doc(user.uid).get();
  //     if (userDoc.exists) {
  //       final userData = UserModel.fromDocument(userDoc);
  //       print(userData.toMap());
  //       // userData['uid'] = auth.currentUser?.uid;
  //       Utils.saveToLocalStorage(key: "userData", data: userData.toMap());
  //     }
  //   }
  //   return null;
  // }

  Future<void> login(String email, String password) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          final userData = UserModel.fromDocument(userDoc);
          Utils.saveToLocalStorage(key: "userData", data: userData.toMap());
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.message != null) {
        return Future.error(e.message!);
      }
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.message != null) {
        return Future.error(e.message!);
      }
    }
  }

  Future<void> signup(
    String name,
    String email,
    String password,
  ) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'name': name,
          'profileImg': name,
        });
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          final userData = UserModel.fromDocument(userDoc);
          Utils.saveToLocalStorage(key: "userData", data: userData.toMap());
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.message != null) {
        return Future.error(e.message!);
      }
    } catch (e) {
      return Future.error(e.toString());
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
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': userCredential.user?.email,
          'name': userCredential.user?.displayName,
          'profileImg': userCredential.user?.displayName,
        });
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          final userData = UserModel.fromDocument(userDoc);
          Utils.saveToLocalStorage(key: "userData", data: userData.toMap());
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.message != null) {
        return Future.error(e.message!);
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<bool> signInAnonymously() async {
    try {
      final userCredential = await auth.signInAnonymously();
      final user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': userCredential.user?.email,
          'name': userCredential.user?.displayName,
          'profileImg': userCredential.user?.displayName,
        });
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          final userData = UserModel.fromDocument(userDoc);
          Utils.saveToLocalStorage(key: "userData", data: userData.toMap());
        }
      }
      return true;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> signout() async {
    try {
      await auth.signOut();
      Utils.clearLocalStorage();
    } on FirebaseAuthException catch (e) {
      if (e.message != null) {
        return Future.error(e.message!);
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
