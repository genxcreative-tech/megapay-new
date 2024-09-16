import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'web_view_Screen.dart'; // Import the WebView Screen you created

class MobileRechargeScreen extends StatefulWidget {
  @override
  _MobileRechargeScreenState createState() => _MobileRechargeScreenState();
}

class _MobileRechargeScreenState extends State<MobileRechargeScreen> {
  final TextEditingController _mobileController = TextEditingController();
  bool _isLoading = false;

  // Method to find operator and handle redirection
  Future<void> _findOperator() async {
    const String apiUrl = 'https://auth.scrizapay.in/api/plan/v1/find-operator';
    const String apiToken = 'gOb9DS2Ee4auV6UzG9ImUk9QGTXvvzu0TXex';
    final String mobileNumber = _mobileController.text;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'api_token': apiToken,
          'mobile_number': mobileNumber,
        },
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        // Handle success if the API returns operators (if applicable)
        final data = jsonDecode(response.body);
        // Assuming you are using 'operators' from the API response
      } else if (response.statusCode == 302) {
        // Handle redirection to a new URL
        final redirectUrl = response.headers['location']; // Get the redirect URL
        if (redirectUrl != null) {
          // Navigate to the WebViewScreen with the redirect URL
         Get.to(WebViewPage(url: redirectUrl));
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile Recharge'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Enter Mobile Number',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildMobileNumberField(),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _findOperator,
                    child: Text('Find Operator'),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileNumberField() {
    return TextField(
      controller: _mobileController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'Mobile Number',
        border: OutlineInputBorder(),
      ),
    );
  }
}
