import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megapay_new/screens/mobile_recharge_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              colors: [Colors.blue, Colors.purple],
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
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Action for settings
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            _buildServiceTile(context, 'Mobile Recharge', Icons.phone_android, Colors.orange, () => Get.to(MobileRechargeScreen())),
            _buildServiceTile(context, 'TV Recharge', Icons.tv, Colors.blue, (){}),
            _buildServiceTile(context, 'Internet Services', Icons.wifi, Colors.green, (){}),
            _buildServiceTile(context, 'Gas Services', Icons.local_fire_department, Colors.red, (){}),
            _buildServiceTile(context, 'Electricity Bill', Icons.lightbulb_outline, Colors.yellow.shade700, (){}),
          ],
        ),
      ),
    );
  }

  // Helper method to build a ListTile styled service card
  Widget _buildServiceTile(BuildContext context, String title, IconData icon, Color iconColor, void Function()? onTap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: ListTile(
            subtitle: Text("Tap to continue..."),
            leading: CircleAvatar(
              backgroundColor: iconColor,
              radius: 25,
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
