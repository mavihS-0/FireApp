import 'package:fire_app/Screens/MainScreens/homeScreen.dart';
import 'package:fire_app/Screens/Onboarding/setProfile.dart';
import 'package:fire_app/Screens/Onboarding/signup.dart';
import 'package:fire_app/Utils/customButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:get/get.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

  String code="";
  String verify = SignUp.verify;

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
                Text('OTP has been sent to ${Get.arguments['phone']}',textAlign: TextAlign.center,),
                const SizedBox(height: 30,),
                OTPTextField(
                    length: 6,
                    width: MediaQuery.of(context).size.width,
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldWidth: 45,
                    outlineBorderRadius: 15,
                    style: const TextStyle(fontSize: 17),
                    onChanged: (pin) {
                      code=pin;
                    },
                    onCompleted: (pin) {
                      print("Completed: " + pin);
                    }),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Didn't receive OTP?"),
                    TextButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context)=> const Center(child: CircularProgressIndicator()),
                        );
                        try{
                          await FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: Get.arguments['phone'],
                            verificationCompleted: (PhoneAuthCredential credential) {},
                            verificationFailed: (FirebaseAuthException e) {},
                            codeSent: (String verificationId, int? resendToken) {
                              verify=verificationId;
                              Get.snackbar('Code Resent', 'New OTP has been sent');
                            },
                            codeAutoRetrievalTimeout: (String verificationId) {},
                          );
                        }
                        catch(e){
                          Get.snackbar('Error', e.toString());
                        }
                        Get.back();
                      },
                      child: const Text('Resend OTP'),
                    )
                  ],
                ),
                CustomTextButton(title: 'VERIFY', onPress: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context)=> const Center(child: CircularProgressIndicator()),
                  );
                  try{
                    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verify, smsCode: code);
                    final userCredential = await SignUp.auth.signInWithCredential(credential);
                    userCredential.additionalUserInfo?.isNewUser == true ? Get.off(()=>const SetProfileName()):
                    Get.offAll(()=>HomeScreen());
                  }
                  catch(e){
                    Get.back();
                    Get.snackbar('Wrong OTP', 'The OTP you have entered is incorrect');
                  }
                })
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
