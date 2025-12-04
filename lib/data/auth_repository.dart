import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ------------------- Auth -------------------

  Future<User?> signInWithEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(), password: password.trim());
    return cred.user;
  }

  Future<User?> signUpWithEmail(
      String email, String password, String displayName) async {
    final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(), password: password.trim());
    final user = cred.user;
    if (user != null) {
      // Create Firestore user doc
      final userModel = UserModel(
        uid: user.uid,
        email: email.trim(),
        displayName: displayName.trim(),
        points: 0,
        signedUpClasses: [],
        attendedClasses: [],
      );
      await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
      await user.updateDisplayName(displayName.trim());
    }
    return user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;

  Future<UserModel?> fetchUserModel(String uid) async {
    final snap = await _firestore.collection('users').doc(uid).get();
    if (!snap.exists) return null;
    final data = snap.data()!;
    return UserModel.fromMap(Map<String, dynamic>.from(data));
  }

  // ------------------- Points & Classes -------------------

  Future<void> addPoints(String uid, int pointsToAdd) async {
    await _firestore.collection('users').doc(uid).update({
      'points': FieldValue.increment(pointsToAdd),
    });
  }

  Future<void> signUpForClass(String uid, String classId) async {
    await _firestore.collection('users').doc(uid).update({
      'signedUpClasses': FieldValue.arrayUnion([classId]),
    });
    await _firestore.collection('classes').doc(classId).update({
      'attendees': FieldValue.arrayUnion([uid]),
    });
  }

  Future<void> markAttendance(String uid, String classId, {int pointsEarned = 10}) async {
    await _firestore.collection('users').doc(uid).update({
      'attendedClasses': FieldValue.arrayUnion([classId]),
      'points': FieldValue.increment(pointsEarned),
    });
  }

  // Fetch all classes
  Future<List<Map<String, dynamic>>> fetchAllClasses() async {
    final snap = await _firestore.collection('classes').get();
    return snap.docs.map((d) => d.data()).toList();
  }

  // Fetch a single class by ID
  Future<Map<String, dynamic>?> fetchClass(String classId) async {
    final snap = await _firestore.collection('classes').doc(classId).get();
    if (!snap.exists) return null;
    return snap.data();
  }
}
