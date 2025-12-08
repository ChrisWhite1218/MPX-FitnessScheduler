// Tests that tapping the Browse Classes button on home_view navigates to browse_classes_view

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mpx/views/home_view.dart';
import 'package:mpx/views/browse_classes_view.dart';
import 'package:mpx/viewmodels/auth_viewmodel.dart';
import 'package:mpx/viewmodels/home_VM.dart';
import 'package:mpx/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mpx/models/class_model.dart';

// Minimal fake AuthViewModel
class FakeAuthViewModel extends ChangeNotifier implements AuthViewModel {
  @override
  User? get user => null;

  @override
  UserModel? get userModel => null;

  @override
  bool get isLoading => false;

  @override
  String get errorMessage => '';

  @override
  Future<bool> signIn(String email, String password) async => true;

  @override
  Future<bool> signUp(String email, String password, String displayName) async => true;

  @override
  Future<void> signOut() async {}

  @override
  Future<void> refreshUser() async {}
}

// Minimal fake HomeViewModel
class FakeHomeViewModel extends ChangeNotifier implements HomeViewModel {
  @override
  List<ClassModel> get allClasses => [];

  @override
  List<ClassModel> get completedClasses => [];

  @override
  List<ClassModel> get upcomingClasses => [];

  @override
  bool get loading => false;

  @override
  Future<void> fetchClasses() async {}

  @override
  Future<void> loadClasses(UserModel user) async {}

  @override
  Future<void> removeClassFromUser(String classId, UserModel user) async {}

  @override
  Future<UserModel?> toggleEnrollment(ClassModel classModel, UserModel user) async => null;
}

void main() {
  testWidgets('Browse Classes button navigates to BrowseClassesView', (WidgetTester tester) async {
    final authVm = FakeAuthViewModel();
    final homeVm = FakeHomeViewModel();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthViewModel>.value(value: authVm),
          ChangeNotifierProvider<HomeViewModel>.value(value: homeVm),
        ],
        child: MaterialApp(
          home: HomeView(),
          routes: {
            '/browse-classes': (_) => BrowseClassesView(),
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Find the Browse Classes button using its text
    final browseButton = find.widgetWithText(ElevatedButton, 'Browse Classes');
    expect(browseButton, findsOneWidget);

    // Tap the button
    await tester.tap(browseButton);
    await tester.pumpAndSettle();

    // Verify navigation occurred
    expect(find.byType(BrowseClassesView), findsOneWidget);
  });
}
