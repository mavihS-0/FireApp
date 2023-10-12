import 'package:fire_app/Screens/MainScreens/ProfileScreens/myProfileScreen.dart';
import 'package:fire_app/Screens/OtherScreens/updateScreen.dart';
import 'package:fire_app/Screens/SettingsScreens/settingsScreen.dart';
import 'package:fire_app/Screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Screens/MainScreens/PersonalChats/addContact.dart';
import '../Screens/MainScreens/test.dart';

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
        else if(value == 'Settings'){
          Get.to(()=>SettingsScreen());
        }
        else if(value == 'Profile'){
          Get.to(()=>ProfileScreen());
        }
        else if(value == 'New group'){
          Get.to(()=>UpdateScreen());
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