import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:megapay_new/screens/recharge_pans_screen.dart';

class SelectRechargeOperator extends StatefulWidget {
  const SelectRechargeOperator({super.key});

  @override
  _SelectRechargeOperatorState createState() => _SelectRechargeOperatorState();
}

class _SelectRechargeOperatorState extends State<SelectRechargeOperator> {
  List<String> _operators = [];
  Map<String, String> _operatorMap = {};
  bool _isLoading = true;
  String? _selectedOperator;

  @override
  void initState() {
    super.initState();
    _fetchOperators();
  }

  // Fetch operators from the API
  Future<void> _fetchOperators() async {
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

  // Handle operator selection
  void _onOperatorSelect(String operator) {
    setState(() {
      _selectedOperator = operator;
    });

    print('Selected Operator: $operator');
    print('Operator Code: ${_operatorMap[operator]}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Recharge Operator'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _operators.isEmpty
              ? const Center(child: Text('No operators available'))
              : ListView.builder(
                  itemCount: _operators.length,
                  itemBuilder: (context, index) {
                    final operator = _operators[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 15, left: 15, bottom: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: ListTile(
                          title: Text(
                            operator,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                          trailing: _selectedOperator == operator
                              ? const Icon(Icons.check_circle, color: Colors.green)
                              : null,
                          onTap: () => _onOperatorSelect(operator),
                        ),
                      ),
                    );
                  },
                ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          onPressed: _selectedOperator != null
              ? () {
                  Get.showSnackbar(GetSnackBar(message: 'Continue with operator: $_selectedOperator and OpCode: ${_operatorMap[_selectedOperator]}', duration: Duration(seconds: 2),));
                  Get.to(RechargePlansScreen(optName: "$_selectedOperator",));
                }
              : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            backgroundColor: _selectedOperator != null ? Colors.blue : Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            
          ),
          child: const Text(
            'Continue',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
