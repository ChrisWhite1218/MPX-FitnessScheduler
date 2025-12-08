import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _emailCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  static const pittBlue = Color.fromRGBO(0, 53, 148, 1);

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    _nameCtrl.dispose();
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
        borderSide: BorderSide(color: pittBlue, width: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(219, 238, 255, 1),
      appBar: AppBar(
        title: const Text('Create Your Account'),
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
                  /// NAME FIELD
                  TextFormField(
                    controller: _nameCtrl,
                    style: const TextStyle(color: Colors.black, fontSize: 28),
                    decoration: _decoration('Full Name'),
                    validator: (v) =>
                    (v == null || v.isEmpty) ? 'Enter name' : null,
                  ),

                  const SizedBox(height: 20),

                  /// EMAIL FIELD
                  TextFormField(
                    controller: _emailCtrl,
                    style: const TextStyle(color: Colors.black, fontSize: 28),
                    decoration: _decoration('Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                    (v == null || v.isEmpty) ? 'Enter email' : null,
                  ),

                  const SizedBox(height: 20),

                  /// PASSWORD FIELD
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

                  /// ERROR MESSAGE
                  if (vm.errorMessage.isNotEmpty)
                    const Text(
                      'Invalid email or password',
                      style: TextStyle(color: Colors.red),
                    ),

                  const SizedBox(height: 20),

                  /// CREATE ACCOUNT BUTTON
                  vm.isLoading
                      ? const CircularProgressIndicator(color: pittBlue)
                      : SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(
                            color: pittBlue, width: 2),
                        backgroundColor: Colors.transparent,
                        foregroundColor: pittBlue,
                        textStyle: const TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;

                        final ok = await vm.signUp(
                          _emailCtrl.text,
                          _pwCtrl.text,
                          _nameCtrl.text,
                        );

                        if (ok) Navigator.of(context).pop();
                      },
                      child: const Text('Create Account'),
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
