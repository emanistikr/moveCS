import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController {
  final FirebaseAuth _firebaseAuth= FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> addUserDetails(String uid,String name, String surname, String email) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name':name,
      'surname':surname,
      'email':email,
    });
  }

  Future<String?> getUserName(String? uid) async {
    if(uid ==null) {
      return null;
    }
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc['name']+' '+doc['surname'];
  }

  Future<String?> getUid() async {
    return await _firebaseAuth.currentUser?.uid;
  }

} //authController
