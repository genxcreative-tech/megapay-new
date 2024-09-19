import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String? _verificationId;
  bool _isOtpSent = false;
  bool _isPhoneNumberValid = true;
  bool _isOtpVerified = false;
  int _resendCounter = 30;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
  }

  void _sendOtp() async {
    setState(() {
      _isPhoneNumberValid = _phoneController.text.length == 10;
    });

    if (_isPhoneNumberValid) {
      final phoneNumber = '+91${_phoneController.text}';
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar('Error', e.message ?? 'Failed to verify phone number');
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _isOtpSent = true;
            _startResendCounter();
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
          });
        },
      );
    }
  }

  void _verifyOtp() async {
    final smsCode = _otpController.text;
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: smsCode,
    );

    try {
      await _auth.signInWithCredential(credential);
      Get.snackbar('Success', 'Phone number verified successfully');
      setState(() {
        _isOtpVerified = true;
      });
    } catch (e) {
      Get.snackbar('Error', 'Invalid OTP');
    }
  }

  void _startResendCounter() {
    _resendCounter = 30;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
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
        title: const Text('Phone Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Enter Phone Number',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
                suffixIcon: _isOtpSent
                    ? null
                    : IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _sendOtp,
                      ),
              ),
              enabled: !_isOtpSent,
            ),
            if (_isOtpSent) ...[
              SizedBox(height: 16.0),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter OTP',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.check),
                    onPressed: _verifyOtp,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text('Resend OTP in $_resendCounter seconds'),
              if (_resendCounter <= 0)
                TextButton(
                  onPressed: _sendOtp,
                  child: Text('Resend OTP'),
                ),
              TextButton(
                onPressed: _onWrongNumber,
                child: Text('Entered wrong number?'),
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
