import 'package:flutter/material.dart';
import 'package:megapay_new/controllers/api_controller.dart';
 // Import the new plan detail screen

class PlanListWidget extends StatefulWidget {
  final String mobileNumber;
  final String operatorCode;

  const PlanListWidget({super.key, required this.mobileNumber, required this.operatorCode});

  @override
  _PlanListWidgetState createState() => _PlanListWidgetState();
}

class _PlanListWidgetState extends State<PlanListWidget> {
  PlanService planService = PlanService();
  List<dynamic> plans = [];

  @override
  void initState() {
    super.initState();
    _fetchPlans();
  }

  Future<void> _fetchPlans() async {
    var result = await planService.fetchPlans(widget.mobileNumber, widget.operatorCode, "MH");

    if (result['status'] == 'success') {
      setState(() {
        plans = result['data']; // Assuming `data` holds the list of plans
      });
    } else {
      print('Error fetching plans: ${result['description']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return plans.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];
              return ListTile(
                title: Text('Plan: ₹${plan['price']}'),
                subtitle: Text(plan['ofrtext'], maxLines: 2, overflow: TextOverflow.ellipsis),
                onTap: () {
                  // Navigate to the plan detail screen when tapped
                  
                },
              );
            },
          );
  }
}
