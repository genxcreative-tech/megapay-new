import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://api.RechargeExchange.com/API.asmx";
  final String apiToken = "PiGS3Zg57xF9q52AoTZw";
  final int userId = 12959;

  // 1. Transaction API
  Future<Map<String, dynamic>?> makeTransaction(String opCode, String mobileNo, String amount, String transId) async {
    String url = "$baseUrl/Transaction?userid=$userId&token=$apiToken&opcode=$opCode&number=$mobileNo&amount=$amount&transid=$transId";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to complete transaction');
    }
  }

  // 2. Balance API
  Future<Map<String, dynamic>?> checkBalance() async {
    String url = "https://status.rechargeexchange.com/API.asmx/BalanceNew?userid=$userId&token=$apiToken";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      
      return json.decode(response.body);
      
    } else {
      throw Exception('Failed to fetch balance');
    }
  }

  // 3. Transaction Status API
  Future<Map<String, dynamic>?> checkTransactionStatus(String transId) async {
    String url = "https://status.rechargeexchange.com/API.asmx/TransactionStatus?userid=$userId&token=$apiToken&transid=$transId";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch transaction status');
    }
  }

  // 4. Complaint API
  Future<Map<String, dynamic>?> submitComplaint(String referenceId, String remark) async {
    String url = "$baseUrl/Complain?userid=$userId&token=$apiToken&referenceid=$referenceId&remark=$remark";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to submit complaint');
    }
  }

  // 5. Callback Response (This URL is for receiving, not sending data)
  void handleCallbackResponse(String status, String opid, String clientId, String txnId, String number, String amount, String message) {
    String url = "https://www.yourdomain.com/callback?status=$status&opid=$opid&yourtransid=$clientId&txnid=$txnId&number=$number&amount=$amount&message=$message";
    // This URL is for receiving data, not for sending. No need for implementation unless you're receiving data via this endpoint.
  }

  // 6. Operator Code List API
  Future<List<dynamic>?> fetchOperatorList() async {
    String url = "$baseUrl/OperatorList";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch operator list');
    }
  }
}
