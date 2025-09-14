import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app/features/auth/domain/repository/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<AppUser?> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCrendentials = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      AppUser appUser = AppUser(
        email: email,
        uid: userCrendentials.user!.uid,
        name: '',
      );
      return appUser;
    } catch (e) {
      throw Exception('Login failed + $e');
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = firebaseAuth.currentUser;
    if (firebaseUser == null) {
      return null;
    }
    return AppUser(uid: firebaseUser.uid, email: firebaseUser.email!, name: '');
  }

  @override
  Future<void> logOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<AppUser?> registerWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
          
      AppUser appUser = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: name,
      );

      await firebaseFirestore
          .collection("users")
          .doc(appUser.uid)
          .set(appUser.toJson());
      return appUser;
    } catch (e) {
      throw Exception('Sign Up failed');
    }
  }
}
