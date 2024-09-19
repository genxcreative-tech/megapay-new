import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megapay_new/screens/auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  void logout () async{
    await FirebaseAuth.instance.signOut();
    Get.snackbar(
    'Logged Out',
    'You have been logged out successfully.',
     snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
       colorText: Colors.white,
       );

              // Navigate to login screen or any other screen as needed
              Get.offAll(LoginScreen()); // Replace '/login' with the route name of your login screen
            }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
     bottomNavigationBar: Padding(
       padding: const EdgeInsets.all(16.0),
       child: InkWell(
        onTap: () => logout(),
         child: Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.redAccent
          ),
          child: Center(child: Text("Logout", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),)),
         ),
       ),
     ),
    );
  }
}
