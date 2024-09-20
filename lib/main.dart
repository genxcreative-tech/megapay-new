import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megapay_new/screens/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:megapay_new/screens/home_screen.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with options specific to the current platform
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mega Pay',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  const AuthChecker(),
    );
  }
}

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if the user is logged in
    User? user = FirebaseAuth.instance.currentUser;

    // If user is logged in, go to HomeScreen
    if (user != null) {
      return const HomeScreen();
    } else {
      // If user is not logged in, go to LoginScreen
      return const LoginScreen();
    }
  }
}