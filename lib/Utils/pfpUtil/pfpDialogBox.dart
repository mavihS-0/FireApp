import 'package:flutter/material.dart';
import '../constants.dart';

class PfpDialogBox extends StatelessWidget {
  final dummyData;
  final Function() onInfoButtonPress;
  final Function() onChatButtonPress;
  const PfpDialogBox({Key? key, required this.dummyData, required this.onInfoButtonPress, required this.onChatButtonPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          height: 271,
          width: 250,
          child: Column(
            children: [
              Stack(
                children: [
                  Image.network(dummyData.pfpURL,height: 226,width: 250,fit: BoxFit.fill,),
                  Container(
                    height: 40,
                    width: 250,
                    padding: EdgeInsets.all(10),
                    color: Colors.black.withOpacity(0.44),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(dummyData.name,style: TextStyle(
                          fontSize: 16,
                          color: Constants.secColor
                      ),),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: onInfoButtonPress,
                    child: Container(
                      height: 44,
                      width: 125,
                      decoration: BoxDecoration(
                        color: Constants.priColor,
                        border: Border(
                          right: BorderSide(color: Constants.secColor),
                        ),
                      ),
                      child: Center(
                        child: Icon(Icons.info,color: Constants.secColor,),
                      ),
                    ),
                  ),
                  Divider(color: Colors.white,thickness: 5,),
                  GestureDetector(
                    onTap: onChatButtonPress,
                    child: Container(
                      height: 44,
                      width: 125,
                      decoration: BoxDecoration(
                        color: Constants.priColor,
                        border: Border(
                          left: BorderSide(color: Constants.secColor),
                        ),
                      ),
                      child: Center(
                        child: Icon(Icons.chat,color: Constants.secColor,),
                      ),
                    ),
                  )
                ],
              )
            ],
          )
      ),
    );
  }
}
