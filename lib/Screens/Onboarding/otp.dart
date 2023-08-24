import 'package:fire_app/Screens/Onboarding/setProfile.dart';
import 'package:fire_app/Utils/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:get/get.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20,),
                Image.asset('assets/signup/otp.png',scale: 1.3,),
                const Text("OTP Verification",style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                  textAlign: TextAlign.center,),
                const SizedBox(height: 10,),
                const Text('OTP has been sent to +919311246655',textAlign: TextAlign.center,),
                const SizedBox(height: 30,),
                OTPTextField(
                    length: 6,
                    width: MediaQuery.of(context).size.width,
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldWidth: 45,
                    outlineBorderRadius: 15,
                    style: TextStyle(fontSize: 17),
                    onChanged: (pin) {
                      print("Changed: " + pin);
                    },
                    onCompleted: (pin) {
                      print("Completed: " + pin);
                    }),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Didn't receive OTP?"),
                    TextButton(
                      onPressed: (){},
                      child: const Text('Resend OTP'),
                    )
                  ],
                ),
                CustomTextButton(title: 'VERIFY', onPress: (){Get.to(()=>SetProfileName());})
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
