import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megapay_new/screens/payment/payment_declined_screen.dart';
import 'package:megapay_new/screens/payment/payment_done_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String price;
  PaymentScreen({super.key, required this.price});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedPaymentMethod = 0;

  // List of payment options
  final List<Map<String, dynamic>> paymentMethods = [
    {'method': 'Credit Card', 'icon': Icons.credit_card},
    {'method': 'Debit Card', 'icon': Icons.payment},
    {'method': 'UPI', 'icon': Icons.qr_code},
    {'method': 'Paytm', 'icon': Icons.account_balance_wallet},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mega Pay - Payment',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.price,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                   const SizedBox(height: 5),
                  Text(
                    "Pay to get your recharge now",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
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
          Column(
            children: paymentMethods
                .asMap()
                .entries
                .map((entry) => _buildPaymentTile(
                      context,
                      entry.value['method'],
                      entry.value['icon'],
                      entry.key,
                    ))
                .toList(),
          ),
          const SizedBox(height: 20),
          // Proceed to Pay Button
          ElevatedButton(
            onPressed: _processPayment,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Proceed to Pay',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build a payment method tile
  Widget _buildPaymentTile(
    BuildContext context,
    String title,
    IconData icon,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
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
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: selectedPaymentMethod == index
                ? const Icon(Icons.check_circle, color: Colors.blue)
                : const Icon(Icons.circle_outlined, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  // Method to handle the payment process
  void _processPayment() {
    String selectedMethod = paymentMethods[selectedPaymentMethod]['method'];
    // Display selected method
    Get.snackbar(
      "Payment",
      "You selected $selectedMethod. Processing...",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withOpacity(0.8),
      colorText: Colors.white,
    );

    // Example logic: Redirect to declined screen if method is not Paytm
    if (selectedMethod != "Paytm") {
      Get.to(PaymentDeclinedScreen());
    }else{
      Get.to(PaymentDoneScreen());
    }
  }
}
