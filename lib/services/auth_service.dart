class AuthService {
  // fake login for test
  Future<bool> login(String email, String password) async {
    await Future.delayed(Duration(seconds: 1));
    return email == "test@test.com" && password == "password";
  }

  Future<bool> register(String email, String password) async {
    await Future.delayed(Duration(seconds: 1));
    return true;
  }
}
