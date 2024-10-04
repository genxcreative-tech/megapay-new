import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megapay_new/screens/payment/payment_screen.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class PlanDetailScreen extends StatelessWidget {
  final Map<String, dynamic> plan;
  String? opCode;
  String? mobileNumber;
  PlanDetailScreen({super.key, required this.plan, required this.opCode, required mobileNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(plan['name'] ?? 'Plan Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(label: Text("Plan Amount: ₹${plan['plan_amt']}" ?? 'No Name', style: const TextStyle(fontSize: 24),)),
            const SizedBox(height: 10),
           
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Chip(label: Text("Plan Description: ", textAlign: TextAlign.start, style: TextStyle(fontSize: 18),)),
                    const SizedBox(height: 10,),
                    Text(
                      '${plan['plan_desc'] ?? 'N/A'}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Chip(
                  label: Text(
                    'Data: ${plan['data'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  backgroundColor: Colors.blue.shade100,
                ),
                
                Chip(
                  label: Text(
                    'Validity: ${plan['plan_validity'] ?? 'N/A'} Days',
                    style: const TextStyle(fontSize: 16),
                  ),
                  backgroundColor: Colors.orange.shade100,
                ),
              ],
            ),
            const SizedBox(height: 20),
           
          ],
        ),
      ),
      bottomNavigationBar:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Colors.orange,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: (){
          Get.to(PaymentScreen(price: plan['plan_amt'], walletBalance: "", opCode: opCode ?? "", mobileNumber: mobileNumber ?? ""));
        },
        child: GradientText(
            'Recharge Now',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              
            ),
            colors: const [
              Colors.black,
              Colors.black,
              Colors.black
            ],
          ),
            ),
      ),
    );
  }
}
