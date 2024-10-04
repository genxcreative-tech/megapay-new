import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megapay_new/controllers/api_controller.dart';
import 'package:megapay_new/screens/recharge/detailedPlans.dart';


class RechargePlansScreen extends StatefulWidget {
  final String optName;
  final String opCode;
  final String mobileNumber;
  final String walletBalance;

  const RechargePlansScreen({
    super.key,
    required this.optName,
    required this.walletBalance,
    required this.opCode,
    required this.mobileNumber,
  });

  @override
  _RechargePlansScreenState createState() => _RechargePlansScreenState();
}

class _RechargePlansScreenState extends State<RechargePlansScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? plansData;
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    _fetchPlans();
  }

  Future<void> _fetchPlans() async {
    Map<String, dynamic> data = await PlanService().fetchPlans(widget.mobileNumber, widget.opCode, "MH");
    setState(() {
      plansData = data;
      categories = data.keys.toList();  // The keys from the API response are used as the tab titles.
      _tabController = TabController(length: categories.length, vsync: this);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: Text('${widget.optName} Plans'),
          subtitle: Text('(${widget.mobileNumber})'),
          minLeadingWidth: 0.0,
        ),
        
        bottom: plansData != null && categories.isNotEmpty
            ? TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: categories.map((category) => Tab(text: category)).toList(),
              )
            : null,
      ),
      body: plansData != null && categories.isNotEmpty
          ? TabBarView(
              controller: _tabController,
              children: categories.map((category) {
                List<dynamic> plans = plansData![category];
                return ListView.builder(
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    var plan = plans[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          title: Text("₹${plan['plan_amt']}" ?? 'No Name', style: const TextStyle(fontSize: 24),),
                          subtitle: Text(plan['plan_desc'] ?? 'No Description', maxLines: 3,),
                          onTap: () {
                            Get.to(PlanDetailScreen(plan: plan, opCode: widget.opCode, mobileNumber: widget.mobileNumber,));
                          },
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
