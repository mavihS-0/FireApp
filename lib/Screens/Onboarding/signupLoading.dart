import 'dart:async';
import 'package:fire_app/Screens/MainScreens/homeScreen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SignupLoading extends StatefulWidget {
  const SignupLoading({Key? key}) : super(key: key);

  @override
  State<SignupLoading> createState() => _SignupLoadingState();
}

class _SignupLoadingState extends State<SignupLoading> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Get.off(()=>HomeScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height*0.97,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/signup/loading.png'),
              const Text('Initializing.......',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),)
            ],
          ),
        ),
      ),
    );
  }
}

