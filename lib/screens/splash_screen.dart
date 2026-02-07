import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding_screen.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), (){
      Get.off(()=>OnboardingScreen());
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff1253AA), Color(0xff05243E)],
          ),
        ),
        child: Center(
            child:
        Column(
          children: [
            Spacer(flex: 2),
            Image.asset('assets/Checkmark-1.png',height: 120,),
            SizedBox(height: 20),
            Text("DO IT",style: TextStyle(fontWeight: FontWeight.w900,letterSpacing:2,fontSize: 25,color: Colors.white),),
            Spacer(flex: 3),
            Text("v 1.0.0",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white)),
            SizedBox(height: 20),
          ],
        )),
      ),
    );
  }
}
