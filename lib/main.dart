import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'data/auth_repository.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'views/login_view.dart';
import 'views/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authRepo = AuthRepository();
  final authVm = AuthViewModel(authRepo);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>.value(value: authVm),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MPX Fitness Scheduler',
      debugShowCheckedModeBanner: false,

      // Named routes
      routes: {
        '/login': (_) => const LoginView(),
        '/home': (_) => const HomeView(),
      },

      // Start with the login page
      initialRoute: '/login',
    );
  }
}
