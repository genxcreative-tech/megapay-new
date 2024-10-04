import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:megapay_new/screens/payment/payment_declined_screen.dart';
import 'package:megapay_new/screens/payment/payment_done_screen.dart';

class PaymentRequest {
  final String customerName;
  final String status;
  final String method;
  final String description;
  final int amount;
  final String billId;
  final String vpaId;
  final String apiKey;
  final String apiSecret;
  final String type;

  PaymentRequest({
    required this.customerName,
    required this.status,
    required this.method,
    required this.description,
    required this.amount,
    required this.billId,
    required this.vpaId,
    required this.apiKey,
    required this.apiSecret,
    required this.type,
  });

  // Convert model to JSON format for API request
  Map<String, dynamic> toJson() {
    return {
      "customerName": customerName,
      "status": status,
      "method": method,
      "description": description,
      "amount": amount,
      "billId": billId,
      "vpaId": vpaId,
      "apiKey": apiKey,
      "apiSecret": apiSecret,
      "type": type,
    };
  }
}


class SandboxPaymentRequest extends PaymentRequest {
  SandboxPaymentRequest({
    required super.customerName,
    required super.status,
    required super.method,
    required super.description,
    required super.amount,
    required super.billId,
    required super.vpaId,
  }) : super(
          apiKey: "7f05b36d-5728-4ec8-b6d8-8083de33948f",  // Sandbox API Key
          apiSecret: "iY4jbrPGZiuKH0fepWZgjzkHwIhUysTa.",   // Sandbox API Secret
          type: "sandbox",
        );
}

class LivePaymentRequest extends PaymentRequest {
  LivePaymentRequest({
    required super.customerName,
    required super.status,
    required super.method,
    required super.description,
    required super.amount,
    required super.billId,
    required super.vpaId,
  }) : super(
          apiKey: "d0bb9b13-84cf-49e2-8a0b-83ee66d71f27",  // Live API Key
          apiSecret: "pIIPKfwQFGHyd0kTZF5GnxU4UJD9m0vq",   // Live API Secret
          type: "live",
        );
}

 // Import the request models

class PaymentService {
  Future<void> initiatePayment(PaymentRequest request) async {
    String url = request.type == 'sandbox'
        ? 'https://api.lightspeedpay.in/api/v1/transaction/sandbox/initiate-transaction'
        : 'https://api.lightspeedpay.in/api/v1/transaction/initiate-transaction';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
         var returnedMsg = jsonDecode(response.body);
         Fluttertoast.showToast(msg: 'Payment initiated successfully: ${returnedMsg["message"]}');
        Get.to(const PaymentDoneScreen());
        print('Payment initiated successfully: ${response.body}');
        // Handle success, parse paymentLink from response
      } else {
        var returnedMsg = jsonDecode(response.body);
        Fluttertoast.showToast(msg: 'Failed to initiate payment: ${returnedMsg["message"]}');
        Get.to(PaymentDeclinedScreen(message: returnedMsg["message"]));
        print('Failed to initiate payment: ${response.body}');
        // Handle failure
      }
    } catch (error) {
      print('Error occurred: $error');
    }
  }
}
