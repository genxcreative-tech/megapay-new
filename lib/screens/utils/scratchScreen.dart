import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:megapay_new/screens/home_screen.dart';
import 'package:scratcher/scratcher.dart';

class ScratchCardScreen extends StatefulWidget {
  const ScratchCardScreen({super.key});

  @override
  State<ScratchCardScreen> createState() => _ScratchCardScreenState();
}

class _ScratchCardScreenState extends State<ScratchCardScreen> {
  late ConfettiController _confettiController;
  double thresholdConf = 30;
  bool isScratchEnd = false;

    @override
  void initState() {
    super.initState();
    // Initialize the confetti controller with a duration
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
   
  }

  @override
  void dispose() {
    _confettiController.dispose();  // Dispose the controller when not in use
    super.dispose();
  }

  void _startConfetti() {
    _confettiController.play();  // Start the confetti animation
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scracth To Win"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Scratcher(
               brushSize: 30,
              threshold: thresholdConf,
              color: Colors.amber,
              onChange: (value){
                
              },
              onThreshold: () => print("Threshold reached, you won!"),
              onScratchEnd: () {
                 _startConfetti();
                 setState(() {
                   isScratchEnd = true;
                 });
              },
              child: Container(
                height: 300,
                width: 300,
                color: Colors.blue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,  // Direction of confetti (all directions)
            shouldLoop: false,  // The animation will not loop
            colors: const [
              Colors.red,
              Colors.blue,
              Colors.green,
              Colors.yellow,
              Colors.orange,
              Colors.purple
            ], // Confetti colors
          ),
                    Image.asset('assets/rupee.png', height: 150,),
                    const SizedBox(height: 10,),
                    const Text("You Won 2 Rupees Cashback!!", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)
                  ],
                ),
              ),),
          ),
          const SizedBox(height: 30,),
          // Proceed to Pay Button
          isScratchEnd? ElevatedButton(
            onPressed: (){
              Get.to(const HomeScreen());
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              '   Click To Continue   ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ) : const SizedBox(),
        ],
      ),
    );
  }
}