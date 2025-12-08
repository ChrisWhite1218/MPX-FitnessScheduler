import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color.fromRGBO(0, 53, 148, 1), width: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(219, 238, 255, 1),
      appBar: AppBar(
        title: const Text('Welcome to Pitt Fitness Scheduler'),
        backgroundColor: const Color.fromRGBO(255, 184, 28, 1),
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // EMAIL FIELD
                  TextFormField(
                    controller: _emailCtrl,
                    style: const TextStyle(color: Colors.black, fontSize: 28),
                    decoration: _decoration('Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                    (v == null || v.isEmpty) ? 'Enter email' : null,
                  ),

                  const SizedBox(height: 20),

                  // PASSWORD FIELD
                  TextFormField(
                    controller: _pwCtrl,
                    style: const TextStyle(color: Colors.black, fontSize: 28),
                    decoration: _decoration('Password'),
                    obscureText: true,
                    validator: (v) =>
                    (v == null || v.length < 6)
                        ? 'Password must be 6+ chars'
                        : null,
                  ),

                  const SizedBox(height: 20),

                  // ERROR MESSAGE
                  if (vm.errorMessage.isNotEmpty)
                    Text(
                      vm.errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),

                  const SizedBox(height: 20),

                  // SIGN IN BUTTON
                  vm.isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(
                          color: Color.fromRGBO(0, 53, 148, 1),
                          width: 2,
                        ),
                        backgroundColor: Colors.transparent,
                        foregroundColor:
                        const Color.fromRGBO(0, 53, 148, 1),
                        textStyle: const TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;

                        final ok = await vm.signIn(
                          _emailCtrl.text,
                          _pwCtrl.text,
                        );

                        if (ok) {
                          Navigator.of(context)
                              .pushReplacementNamed('/home');
                        }
                      },
                      child: const Text('Sign In'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // REGISTER BUTTON
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const RegisterView()),
                    ),
                    child: const Text(
                      'Create account',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
