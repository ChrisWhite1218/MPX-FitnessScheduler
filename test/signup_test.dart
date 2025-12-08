//Tests that tapping the sign up button in class_details_view successfully enrolls user and updates the UI without errors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mpx/models/class_model.dart';
import 'package:mpx/models/user_model.dart';
import 'package:mpx/viewmodels/home_VM.dart';
import 'package:mpx/viewmodels/auth_viewmodel.dart';
import 'package:mpx/views/class_details_view.dart';

class FakeHomeViewModel extends ChangeNotifier implements HomeViewModel {
  List<ClassModel> classes = [];

  @override
  Future<UserModel?> toggleEnrollment(ClassModel classModel, UserModel user) async {
    if (!user.signedUpClasses.contains(classModel.id)) {
      user.signedUpClasses.add(classModel.id);
      classModel.attendees.add(user.uid);
    }
    notifyListeners();
    return user;
  }

  @override List<ClassModel> get allClasses => classes;
  @override List<ClassModel> get upcomingClasses => classes;
  @override List<ClassModel> get completedClasses => [];
  @override bool get loading => false;
  @override Future<void> fetchClasses() async {}
  @override Future<void> loadClasses(UserModel user) async {}
  @override Future<void> removeClassFromUser(String classId, UserModel user) async {}
}

class FakeAuthViewModel extends ChangeNotifier implements AuthViewModel {
  final UserModel testUser;

  FakeAuthViewModel({required this.testUser});

  @override UserModel? get userModel => testUser;
  @override get user => null;

  @override String get errorMessage => '';
  @override bool get isLoading => false;
  @override Future<bool> signIn(String email, String password) async => true;
  @override Future<void> signOut() async {}
  @override Future<bool> signUp(String email, String password, String displayName) async => true;
  @override Future<void> refreshUser() async {}
}

void main() {
  late FakeHomeViewModel homeVm;
  late FakeAuthViewModel authVm;
  late UserModel testUser;
  late ClassModel testClass;

  setUp(() {
    testUser = UserModel(
      uid: 'user1',
      email: 'test@example.com',
      displayName: 'Test User',
      signedUpClasses: [],
      attendedClasses: [],
    );

    testClass = ClassModel(
      id: 'class1',
      name: 'Yoga Class',
      instructor: 'Jane Doe',
      time: DateTime.now(),
      points: 5,
      description: 'A relaxing yoga session',
      capacity: 10,
      attendees: [],
    );

    homeVm = FakeHomeViewModel();
    homeVm.classes = [testClass];

    authVm = FakeAuthViewModel(testUser: testUser);
  });

  testWidgets('Sign Up button adds user to class attendees', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<HomeViewModel>.value(value: homeVm),
          ChangeNotifierProvider<AuthViewModel>.value(value: authVm),
        ],
        child: MaterialApp(
          home: ClassDetailsView(classModel: testClass),
        ),
      ),
    );

    expect(testClass.attendees.contains(testUser.uid), false);

    final signUpButton = find.text('Sign Up');
    expect(signUpButton, findsOneWidget);
    await tester.tap(signUpButton);

    await tester.pumpAndSettle();

    expect(testClass.attendees.contains(testUser.uid), true);

    expect(find.text('Signed up for class'), findsOneWidget);
  });
}
