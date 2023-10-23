import 'package:fire_app/Utils/constants.dart';
import 'package:flutter/material.dart';

//screen to show QR code of group
class QRCodeScreen extends StatelessWidget {
  const QRCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR code"),
        actions: [
          IconButton(
            onPressed: (){

            },
            icon: Icon(Icons.share),
          ),
          PopupMenuButton(
            itemBuilder: (context){
              return {'Option 1','Option 2'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            onSelected: (value){

            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network('https://cdn.discordapp.com/attachments/1003549667054862438/1161628097746059294/image.png?ex=6538fd78&is=65268878&hm=27f3f8e5825e73cdaaf3d1182d99e9e9e0b6873e4c331199a7c4c604daceca9f&',
            height: 195,
            width: 195,
            fit: BoxFit.fill),
            SizedBox(height: 40,),
            SizedBox(
              width: 260,
              child: Text('This group QR code is private. If it is shared with someone, they can scan it with their FireAppX camera to join this group.',style: TextStyle(
                fontSize: Constants.smallFontSize,
                color: Constants.FGcolor.withOpacity(0.42),
              ), textAlign: TextAlign.center,),
            )
          ],
        ),
      ),
    );
  }
}
