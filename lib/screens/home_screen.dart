import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:megapay_new/controllers/api_controller.dart';
import 'package:megapay_new/screens/mobile_recharge_screen.dart';
import 'package:megapay_new/screens/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
   final String? userId;
  final String? token;

  const HomeScreen({Key? key,  this.userId,  this.token}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  onItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (selectedIndex == 3) {
      Get.to(ProfileScreen());
    }
  }

  //-----------Balance Check--------------//
   String? _balance;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBalance();
  }

  // Fetch the balance using the provided API method
  Future<void> _fetchBalance() async {
    try {
      final balanceData = await ApiService().checkBalance(widget.userId ?? "", widget.token ?? "");
      setState(() {
        _balance = balanceData?['balance'] ?? 'Unavailable'; // Adjust based on API response format
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _balance = 'Error fetching balance';
        _isLoading = true;
      });
      Get.showSnackbar(GetSnackBar(message: _balance, duration: Duration(seconds: 2),));
    }
  }

  //---------Loading-ANim----------//
  final spinkit = SpinKitThreeInOut(
  itemBuilder: (BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.indigo : Colors.white,
          borderRadius: BorderRadius.circular(2)
        ),
      ),
    );
  },
);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],  // Soft background color
      appBar: AppBar(
         automaticallyImplyLeading: false,
        title: const Text(
          'Mega Pay',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Action for notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.qr_code, color: Colors.white),
            onPressed: () {
              // Action for QR code scanner
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          // Balance Section with cleaner design
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.indigo],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    Text(
                      "Wallet Balance",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                   _isLoading
            ? spinkit // Show a loading indicator while fetching balance
            : Text(
                'Balance: $_balance',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
      
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Action for adding money
                  },
                  icon: const Icon(Icons.add, size: 24),
                  label: const Text("Add Money"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Services Section with modern, clean service tiles
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: [
                _buildServiceTile(context, 'Mobile Recharge', Icons.phone_android, Colors.orange, () => Get.to(const MobileRechargeScreen())),
                _buildServiceTile(context, 'TV Recharge', Icons.tv, Colors.blue, () {}),
                _buildServiceTile(context, 'Internet Services', Icons.wifi, Colors.green, () {}),
                _buildServiceTile(context, 'Gas Services', Icons.local_fire_department, Colors.red, () {}),
                _buildServiceTile(context, 'Electricity Bill', Icons.lightbulb_outline, Colors.yellow.shade700, () {}),
                _buildServiceTile(context, 'Flight Booking', Icons.flight, Colors.purple, () {}),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: Colors.blue,
        
        selectedIndex: selectedIndex,
        onDestinationSelected: onItemTap,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.dashboard), label: "Dashboard"),
          NavigationDestination(icon: Icon(Icons.history), label: "History"),
          NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
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
