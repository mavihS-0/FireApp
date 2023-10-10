import 'package:flutter/material.dart';

import 'constants.dart';

class RoundedContainer extends StatelessWidget {
  final Widget widget;
  const RoundedContainer({Key? key, required this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10,left: 10,right: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Constants.secColor,
          borderRadius: BorderRadius.circular(10)
      ),
      child: widget,
    );
  }
}
