import 'package:flutter/material.dart';
import '../constants.dart';

class CustomSwitch extends StatelessWidget {
  final String title;
  final Function(bool) onChanged;
  final bool value;
  const CustomSwitch({Key? key, required this.title, required this.onChanged, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Transform.scale(
          scale: 0.8,
          child: Switch(
            onChanged: onChanged,
            value: value,
            activeColor: Constants.secColor,
            activeTrackColor: Constants.priColor,
            inactiveThumbColor: Constants.priColor,
            inactiveTrackColor: Constants.secColor,
          ),
        ),
      ],
    );
  }
}
