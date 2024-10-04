import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:megapay_new/firebase_options.dart';
import 'package:megapay_new/screens/auth/phone_auth_screen.dart';
import 'package:megapay_new/screens/home_screen.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    // Initialize Firebase
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Future<void> _signIn() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // Navigate to home screen or wherever you want after successful login
      Get.offAll(const HomeScreen());
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Login Failed', e.message.toString(), snackPosition: SnackPosition.BOTTOM);
      
    }
  }

  Future<User?> signInWithGoogle(BuildContext context) async {
  // Initialize Google Sign-In
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Trigger the Google authentication flow
  final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  if (googleUser == null) {
    Fluttertoast.showToast(msg: "Unable To Login");
    return null;
  }

  // Obtain the authentication details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Create a new credential using the token
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  try {
    // Sign in to Firebase with the credential
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    // Check if the user is a new user or an existing user
    if (userCredential.additionalUserInfo?.isNewUser == true) {
      // If new user, navigate to the RegisterScreen
      Fluttertoast.showToast(msg: "You don't have an account, Please create a new account to continue.");
      Get.to(SignUpScreen());
    } else {
      // If existing user, navigate to the HomeScreen
      Get.to(const HomeScreen());
    }

    // Return the signed-in user
    return userCredential.user;
  } catch (e) {
    Fluttertoast.showToast(msg: "Login Failed: $e");
    return null;
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                 GradientText(
                  'LIGHT SPEED PAY',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    
                  ),
                  colors: const [
                    Colors.blue,
                    Colors.purple,
                    Colors.orange
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Sign In to Continue',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),
                _buildTextField(
                  controller: emailController,
                  label: 'Email',
                  icon: Icons.email,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: passwordController,
                  label: 'Password',
                  icon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Navigate to Forgot Password screen
                      // Get.toNamed('/forgot_password');
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildButton(
                  text: 'Login',
                  onPressed: _signIn,
                ),
                const SizedBox(height: 16),
                
                ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: (){
        Get.to(const PhoneAuthScreen());
      },
      // ignore: prefer_const_constructors
      child: Text(
        "Continue with phone no.",
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
      ),
    ),
    const Divider(),
    const SizedBox(height: 10,),
    const Text("OR", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey),),
    const SizedBox(height: 10,),
    InkWell(
      onTap: () {
        signInWithGoogle(context);
      },
      child: Container(
        height: 50,
        width: 200,
        decoration:  BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12)
          
        ),
        child: Center(child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Sign In With "),
            const SizedBox(width: 5,),
            Image.asset('assets/google.png',),
          ],
        )),
      ),
    ),
    const SizedBox(height: 60,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Don’t have an account?',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to Sign Up screen
                        Get.to(SignUpScreen());
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.amber),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // ignore: prefer_const_literals_to_create_immutables
        boxShadow: [
          const BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.orange,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
