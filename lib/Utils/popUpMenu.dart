import 'package:flutter/material.dart';

Widget customPopUpMenu() {
  return PopupMenuButton(
//TODO: Popup menu
      onSelected: (value){
        print(value);
      },
      itemBuilder: (context){
        return {'New Group','Profile', 'Settings'}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      });
}