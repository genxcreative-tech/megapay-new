import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:hugeicons/hugeicons.dart';
import 'package:megapay_new/screens/payment/payment_screen.dart';
import 'package:megapay_new/screens/select_operator_screen.dart';


import 'recharge_pans_screen.dart';

class MobileRechargeScreen extends StatefulWidget {
  const MobileRechargeScreen({super.key});

  @override
  State<MobileRechargeScreen> createState() => _MobileRechargeScreenState();
}

class _MobileRechargeScreenState extends State<MobileRechargeScreen> {
  final TextEditingController _mobileController = TextEditingController();
  List<String> _operators = [];
  Map<String, String> _operatorMap = {};
  String? _selectedOperator;
  bool _isLoading = false;
  List<String> rechargeHistory = [];
  Future<void> _findProvider() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse('https://api.RechargeExchange.com/API.asmx/OperatorList'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      final List<String> operators = [];
      final Map<String, String> operatorMap = {};
      

      // Parse the JSON response
      for (var item in jsonResponse) {
        final operator = item['Operator'];
        final opCode = item['OpCode'];
        operators.add(operator);
        operatorMap[operator] = opCode;
      }

      setState(() {
        _operators = operators;
        _operatorMap = operatorMap;
        _isLoading = false;
      });
    } else {
      // Handle errors
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Recharge or Pay Mobile Bill', style: TextStyle(color: Colors.black, fontSize: 20)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.white
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mobile number input field
            TextField(
              controller: _mobileController,
              decoration: InputDecoration(
                labelText: 'Enter Mobile Number',
                labelStyle: TextStyle(fontSize: 16, color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                
                prefixIcon: const HugeIcon(icon: HugeIcons.strokeRoundedSmartPhone01, color: Colors.grey)
              ),
              maxLength: 10,
              keyboardType: TextInputType.phone,

            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text("My Mobile Number"),
              subtitle: const Text("Recharge or pay bill of your number"),
              trailing: InkWell(
                onTap: () {
                  
                },
                child: const Text("Recharge \n Now", textAlign: TextAlign.center, style: TextStyle(color: Colors.blue),)),
            ),
            const Divider(),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text("My Recharges and Bills"),
            ),
             const SizedBox(height: 120),
            ListView.builder(
              itemCount: 1,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                if (rechargeHistory.length == 0) {
                  return const Center(child: Text("No Recharge or Bill History"),);
                }else{
                  return const Text("data");
                }
                
              },
            ),

            // Find provider button
            // ElevatedButton(
            //   onPressed: _findProvider,
            //   style: ElevatedButton.styleFrom(
            //     padding: const EdgeInsets.symmetric(vertical: 14),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //     backgroundColor: Colors.blue,
            //   ),
            //   child: const Padding(
            //     padding: EdgeInsets.only(left: 10, right: 10),
            //     child: Text('Find Provider', style: TextStyle(fontSize: 18)),
            //   ),
            // ),
            // const SizedBox(height: 16.0),

            // Show loading spinner or operator dropdown
            // if (_isLoading)
            //   const Center(child: CircularProgressIndicator())
            // else if (_operators.isNotEmpty)
            //   DropdownButton<String>(
            //     value: _selectedOperator,
            //     hint: const Text('Select provider'),
            //     onChanged: (String? newValue) {
            //       setState(() {
            //         _selectedOperator = newValue;
            //       });
            //     },
            //     items: _operators.map<DropdownMenuItem<String>>((String value) {
            //       return DropdownMenuItem<String>(
            //         value: value,
            //         child: Text(value),
            //       );
            //     }).toList(),
            //     isExpanded: true,
            //     style: const TextStyle(fontSize: 16, color: Colors.black),
            //     // decoration: BoxDecoration(
            //     //   borderRadius: BorderRadius.circular(12),
            //     //   border: Border.all(color: Colors.grey.shade300),
            //     // ),
            //   )
            // else
            //   const Text(''), // Empty widget placeholder if no operators
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: InkWell(
          onTap: () {
            if (_mobileController.text.length < 10) {
              Get.showSnackbar(const GetSnackBar(messageText: Text("Please Enter Correct Mobile Number To Continue", style: TextStyle(color: Colors.red),), backgroundColor: Colors.white, duration: Duration(seconds: 3),));
            }else{
              Get.to(RechargePlansScreen(optName: "Airtel"));
            }
            
          },
          child: Container(
            height: 60,
            decoration: BoxDecoration(
             color: Colors.orange,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                "Continue",
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
