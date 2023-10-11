import 'package:flutter/material.dart';

import '../constants.dart';
import '../roundedContainer.dart';

class ThemeDataWidget extends StatelessWidget {
  final dummyData;
  final Function() onThemeChange;
  const ThemeDataWidget({Key? key, required this.dummyData, required this.onThemeChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      widget: Row(
        children: [
          ClipOval(
            child: Image.network(dummyData.themeImageUrl,
              height: 50,
              width: 50,
              fit: BoxFit.fill,),
          ),
          SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Theme',style: TextStyle(
                  fontSize: Constants.mediumFontSize,
                  color: Constants.FGcolor
              ),),
              Text(dummyData.theme,style: TextStyle(
                  fontSize: Constants.smallFontSize,
                  color: Constants.FGcolor.withOpacity(0.32)
              ),)
            ],
          ),
          Expanded(child: SizedBox()),
          TextButton(
            onPressed: onThemeChange,
            child: Row(
              children: [
                Icon(Icons.edit, size: 14,color: Constants.priColor,),
                Text(' Change chat theme',style: TextStyle(color: Constants.priColor),)
              ],
            ),
          )
        ],
      ),
    );
  }
}
