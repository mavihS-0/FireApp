import 'package:fire_app/Utils/constants.dart';
import 'package:flutter/material.dart';

//text buttons used in splash screens
class CustomTextButton extends StatelessWidget {
  final Function() onPress;
  final String title;
  const CustomTextButton({Key? key,required this.title, required this.onPress,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextButton(onPressed: onPress, child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Constants.priColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(child: Text(title,style: TextStyle(
            color: Constants.secColor
        ),)),
      )),
    );
  }
}
