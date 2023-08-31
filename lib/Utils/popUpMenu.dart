import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget customPopUpMenu() {
  return PopupMenuButton(
//TODO: Popup menu
      onSelected: (value){
        if(value == 'Log Out'){
          FirebaseAuth.instance.signOut();
        }
      },
      itemBuilder: (context){
        return {'New Group','Profile', 'Settings','Log Out'}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      });
}