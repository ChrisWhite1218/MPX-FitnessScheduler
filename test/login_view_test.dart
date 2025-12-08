// Tests Login page to make sure widgets are correctly displayed

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mpx/viewmodels/auth_viewmodel.dart';
import 'package:mpx/views/login_view.dart';
import 'package:mpx/models/user_model.dart';
import 'package:mpx/data/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FakeAuthRepository implements AuthRepository {
  @override
  User? get currentUser => null;

  @override
  Future<User?> signInWithEmail(String email, String password) async => null;

  @override
  Future<User?> signUpWithEmail(String email, String password, String displayName) async => null;

  @override
  Future<void> signOut() async {}

  @override
  Future<UserModel?> fetchUserModel(String uid) async {
    return UserModel(
      uid: '123',
      email: 'test@example.com',
      displayName: 'Test User',
      points: 0,
    );
  }

  @override
  Future<void> addPoints(String uid, int pointsToAdd) async {}
  @override
  Future<List<Map<String, dynamic>>> fetchAllClasses() async => [];
  @override
  Future<Map<String, dynamic>?> fetchClass(String classId) async => null;
  @override
  Future<void> markAttendance(String uid, String classId, {int pointsEarned = 10}) async {}
  @override
  Future<void> signUpForClass(String uid, String classId) async {}
}

void main() {
  testWidgets('LoginView renders email, password fields and buttons', (WidgetTester tester) async {
    final viewModel = AuthViewModel(FakeAuthRepository());

    await tester.pumpWidget(
      ChangeNotifierProvider<AuthViewModel>.value(
        value: viewModel,
        child: const MaterialApp(home: LoginView()),
      ),
    );

    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);
  });
}
