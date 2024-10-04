import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:get/get.dart';
import 'package:megapay_new/screens/auth/phone_auth_screen.dart';




class OnBoarding extends StatelessWidget {
  final Future<void> Function() onOnboardingComplete;
  const OnBoarding(this.onOnboardingComplete, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardingSlider(
        headerBackgroundColor: Colors.white,
        finishButtonText: 'Continue',
        onFinish: ()async{
          await onOnboardingComplete();
          Get.to(const PhoneAuthScreen(), transition: Transition.cupertino);
        },
        finishButtonStyle: const FinishButtonStyle(
          backgroundColor: Colors.black,
        ),
        skipTextButton: const Text('Skip'),
        trailing: const Text('All Set!'),
        centerBackground: true,
        imageVerticalOffset: 100,
        pageBackgroundColor: Colors.white,
        background: const [
           Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: 120,
              backgroundImage: AssetImage('assets/smart-phone-pay.png'),
              
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: 120,
              backgroundImage: AssetImage('assets/cash.png'),
              
            ),
          ),
          
          Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: 120,
              backgroundImage: AssetImage('assets/smart-payment.png'),
              
            ),
          ),
         
          
        ],
        totalPage: 3,
        speed: 1.8,
        pageBodies: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: const Column(
              children: <Widget>[
                SizedBox(
                  height: 480,
                ),
                Text('Welcome To \n Light Speed Pay!', textAlign: TextAlign.center, style: TextStyle(fontSize: 26),),
                SizedBox(height: 10,),
                Text('Send and recieve payments and get your billed paid using our app.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16),),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: const Column(
              children: <Widget>[
                SizedBox(
                  height: 480,
                ),
                Text('Save Your Money And, \n Earn Cashback Rewards!', textAlign: TextAlign.center, style: TextStyle(fontSize: 26),),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: const Column(
              children: <Widget>[
                SizedBox(
                  height: 480,
                ),
                Text('Get Your Bills Paid Fast As, \n Light Speed!', textAlign: TextAlign.center, style: TextStyle(fontSize: 26),),
              ],
            ),
          ),
           
        ],
      ),
    );
  }
}