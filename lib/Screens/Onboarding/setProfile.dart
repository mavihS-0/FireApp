import 'package:fire_app/Screens/Onboarding/signupLoading.dart';
import 'package:fire_app/Utils/constants.dart';
import 'package:fire_app/Utils/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetProfileName extends StatefulWidget {
  const SetProfileName({Key? key}) : super(key: key);

  @override
  State<SetProfileName> createState() => _SetProfileNameState();
}

class _SetProfileNameState extends State<SetProfileName> {

  String _imageURL = '';
  Image _image = Image.asset('assets/signup/profile.png');
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height*0.97,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 70,),
                Center(
                    child: Container(
                      height: 60,
                      width: 60,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage: _image.image,
                            radius: 30,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                              child: CircleAvatar(
                                  radius: 11,
                                  backgroundColor: Constants.priColor,
                                  child: const Icon(Icons.add,color: Colors.white,size: 20,)),
                              onTap: (){},
                            ),
                          )
                        ],
                      ),
                    )
                ),
                const SizedBox(height: 50,),
                const Text('Profile Name', style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                ), textAlign: TextAlign.left,),
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Enter your name',
                      hintStyle: TextStyle(
                        fontSize: 14,
                      )
                  ),
                  controller: _nameController,
                ),
                const SizedBox(height: 50,),
                Expanded(child: Container()),
                CustomTextButton(title: 'CONTINUE', onPress: (){
                  Get.to(()=>SignupLoading(),arguments: {
                    'name': _nameController.text
                  });
                })
              ],
            )
        ),
      ),
    );
  }
}
