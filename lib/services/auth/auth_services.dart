import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Sign in
  Future<UserCredential> signInWithEmailAndPassword(
      String mail, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: mail, password: password);

      // Check if the user data already exists in Firestore
      DocumentSnapshot userDoc = await _fireStore
          .collection("users")
          .doc(userCredential.user!.uid)
          .get();

      // If the user document doesn't exist, create it
      if (!userDoc.exists) {
        await _fireStore.collection("users").doc(userCredential.user!.uid).set({
          'uId': userCredential.user!.uid,
          'email': userCredential.user!.email,
          'name': userCredential.user!.displayName ?? 'Anonymous',
        });
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Register
  Future<bool> registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        await _fireStore.collection('users').doc(user.uid).set({
          'uId': user.uid,
          'email': email,
          'name': name,
        });
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }
}
