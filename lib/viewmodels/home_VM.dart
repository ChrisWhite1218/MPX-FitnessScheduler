import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/class_model.dart';
import '../models/user_model.dart';

class HomeViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<ClassModel> _allClasses = [];
  List<ClassModel> get allClasses => _allClasses;

  List<ClassModel> _upcomingClasses = [];
  List<ClassModel> get upcomingClasses => _upcomingClasses;

  List<ClassModel> _completedClasses = [];
  List<ClassModel> get completedClasses => _completedClasses;

  bool _loading = false;
  bool get loading => _loading;

  /// Fetch all classes from Firestore
  Future<void> fetchClasses() async {
    _loading = true;
    notifyListeners();

    try {
      final snapshot = await _db.collection('classes').get();

      _allClasses = snapshot.docs
          .map((doc) => ClassModel.fromMap(doc.data(), docId: doc.id))
          .toList();

      for (var doc in snapshot.docs) {
        debugPrint('Fetched class doc: ${doc.id} -> ${doc.data()}');
      }
      debugPrint('All classes loaded: ${_allClasses.map((c) => c.name).toList()}');
    } catch (e) {
      debugPrint('Error fetching classes: $e');
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> removeClassFromUser(String classId, UserModel user) async {
    try {
      final classRef = _db.collection('classes').doc(classId);
      final userRef = _db.collection('users').doc(user.uid);

      // Remove user from class attendees
      await classRef.update({
        'attendees': FieldValue.arrayRemove([user.uid])
      });

      // Remove class from user's signedUpClasses
      await userRef.update({
        'signedUpClasses': FieldValue.arrayRemove([classId])
      });

      final updatedUserDoc = await userRef.get();
      final updatedUser = UserModel.fromMap(updatedUserDoc.data()!);

      debugPrint("Class removed. Updated user loaded.");

      // Reload classes using the fresh user object
      await loadClasses(updatedUser);

    } catch (e) {
      debugPrint("Error removing class: $e");
    }
  }



  /// Load upcoming and completed classes for a user
  Future<void> loadClasses(UserModel user) async {
    _loading = true;
    notifyListeners();

    try {
      if (_allClasses.isEmpty) {
        await fetchClasses();
      }

      _upcomingClasses = _allClasses
          .where((c) => user.signedUpClasses.contains(c.id))
          .toList();

      _completedClasses = _allClasses
          .where((c) => user.attendedClasses.contains(c.id))
          .toList();

      debugPrint('Loading classes for user: ${user.uid}');
      debugPrint('Upcoming classes: ${_upcomingClasses.map((c) => c.name).toList()}');
      debugPrint('Completed classes: ${_completedClasses.map((c) => c.name).toList()}');
    } catch (e) {
      debugPrint('Error loading user classes: $e');
    }

    _loading = false;
    notifyListeners();
  }

  /// Toggle enrollment: sign up or unenroll
Future<void> toggleEnrollment(ClassModel classModel, UserModel user) async {
  if (classModel.id.isEmpty || user.uid.isEmpty) {
    debugPrint('ERROR: classModel.id or user.uid is empty!');
    return;
  }

  debugPrint('Sign Up button pressed for class ${classModel.name}');
  debugPrint('Current attendees: ${classModel.attendees}');
  debugPrint('User ID: ${user.uid}');

  final classRef = _db.collection('classes').doc(classModel.id);
  final userRef = _db.collection('users').doc(user.uid);

  final isEnrolled = classModel.attendees.contains(user.uid);

  try {
    if (isEnrolled) {
      debugPrint('User already signed up.');
      return; // do nothing
    }

    // Add user to class attendees
    await classRef.update({
      'attendees': FieldValue.arrayUnion([user.uid])
    });

    // Add class ID to user's signedUpClasses
    await userRef.update({
      'signedUpClasses': FieldValue.arrayUnion([classModel.id])
    });

    debugPrint('User successfully signed up.');

    // Reload classes for user
    await loadClasses(user);
  } catch (e) {
    debugPrint('Error signing up: $e');
  }
}
}
