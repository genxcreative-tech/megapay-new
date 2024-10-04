import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:fluttertoast/fluttertoast.dart';  // Import FlutterToast

class Pay1ApiService {
  // API URL for MNP Check
  final String apiUrl = "https://recharges.pay1.in/api/recharge/mnpCheck?partner_id=P0232044&trans_id=221658&mobile=9892526032";
  
  // Authorization credentials (Partner ID and API Key)
  final String username = "P0232044";  // Partner ID
  final String password = "nV4G@v2!24&";  // API Key (SALT)

  // Method to generate a new token for each request
  String generateToken(Map<String, dynamic> params) {
    // Convert the parameters to a JSON string
    String jsonString = json.encode(params);

    // Use the SALT as the encryption key
    final key = encrypt.Key.fromUtf8(sha256.convert(utf8.encode(password)).toString().substring(0, 32));
    final iv = encrypt.IV.fromUtf8("0000000000000000");

    // Encrypt the JSON string using AES-256-CBC
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(jsonString, iv: iv);

    // Return the Base64 encoded token
    return encrypted.base64;
  }

  // Method to call the API and show result with FlutterToast
  Future<void> runMnpCheckApi() async {
    // Define the request parameters
    Map<String, dynamic> params = {
      "partner_id": "25",
      "trans_id": "012654",
      "mobile": "9892526032"
    };

    // Generate a new token for this request
    String token = generateToken(params);

    // Base64 encode username:password for Basic Auth
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    // Set headers
    Map<String, String> headers = {
      'Authorization': basicAuth,
      'Token': token,
      'Accept': 'application/json',  // Specify JSON format
    };
    print(token);

    try {
      // Make the GET request
      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        // Parse the JSON response
        var jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == 'success') {
          // Show success message using FlutterToast
          Fluttertoast.showToast(
            msg: 'Operator Code: ${jsonResponse['data']['opr_code']}, Circle Code: ${jsonResponse['data']['circle']}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        } else {
          // Show error message using FlutterToast
          Fluttertoast.showToast(
            msg: jsonResponse['message'] ?? 'Unknown error occurred',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } else {
        // Handle failed request
        Fluttertoast.showToast(
          msg: 'Failed to connect. Status code: ${response.statusCode}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      // Show exception error using FlutterToast
      Fluttertoast.showToast(
        msg: 'Error occurred: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}

class TestingPage extends StatelessWidget {
  const TestingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(  // Use MaterialApp
      home: Scaffold(
        appBar: AppBar(title: const Text('Pay1 API Example')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Pay1ApiService().runMnpCheckApi();
            },
            child: const Text('Run MNP Check API'),
          ),
        ),
      ),
    );
  }
}
