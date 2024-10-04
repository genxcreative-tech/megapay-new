import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:megapay_new/screens/auth/phone_auth_screen.dart';
import 'package:megapay_new/screens/home_screen.dart';
import 'package:megapay_new/screens/onBoarding/onBoardingScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with options specific to the current platform
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Initialize Hive
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);

  // Open a box to store API data
  await Hive.openBox('planstitlebox');
  // await Hive.openBox('plansBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Light Speed Pay',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AnimatedSplashScreen(splash: 'assets/logo.png', nextScreen: const OnboardingHandler()),
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
      return  const HomeScreen();
    } else {
      // If user is not logged in, go to LoginScreen
      return const PhoneAuthScreen();
    }
  }
}

class OnboardingHandler extends StatefulWidget {
  const OnboardingHandler({super.key});

  @override
  _OnboardingHandlerState createState() => _OnboardingHandlerState();
}

class _OnboardingHandlerState extends State<OnboardingHandler> {
  bool _isFirstLaunch = true;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenOnboarding = prefs.getBool('seenOnboarding') ?? false;

    setState(() {
      _isFirstLaunch = !hasSeenOnboarding;
    });
  }

  Future<void> _setOnboardingSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
  }

  @override
  Widget build(BuildContext context) {
    return _isFirstLaunch ? OnBoarding(_setOnboardingSeen) : const PhoneAuthScreen();
  }
}