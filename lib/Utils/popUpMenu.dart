import 'package:fire_app/Screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Screens/MainScreens/addContact.dart';

Widget customPopUpMenu(String addNew, Function addNewMethod) {
  return PopupMenuButton(
//TODO: Popup menu
      onSelected: (value)async{
        if(value == 'Log Out') {
          await FirebaseAuth.instance.signOut();
          Get.offAll(()=>SplashScreen());
        }
        else if(value == 'New chat'){
          Get.to(()=>AddContact());
        }
      },
      itemBuilder: (context){
        return {addNew,'Profile', 'Settings','Log Out'}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      });
}