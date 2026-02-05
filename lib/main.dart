import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hiresense/presentation/pages/dashboard.dart';
import 'package:hiresense/presentation/pages/login.dart';
import 'package:hiresense/presentation/pages/signup.dart';
import 'package:hiresense/presentation/pages/splash.dart';
import 'package:hiresense/presentation/pages/verify_email.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SplashPage(),
      routes: {
        "/login": (_) => const LoginPage(),
        "/signup": (_) => const SignUpPage(),
        "/verify": (_) => const EmailVerificationPage(),
        "/dashboard": (_) => const DashboardPage(),
      },
    );
  }
}
