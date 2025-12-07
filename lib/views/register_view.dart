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

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Semantics(
                  label: 'Full name',
                  hint: 'Enter your full name',
                  textField: true,
                  value: _nameCtrl.text,
                  child: TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: 'Full name'),
                    validator: (v) => (v == null || v.isEmpty) ? 'Enter name' : null,
                  ),
                ),
                const SizedBox(height: 12),
                Semantics(
                  label: 'Email',
                  hint: 'Enter your email',
                  textField: true,
                  value: _emailCtrl.text,
                  child: TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => (v == null || v.isEmpty) ? 'Enter email' : null,
                  ),
                ),
                const SizedBox(height: 12),
                Semantics(
                  label: 'Password',
                  hint: 'Enter your password. Minimum 6 characters',
                  child: ExcludeSemantics(
                    child: TextFormField(
                      controller: _pwCtrl,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (v) => (v == null || v.length < 6) ? '6+ chars' : null,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (vm.errorMessage.isNotEmpty)
                  Semantics(
                    label: 'Error',
                    value: vm.errorMessage,
                    liveRegion: true,
                    child: Text(vm.errorMessage, style: const TextStyle(color: Colors.red)),
                  ),
                const SizedBox(height: 8),
                vm.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Semantics(
                        label: 'Create account',
                        hint: 'Double tap to create a new account',
                        button: true,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) return;
                            final ok = await vm.signUp(
                                _emailCtrl.text, _pwCtrl.text, _nameCtrl.text);
                            if (ok) Navigator.of(context).pop();
                          },
                          child: const Text('Create Account'),
                        ),
                      ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
