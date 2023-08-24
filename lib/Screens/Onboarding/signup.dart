import 'package:fire_app/Screens/Onboarding/otp.dart';
import 'package:fire_app/Utils/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:get/get.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  String _countryCode = '+91';

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
                Image.asset('assets/signup/number.png',scale: 1.3,),
                const Text("Enter your mobile number",style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                  textAlign: TextAlign.center,),
                const SizedBox(height: 10,),
                const Text('Please confirm your country code and verify your mobile number',textAlign: TextAlign.center,),
                const SizedBox(height: 30,),
                Row(
                  children: [
                    Column(
                      children: [
                        const Text('Country code'),
                        CountryCodePicker(
                          initialSelection: '+91',
                          boxDecoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10)
                          ),
                          showDropDownButton: true,
                          onChanged: (CountryCode code){
                            _countryCode = code.toString();
                          },
                        ),
                      ],
                    ),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                      ),
                    )
                  ],
                ),
                CustomTextButton(title: 'VERIFY', onPress: (){Get.to(()=>OTPScreen());})
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
