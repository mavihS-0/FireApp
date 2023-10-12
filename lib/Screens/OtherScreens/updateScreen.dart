import 'package:fire_app/Screens/OtherScreens/fingerprintScreen.dart';
import 'package:fire_app/Utils/constants.dart';
import 'package:fire_app/Utils/customTextButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({Key? key}) : super(key: key);

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {

  bool isCompulsoryUpdate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Time to update!',style: TextStyle(
                      fontSize: Constants.largeFontSize,
                      color: Constants.FGcolor,
                      fontWeight: FontWeight.w500
                    ),),
                    SizedBox(height: 10,),
                    Text('We added lots of new features and fix bugs to make your experience as smooth as possible',style: TextStyle(
                      fontSize: Constants.mediumFontSize,
                      color: Constants.FGcolor,
                        fontWeight: FontWeight.w400
                    ),textAlign: TextAlign.center,),
                    SizedBox(height: 30,),
                    Image.asset('assets/other_pages/update.png')
                  ],
                ),
              ),
              TextButton(onPressed: (){
                Get.to(()=>FingerprintScreen());
              }, child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Constants.priColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(child: Text('UPDATE',style: TextStyle(
                    color: Constants.secColor
                ),)),
              )),
              isCompulsoryUpdate? SizedBox():
              TextButton(onPressed: (){
                Get.back();
              }, child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Constants.secColor,
                  borderRadius: BorderRadius.circular(30),
                  border: Border(
                    top: BorderSide(color: Constants.priColor),
                    bottom: BorderSide(color: Constants.priColor),
                    left: BorderSide(color: Constants.priColor),
                    right: BorderSide(color: Constants.priColor)
                  )
                ),
                child: Center(child: Text('NOT NOW',style: TextStyle(
                    color: Constants.priColor
                ),)),
              )),
              SizedBox(height: 10,)
            ],
          ),
        ),
      ),
    );
  }
}
