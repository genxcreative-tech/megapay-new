import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      // You can show an error message or handle the error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Recharge'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _mobileController,
              decoration: const InputDecoration(
                labelText: 'Enter Mobile Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _findProvider,
              child: const Text('Find Provider'),
            ),
            const SizedBox(height: 16.0),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_operators.isNotEmpty)
              DropdownButton<String>(
                value: _selectedOperator,
                hint: const Text('Select provider'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedOperator = newValue;
                  });
                },
                items: _operators.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )
            else
              const Text(''),
          ],
        ),
      ),
    );
  }
}
