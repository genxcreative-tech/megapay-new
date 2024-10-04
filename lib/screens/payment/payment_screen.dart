import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:megapay_new/controllers/api_controller.dart';
import 'package:megapay_new/models/paymentModel.dart';
import 'package:megapay_new/screens/utils/scratchScreen.dart';
import 'package:megapay_new/widgets/loadingDialogue.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'payment_declined_screen.dart';
import 'payment_done_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String price;
  final String opCode;
  final String mobileNumber;
  final String walletBalance;
  
  const PaymentScreen({
    super.key,
    required this.price,
    required this.walletBalance,
    required this.opCode,
    required this.mobileNumber
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedPaymentMethod = 0;

  final List<Map<String, dynamic>> paymentMethods = [
    {'method': 'UPI', 'icon': HugeIcons.strokeRoundedQrCode},
  ];

  // Method to show a loading dialog with CircularProgressIndicator
  

  // Submit recharge only after payment is successful
  void _submitRecharge(double amount) async {
    String mobileNumber = widget.mobileNumber;
    amount = double.tryParse(widget.price) ?? 0.0;

    var validationResult = await RechargeService().validateRecharge(mobileNumber, widget.opCode, amount);
    if (validationResult['status'] == 'success') {
      var rechargeResult = await RechargeService().completeRecharge(mobileNumber, widget.opCode, amount);

      if (rechargeResult['status'] == "failure") {
        print(rechargeResult);
        Get.to(PaymentDeclinedScreen(message: rechargeResult["description"]));
      }
      if (rechargeResult['status'] == "success") {
        Get.to(const PaymentDoneScreen());
      }
    } else {
      print('Validation failed: ${validationResult['description']}');
    }
    Get.to(const ScratchCardScreen());
  }

  // Helper method to build payment method tile
  Widget _buildPaymentTile(
    BuildContext context,
    String title,
    IconData icon,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                selectedPaymentMethod = index;
              });
            },
            borderRadius: BorderRadius.circular(15),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: selectedPaymentMethod == index
                    ? Colors.blue
                    : Colors.grey[300],
                radius: 25,
                child: Icon(icon, color: Colors.white, size: 30),
              ),
              title: Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              trailing: selectedPaymentMethod == index
                  ? const Icon(Icons.check_circle, color: Colors.blue)
                  : const Icon(Icons.circle_outlined, color: Colors.grey),
            ),
          ),
          const Divider()
        ],
      ),
    );
  }



Future<void> initiateTransaction(String username, ) async {
  // Define the URL
  var url = Uri.parse("https://api.lightspeedpay.in/api/v1/transaction/initiate-transaction");

  // Define the request body
  var body = {
    "customerName": username,
    "status": "success",
    "method": "UPI",
    "description": "Payment for ${widget.opCode} Operator Recharge",
    "amount": widget.price,
    "billId": "ABC123456789",
    "vpaId": "johndoe@upi",
    "apiKey": "7f05b36d-5728-4ec8-b6d8-8083de33948f",
    "apiSecret": "iY4jbrPGZiuKH0fepWZgjzkHwIhUysTa",
    "type": "sandbox"
  };

  // Make the POST request
  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );

    // Check the response status and handle accordingly
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      Get.to(const PaymentDoneScreen());
      print('Transaction initiated successfully: $jsonResponse');
    } else {
      print('Failed to initiate transaction. Status code: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  } catch (e) {
    print('Error occurred while initiating transaction: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Pay to Continue',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Total Amount Section with Gradient
          Container(
            height: Get.height / 6,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.white, Colors.white54],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total Amount",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.currency_rupee),
                      GradientText(
                        "${widget.price}.00",
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        colors: const [Colors.blue, Colors.purple, Colors.orange],
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Pay to get your recharge now",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Select Payment Method',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          // Payment Methods List
          
          _buildPaymentTile(context, "UPI", HugeIcons.strokeRoundedPayment01, 0),
          const SizedBox(height: 20),
          // Proceed to Pay Button
          ElevatedButton(
            onPressed: (){
              String priceString = widget.price; // Assuming widget.price is a String
int priceInt = int.parse(priceString); // Converts String to int
             showLoadingDialog(context, "Please Wait", 3, PaymentService().initiatePayment(LivePaymentRequest(customerName: "customerName", status: "success", method: "UPI", description: "Payment For Recharge", amount: priceInt, billId: "billId", vpaId: "vpaId")));
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Proceed to Pay',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}