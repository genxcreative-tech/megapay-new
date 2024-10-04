import 'dart:convert';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

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



//------Pay1-API---------------//



class MnpApiService {
  final String partnerId = 'P0232044';
  final String apiKey = 'nV4G@v2!24&';
  final String baseUrl = 'https://recharges.pay1.in/apis/mnpCheck';

  /// Generate a random transaction ID
  String generateRandomNumber() {
    final random = Random();
    return (10000 + random.nextInt(90000)).toString(); // Generates a 5-digit random number
  }

  /// Generate SHA1 hash for the API request
  String generateHash(String partnerId, String transId, String apiKey) {
    final bytes = utf8.encode(partnerId + transId + apiKey);
    return sha1.convert(bytes).toString();
  }

  /// API request to check MNP mobile number
  Future<Map<String, dynamic>> checkMnpNumber(String mobileNumber) async {
    try {
      final transId = generateRandomNumber();
      final hashCode = generateHash(partnerId, transId, apiKey);

      final url = Uri.parse(
          '$baseUrl?partner_id=$partnerId&trans_id=$transId&mobile=$mobileNumber&hash_code=$hashCode');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        
        print(response.body);
        return json.decode(response.body);
      } else {
        throw Exception('Failed to check mobile number');
      }
    } catch (error) {
      print('Error occurred: $error');
      return {'status': 'failure', 'description': error.toString()};
    }
  }



}

class BalanceCheckService {
  final String partnerId = 'P0232044';
  final String apiKey = 'nV4G@v2!24&';
  final String baseUrl = 'https://recharges.pay1.in/apis/receiveApi';

  /// Generate a random transaction ID
  String generateRandomNumber() {
    final random = Random();
    return (10000 + random.nextInt(90000)).toString(); // Generates a 5-digit random number
  }

  /// Generate SHA1 hash for the API request
  String generateHash(String partnerId, String transId, String apiKey) {
    final bytes = utf8.encode(partnerId + transId + apiKey);
    return sha1.convert(bytes).toString();
  }

  /// API request to check balance
  Future<Map<String, dynamic>> checkBalance() async {
    try {
      final transId = generateRandomNumber();
      final hashCode = generateHash(partnerId, transId, apiKey);

      final url = Uri.parse(
          '$baseUrl?partner_id=$partnerId&operation_type=2&trans_id=$transId&hash_code=$hashCode');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to check balance');
      }
    } catch (error) {
      print('Error occurred: $error');
      return {'status': 'failure', 'description': error.toString()};
    }
  }
}

//---------Recharge-Service-API_-------//

class RechargeService {
  final String partnerId = 'P0232044';
  final String apiKey = 'nV4G@v2!24&';
  final String baseUrl = 'https://recharges.pay1.in/apis/receiveApi';

  /// Generate a random transaction ID
  String generateRandomNumber() {
    final random = Random();
    return (10000 + random.nextInt(90000)).toString(); // Generates a 5-digit random number
  }

  /// Generate SHA1 hash for the API request
  String generateHash(String partnerId, String transId, String apiKey) {
    final bytes = utf8.encode(partnerId + transId + apiKey);
    return sha1.convert(bytes).toString();
  }

  /// Validate the recharge request
  Future<Map<String, dynamic>> validateRecharge(String mobileNumber, String operatorCode, double amount) async {
    try {
      final transId = generateRandomNumber();
      final hashCode = generateHash(partnerId, transId, apiKey);

      final url = Uri.parse(
          '$baseUrl?partner_id=$partnerId&operation_type=10&operator=$operatorCode&number=$mobileNumber&amount=$amount&trans_id=$transId&hash_code=$hashCode');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        
        return json.decode(response.body);
      } else {
        throw Exception('Failed to validate recharge');
      }
    } catch (error) {
      print('Error occurred during validation: $error');
      return {'status': 'failure', 'description': error.toString()};
    }
  }

  /// Complete the recharge
  Future<Map<String, dynamic>> completeRecharge(String mobileNumber, String operatorCode, double amount) async {
    try {
      final transId = generateRandomNumber();
      final hashCode = generateHash(partnerId, transId, apiKey);

      final url = Uri.parse(
          '$baseUrl?partner_id=$partnerId&operation_type=1&operator=$operatorCode&number=$mobileNumber&amount=$amount&trans_id=$transId&special=0&hash_code=$hashCode');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to complete recharge');
      }
    } catch (error) {
      print('Error occurred during recharge: $error');
      return {'status': 'failure', 'description': error.toString()};
    }
  }
}


//-------------Mobile-Recharge-Plans--------------//





class PlanService {
  final String partnerId = 'P0232044';
  final String apiKey = 'nV4G@v2!24&';
  final String baseUrl = 'https://recharges.pay1.in/apis/oprPlansApi';

  // Generate a random transaction ID
  String generateRandomNumber() {
    final random = Random();
    return (10000 + random.nextInt(90000)).toString(); // Generates a 5-digit random number
  }

  // Generate SHA1 hash for the API request
  String generateHash(String partnerId, String transId, String apiKey) {
    final bytes = utf8.encode(partnerId + transId + apiKey);
    return sha1.convert(bytes).toString();
  }

  // API request to fetch plans
  Future<Map<String, dynamic>> fetchPlans(String mobileNumber, String operatorCode, String circle) async {
  try {
    final transId = generateRandomNumber();
    final hashCode = generateHash(partnerId, transId, apiKey);

    final url = Uri.parse('$baseUrl?partner_id=$partnerId&trans_id=$transId&operator=$operatorCode&circle=$circle&hash_code=$hashCode');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedJson = jsonDecode(response.body);
      if (decodedJson['status'] == 'success') {
        Map<String, dynamic> data = decodedJson['data'];
        return data;
      } else {
        Fluttertoast.showToast(msg: "Failed to fetch plans: ${decodedJson['message']}");
        return {};
      }
    } else {
      throw Exception('Failed to fetch plans. Status Code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error occurred: $error');
    return {};
  }
}



}



