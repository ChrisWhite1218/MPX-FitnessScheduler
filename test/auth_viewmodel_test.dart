// Unit tests for auth_viewmodel
// Verifies that signing in, signing up, and signing out update the user and userModel correctly
// Also checks that the loading state is managed and errors are handled properly

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mpx/viewmodels/auth_viewmodel.dart';
import 'package:mpx/data/auth_repository.dart';
import 'package:mpx/models/user_model.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockUser extends Mock implements User {}

void main() {
  late MockAuthRepository mockRepo;
  late AuthViewModel authVm;
  late MockUser mockUser;
  late UserModel testUserModel;

  setUp(() {
    mockRepo = MockAuthRepository();
    mockUser = MockUser();

    when(() => mockUser.uid).thenReturn('testuid');

    testUserModel = UserModel(
      uid: 'testuid',
      email: 'test@example.com',
      displayName: 'Test User',
      signedUpClasses: [],
      attendedClasses: [],
      points: 0,
    );

    when(() => mockRepo.currentUser).thenReturn(null);
    when(() => mockRepo.fetchUserModel('testuid'))
        .thenAnswer((_) async => testUserModel);

    authVm = AuthViewModel(mockRepo);
  });

  test('signIn updates user and userModel on success', () async {
    when(() => mockRepo.signInWithEmail('test@example.com', 'password'))
        .thenAnswer((_) async => mockUser);

    final result = await authVm.signIn('test@example.com', 'password');

    expect(result, true);
    expect(authVm.user, mockUser);
    expect(authVm.userModel, testUserModel);
    expect(authVm.errorMessage, '');
    expect(authVm.isLoading, false);

    verify(() => mockRepo.signInWithEmail('test@example.com', 'password')).called(1);
    verify(() => mockRepo.fetchUserModel('testuid')).called(1);
  });

  test('signIn sets errorMessage on FirebaseAuthException', () async {
    when(() => mockRepo.signInWithEmail('test@example.com', 'password'))
        .thenThrow(FirebaseAuthException(code: 'user-not-found', message: 'User not found'));

    final result = await authVm.signIn('test@example.com', 'password');

    expect(result, false);
    expect(authVm.user, null);
    expect(authVm.userModel, null);
    expect(authVm.errorMessage, 'User not found');
    expect(authVm.isLoading, false);
  });

  test('signUp updates user and userModel on success', () async {
    when(() => mockRepo.signUpWithEmail('new@example.com', 'password', 'New User'))
        .thenAnswer((_) async => mockUser);

    final result = await authVm.signUp('new@example.com', 'password', 'New User');

    expect(result, true);
    expect(authVm.user, mockUser);
    expect(authVm.userModel, testUserModel);
    expect(authVm.errorMessage, '');
    expect(authVm.isLoading, false);

    verify(() => mockRepo.signUpWithEmail('new@example.com', 'password', 'New User')).called(1);
    verify(() => mockRepo.fetchUserModel('testuid')).called(1);
  });

  test('signOut clears user and userModel', () async {

    when(() => mockRepo.signOut()).thenAnswer((_) async => {});
    authVm = AuthViewModel(mockRepo);

    authVm.signUp('new@example.com', 'password', 'New User');
    when(() => mockRepo.signUpWithEmail('new@example.com', 'password', 'New User'))
        .thenAnswer((_) async => mockUser);

    await authVm.signOut();

    expect(authVm.user, null);
    expect(authVm.userModel, null);
    verify(() => mockRepo.signOut()).called(1);
  });
}
