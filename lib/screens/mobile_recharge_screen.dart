import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:hugeicons/hugeicons.dart';
import 'package:megapay_new/screens/payment/payment_screen.dart';
import 'package:megapay_new/screens/select_operator_screen.dart';

import 'recharge_pans_screen.dart';

class MobileRechargeScreen extends StatefulWidget {
  final String walletBalance;
  const MobileRechargeScreen({super.key, required this.walletBalance});

  @override
  State<MobileRechargeScreen> createState() => _MobileRechargeScreenState();
}

class _MobileRechargeScreenState extends State<MobileRechargeScreen> {
  final TextEditingController _mobileController = TextEditingController();
  List<String> _operators = [];
  List<String> _optcodes = [];
  Map<String, String> _operatorMap = {};
  String? _selectedOperator;
  String? _selectedOpCode;
  bool _isLoading = false;
  List<String> rechargeHistory = [];

  @override
  void initState() {
    super.initState();
    _findProvider();
  }

  // Fetching operators and their opCodes
  Future<void> _findProvider() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse('https://api.RechargeExchange.com/API.asmx/OperatorList'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      final List<String> operators = [];
      final Map<String, String> operatorMap = {};

      // Parse the JSON response and store operators and their OpCodes
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
      setState(() {
        _isLoading = false;
      });
    }
  }

  int? selectedPlanIndex;

  void onPlanSelect(int index) {
    setState(() {
      selectedPlanIndex = index;
      _selectedOperator = _operators[index];
       String? opCode = _operatorMap[_selectedOperator];
      _selectedOpCode = opCode;
    });
    print("OPCODE${_selectedOpCode}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Recharge or Pay Mobile Bill',
            style: TextStyle(color: Colors.black, fontSize: 20)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
       physics: BouncingScrollPhysics(),
        child: Padding(
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
                  prefixIcon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedSmartPhone01,
                      color: Colors.grey),
                ),
                maxLength: 10,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
              const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Select Operator:",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )),
              const SizedBox(height: 20),
              // Operators list with their opCodes
              Container(
                height: MediaQuery.of(context).size.height / 1.5,
                child: ListView.builder(
                   
                  itemCount: _operators.length,
                  shrinkWrap: true,
                  
                  itemBuilder: (BuildContext context, int index) {
                    if (_operators.length < 1) {
                      return const Center(
                        child: Text("Loading..."),
                      );
                    } else {
                      String operatorName = _operators[index];
                      String? opCode = _operatorMap[operatorName];

                      return ListTile(
                        onTap: () => onPlanSelect(index),
                        title: Text(
                          operatorName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                       
                        trailing: selectedPlanIndex == index
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : const Icon(Icons.radio_button_unchecked),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: InkWell(
          onTap: () {
            if (_mobileController.text.length < 10 || _selectedOperator == null) {
              Get.showSnackbar(const GetSnackBar(
                messageText: Text(
                  "Please Enter Correct Mobile Number \n or Select Operator To Continue",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
                backgroundColor: Colors.white,
                duration: Duration(seconds: 3),
              ));
            } else {
              Get.to(RechargePlansScreen(
                optName: "$_selectedOperator",
                opCode: "$_selectedOpCode",
                walletBalance: widget.walletBalance,
                mobileNumber: _mobileController.text,
              ));
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
                style: TextStyle(
                    fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
