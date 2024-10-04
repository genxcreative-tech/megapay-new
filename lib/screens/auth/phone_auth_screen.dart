import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

import 'package:megapay_new/screens/home_screen.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';



class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isOtpSent = false;
  bool _isPhoneNumberValid = true;
  bool _isOtpVerified = false;
  int _resendCounter = 30;
  Timer? _resendTimer;
  String _generatedOtp = '';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    String? userId = _phoneController.text.isNotEmpty ? '+91${_phoneController.text}' : null; // Replace with logic to get user phone number

    if (userId != null && userId.isNotEmpty) {
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      DocumentSnapshot userSnapshot = await users.doc(userId).get();

      if (userSnapshot.exists && userSnapshot['isLoggedIn'] == true) {
        Get.off(() => const HomeScreen());
      }
    }
  }

  Future<void> _sendOtp() async {
    setState(() {
      _isPhoneNumberValid = _phoneController.text.length == 10;
    });

    if (_isPhoneNumberValid) {
      setState(() {
        _isOtpSent = true;
        _startResendCounter();
      });

      String phone = '+91${_phoneController.text}'; // Format with country code
      _generatedOtp = _generateOtp(); // Generate 6-digit OTP
      await _sendOtpViaApi(phone, _generatedOtp); // Use your API to send OTP
      _saveOtpToFirebase(phone, _generatedOtp); // Save OTP to Firestore
    }
  }

  String _generateOtp() {
    Random random = Random();
    return (100000 + random.nextInt(900000)).toString(); // Generates 6-digit OTP
  }

  Future<void> _sendOtpViaApi(String phone, String otp) async {
    String url =
        'https://wap.xhost.co.in/wapp/v2/api/send?apikey=f96b3d3c952a4817a51b05b258f9f048&mobile=$phone&msg=Your%20OTP%20for%20LightSpeedPay%20is%20$otp';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Get.snackbar('OTP Sent', 'OTP has been sent to $phone');
      } else {
        Get.snackbar('Error', 'Failed to send OTP');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to send OTP: $e');
    }
  }

  Future<void> _saveOtpToFirebase(String phone, String otp) async {
    if (phone.isNotEmpty) {
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      await users.doc(phone).set({
        'otp': otp,
        'isLoggedIn': false,
      }, SetOptions(merge: true));
    } else {
      Get.snackbar('Error', 'Phone number cannot be empty');
    }
  }

  Future<void> _verifyOtp() async {
    String enteredOtp = _otpController.text;
    String phone = '+91${_phoneController.text}'; // Add country code

    if (phone.isNotEmpty) {
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      DocumentSnapshot userSnapshot = await users.doc(phone).get();
      if (userSnapshot.exists) {
        String savedOtp = userSnapshot['otp'];
        if (enteredOtp == savedOtp) {
          Get.snackbar('Success', 'Phone number verified successfully');
          setState(() {
            _isOtpVerified = true;
          });

          _saveLoginStateToFirebase(phone);
          Get.off(() => const HomeScreen());
        } else {
          Get.snackbar('Error', 'Invalid OTP');
        }
      } else {
        Get.snackbar('Error', 'No OTP found for this phone number');
      }
    } else {
      Get.snackbar('Error', 'Phone number cannot be empty');
    }
  }

  Future<void> _saveLoginStateToFirebase(String userId) async {
    if (userId.isNotEmpty) {
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      await users.doc(userId).set({
        'isLoggedIn': true,
        'lastLogin': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)).then((_) {
        print("User login state updated");
      }).catchError((error) {
        print("Failed to update login state: $error");
      });
    } else {
      Get.snackbar('Error', 'User ID cannot be empty');
    }
  }

  void _startResendCounter() {
    _resendCounter = 30;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _resendCounter--;
        if (_resendCounter <= 0) {
          timer.cancel();
        }
      });
    });
  }

  void _onWrongNumber() {
    setState(() {
      _isOtpSent = false;
      _phoneController.clear();
      _otpController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset('assets/logo.png', height: 50),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
             GradientText(
              "Please Enter Your Phone Number \nTo Continue",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), colors: [Colors.blue,Colors.purple, Colors.orange, ],
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Enter Phone Number',
                prefixIcon: const Icon(Icons.phone),
                border: const OutlineInputBorder(),
                suffixIcon: _isOtpSent
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _sendOtp,
                      ),
              ),
              enabled: !_isOtpSent,
            ),
            if (_isOtpSent) ...[
              const SizedBox(height: 16.0),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  labelText: 'Enter OTP',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: _verifyOtp,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text('Resend OTP in $_resendCounter seconds'),
              if (_resendCounter <= 0)
                TextButton(
                  onPressed: _sendOtp,
                  child: const Text('Resend OTP'),
                ),
              TextButton(
                onPressed: _onWrongNumber,
                child: const Text('Entered wrong number?'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }
}
