import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:megapay_new/screens/recharge/mobile_recharge_screen.dart';
import 'package:megapay_new/screens/profile/profile_screen.dart';
import 'package:megapay_new/widgets/homeSlider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class HomeScreen extends StatefulWidget {
  

  const HomeScreen({super.key, });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
    String? balance;
    
  onItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (selectedIndex == 3) {
      Get.to(const ProfileScreen());
    }
  }

  //-----------Balance Check--------------//

  final bool _isLoading = true;
  String? _message;

  @override
  void initState() {
    super.initState();
    
    // _Pay1Balance();
  }

  // Future<void> _Pay1Balance() async{
  //   try {
  //     var result = await BalanceCheckService().checkBalance();
  //     print(result["balance"]);
  //     setState(() {
  //       balance = result["balance"];
  //       _isLoading = false;
  //     });
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: "Error Getting Balance");
  //   }
  // }

  // Fetch the balance using the provided API method
  // Future<void> _fetchBalance() async {
  //   try {
      
  //     final balanceData = await ApiService().checkBalance();
  //     setState(() {
  //       // var getBalance = balanceData?['balance'] ?? 'Unavailable';
  //       // double parsedValue = double.parse(getBalance);
  //       // String formattedValue = parsedValue.toStringAsFixed(2);
  //       // balance = formattedValue;
  //       // _message = balanceData?['message'] ?? 'Unavailable'; // Adjust based on API response format
  //       // _isLoading = false;
  //     });
  //     Get.showSnackbar(GetSnackBar(message: _message, duration: const Duration(seconds: 2),));
    
  //   } catch (e) {
  //     setState(() {
  //       balance = 'Error fetching balance';
  //       _isLoading = true;
  //     });
  //     Get.showSnackbar(GetSnackBar(message: balance, duration: const Duration(seconds: 2),));
  //   }
  // }

  //---------Loading-ANim----------//
  final spinkit = SpinKitThreeInOut(
  itemBuilder: (BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.purple : Colors.orange,
          borderRadius: BorderRadius.circular(2)
        ),
      ),
    );
  },
);

void Function()? _comingSoonToast(){
  Fluttertoast.showToast(msg: "Coming Soon..!");
  return null;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // Soft background color
      appBar: AppBar(
        
         automaticallyImplyLeading: false,
        title:  GradientText(
          'Light Speed Pay',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            
          ),
          colors: const [
            Colors.blue,
            Colors.purple,
            Colors.orange
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
           color: Colors.white
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              // Action for notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.qr_code, color: Colors.black),
            onPressed: () {
              // Action for QR code scanner
            },
          ),
        ],
      ),
      body: ListView(
        
        children:  <Widget>[
          
         //-----------Hero-Slider------------//
         const HomeHeroSlider(),
         //-------------------------------------------//
          const Divider(),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(left: 20, bottom: 10),
            child: Text("Bills & Recharges",style: TextStyle(fontSize: 18),),
          ),
          ListTile(
            onTap: () => Get.to(const MobileRechargeScreen(walletBalance: "0")),
            leading: const HugeIcon(icon: HugeIcons.strokeRoundedSmartPhone01, color: Colors.orange),
            title: const Text("Mobile Recharge"),
            subtitle: const Text("Get Best Recharge Plans For Your Mobile."),
            trailing: const HugeIcon(icon: HugeIcons.strokeRoundedArrowRight01, color: Colors.grey),
          ),
          // Services Section with modern, clean service tiles
          // Padding(
          //   padding: const EdgeInsets.all(15.0),
          //   child: GridView.count(
          //     crossAxisCount: 3,
          //     shrinkWrap: true,
          //     physics: const NeverScrollableScrollPhysics(),
          //     childAspectRatio: 1,
          //     mainAxisSpacing: 15,
          //     crossAxisSpacing: 15,
          //     children: [
          //       _buildServiceTile(context, 'Mobile Recharge', Icons.phone_android, Colors.orange, () => Get.to( MobileRechargeScreen( walletBalance: balance ?? ""))),
          //       _buildServiceTile(context, 'TV Recharge', Icons.tv, Colors.blue, _comingSoonToast),
          //       _buildServiceTile(context, 'Internet Services', Icons.wifi, Colors.green, _comingSoonToast),
          //       _buildServiceTile(context, 'Gas Services', Icons.local_fire_department, Colors.red, _comingSoonToast),
          //       _buildServiceTile(context, 'Electricity Bill', Icons.lightbulb_outline, Colors.yellow.shade700, _comingSoonToast),
          //       _buildServiceTile(context, 'Flight Booking', Icons.flight, Colors.purple, _comingSoonToast),
          //     ],
          //   ),
          // ),
        ],
      ),
      bottomNavigationBar: CrystalNavigationBar(
        backgroundColor: const Color.fromARGB(179, 230, 230, 230),
         unselectedItemColor: Colors.black.withOpacity(0.5),
         selectedItemColor: Colors.blue,
         marginR: const EdgeInsets.all(16),
         borderRadius: 12,
        currentIndex: selectedIndex,
        onTap: onItemTap,
        items:  [
          CrystalNavigationBarItem(icon: HugeIcons.strokeRoundedHome02,),
          CrystalNavigationBarItem(icon: HugeIcons.strokeRoundedDashboardSquareSetting,),
          CrystalNavigationBarItem(icon: HugeIcons.strokeRoundedWorkHistory,),
          CrystalNavigationBarItem(icon: HugeIcons.strokeRoundedUser,),
        ],
      ),
    );
  }

  // Helper method to build a clean, flat service tile similar to Bharat BillPay UI
  Widget _buildServiceTile(BuildContext context, String title, IconData icon, Color iconColor, void Function()? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: iconColor.withOpacity(0.2),
              radius: 30,
              child: Icon(icon, color: iconColor, size: 35),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
