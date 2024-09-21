import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megapay_new/screens/auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
              Get.offAll(const LoginScreen()); // Replace '/login' with the route name of your login screen
            }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'My Account',
          style: TextStyle(color: Colors.black, fontSize: 22),
          
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        
      ),
     bottomNavigationBar: Padding(
       padding: const EdgeInsets.all(16.0),
       child: InkWell(
        onTap: () => logout(),
         child: Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[300]
          ),
          child: const Center(child: Text("Logout", style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),)),
         ),
       ),
     ),
    );
  }
}
