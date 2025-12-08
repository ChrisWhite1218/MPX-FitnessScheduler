import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/auth_repository.dart';
import '../models/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repo;
  bool _isLoading = false;
  String _errorMessage = '';
  User? _user;
  UserModel? _userModel;

  AuthViewModel(this._repo) {
    _user = _repo.currentUser;
    if (_user != null) _loadUserModel();
  }

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  User? get user => _user;
  UserModel? get userModel => _userModel;

  Future<void> _setLoading(bool v) async {
    _isLoading = v;
    notifyListeners();
  }

  Future<void> _loadUserModel() async {
    if (_user == null) return;
    _userModel = await _repo.fetchUserModel(_user!.uid);
    notifyListeners();
  }

  Future<void> refreshUser() async {
    if (_user == null) return;
    _userModel = await _repo.fetchUserModel(_user!.uid);
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    _errorMessage = '';
    await _setLoading(true);

    try {
      final u = await _repo.signInWithEmail(email, password);
      _user = u;
      await _loadUserModel();
      return true;

    } on FirebaseAuthException catch (_) {
      _errorMessage = 'Invalid email or password';
      return false;

    } catch (e) {
      _errorMessage = 'Invalid email or password';
      return false;

    } finally {
      await _setLoading(false);
    }
  }

  Future<bool> signUp(String email, String password, String displayName) async {
    _errorMessage = '';
    await _setLoading(true);
    try {
      final u = await _repo.signUpWithEmail(email, password, displayName);
      _user = u;
      await _loadUserModel();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Auth error';
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      await _setLoading(false);
    }
  }

  Future<void> signOut() async {
    await _repo.signOut();
    _user = null;
    _userModel = null;
    notifyListeners();
  }
}
