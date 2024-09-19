import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megapay_new/screens/payment/payment_screen.dart';

class RechargePlansScreen extends StatefulWidget {
  String optName;
  RechargePlansScreen({super.key, required this.optName});

  @override
  _RechargePlansScreenState createState() => _RechargePlansScreenState();
}

class _RechargePlansScreenState extends State<RechargePlansScreen> {
  int? selectedPlanIndex;
  TextEditingController _amountController = TextEditingController();

  // Dummy Recharge Plans Data
  final List<Map<String, String>> rechargePlans = [
    {
      'planName': 'Unlimited Calls + 2GB/day',
      'price': '₹199',
      'details': '28 days validity, Unlimited voice calls, 2GB/day data'
    },
    {
      'planName': 'Unlimited Calls + 1.5GB/day',
      'price': '₹249',
      'details': '56 days validity, Unlimited voice calls, 1.5GB/day data'
    },
    {
      'planName': 'Data Only 2GB/day',
      'price': '₹149',
      'details': '28 days validity, Data only'
    },
    {
      'planName': 'Talktime ₹500',
      'price': '₹500',
      'details': 'Full talktime, No data included'
    },
  ];

  // Method to select a plan and clear the text field
  void onPlanSelect(int index) {
    setState(() {
      selectedPlanIndex = index;
      _amountController.clear(); // Clear the amount when a plan is selected
    });
  }

  // Method to handle Recharge action
  void onRechargeNow() {
    String amountToPay;

    // If a plan is selected, use the plan's price; otherwise, use the entered amount
    if (selectedPlanIndex != null) {
      amountToPay = rechargePlans[selectedPlanIndex!]['price']!.replaceAll('₹', '');
    } else if (_amountController.text.isNotEmpty) {
      amountToPay = _amountController.text;
    } else {
      Get.snackbar(
        'Error',
        'Please enter an amount or select a plan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Navigate to PaymentScreen with the final amount
    Get.to(PaymentScreen(price: amountToPay));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select a Recharge Plan',
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
      body: Column(
        children: [
          //------Selected Operator Name-------------//
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 20),
                child: Text(
                  "Operator:  ${widget.optName}",
                  style: const TextStyle(fontSize: 22),
                ),
              )),
          //---------Enter Amount------//
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Center(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter Amount',
                    prefixIcon: Icon(Icons.currency_rupee), // Placeholder text
                    border: InputBorder.none, // Removes the default border
                  ),
                  style: TextStyle(fontSize: 18),
                  controller: _amountController,
                  keyboardType: TextInputType.number, // Adjusts the text style
                  onChanged: (value) {
                    // Clear the selected plan if user enters a custom amount
                    if (value.isNotEmpty) {
                      setState(() {
                        selectedPlanIndex = null;
                      });
                    }
                  },
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Select Plan",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
          // Displaying Recharge Plans
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: rechargePlans.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    onTap: () => onPlanSelect(index),
                    title: Text(
                      '${rechargePlans[index]['planName']} - ${rechargePlans[index]['price']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      rechargePlans[index]['details']!,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    trailing: selectedPlanIndex == index
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : const Icon(Icons.radio_button_unchecked),
                  ),
                );
              },
            ),
          ),
          // Recharge Now Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: onRechargeNow,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.only(left: 50, right: 50),
                child: Text(
                  'Recharge Now',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
