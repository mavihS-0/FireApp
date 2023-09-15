import 'package:flutter/material.dart';

Widget CustomAttachButton(Function() onPress,IconData buttonIcon,Color buttonColor){
  return InkWell(
    onTap: onPress,
    child: CircleAvatar(
      radius: 30,
      backgroundColor: buttonColor,
      child: Icon(
        buttonIcon,
        color: Colors.white,
      ),
    ),
  );
}