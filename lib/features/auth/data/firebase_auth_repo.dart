import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mangadex_app/features/auth/domain/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;

  @override
  bool loggedIn() {
    return firebaseAuth.currentUser != null;
  }

  @override
  Future<void> login(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  @override
  Future<void> register(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await firebaseFirestore
          .collection('Users')
          .doc(userCredential.user!.uid)
          .set({'email': email});
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  @override
  void logout() {
    firebaseAuth.signOut();
  }
}
