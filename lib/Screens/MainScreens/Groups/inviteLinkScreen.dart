import 'package:fire_app/Screens/MainScreens/Groups/qrCodeScreen.dart';
import 'package:fire_app/Utils/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//screen to show options for inviting people to group
class InviteLinkScreen extends StatefulWidget {
  const InviteLinkScreen({Key? key}) : super(key: key);

  @override
  State<InviteLinkScreen> createState() => _InviteLinkScreenState();
}

class _InviteLinkScreenState extends State<InviteLinkScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invite link'),
        actions: [
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
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                ListTile(
                    title: RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'People who follow this link can join this group without admin approval. Edit in ',
                                style: TextStyle(
                                    color: Constants.FGcolor.withOpacity(0.42),
                                    fontSize: Constants.smallFontSize
                                )
                            ),
                            TextSpan(
                                text: 'group settings.',
                                style: TextStyle(
                                    color: Constants.priColor,
                                    fontSize: Constants.smallFontSize
                                ),
                                recognizer: TapGestureRecognizer()..onTap = (){
                                  Get.back();
                                }
                            )
                          ]
                      ),
                    )
                ),
                ListTile(
                  leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Constants.priColor
                    ),
                    child: Icon(Icons.link_outlined,color: Constants.secColor),
                  ),
                  title: Text('https://chat.fireappx.com/unfd7hHb98Hbd', style: TextStyle(
                      fontSize: Constants.smallFontSize,
                      color: Constants.FGcolor.withOpacity(0.42)
                  ),),
                  onTap: (){

                  },
                ),
                SizedBox(height: 10,),
                ListTile(
                  leading: Icon(Icons.send,color: Constants.FGcolor,),
                  title: Text('Send link via FireAppX'),
                  onTap: (){

                  },
                ),
                ListTile(
                  leading: Icon(Icons.copy,color: Constants.FGcolor,),
                  title: Text('Copy link'),
                  onTap: (){

                  },
                ),
                ListTile(
                  leading: Icon(Icons.share,color: Constants.FGcolor,),
                  title: Text('Share link'),
                  onTap: (){

                  },
                ),
                ListTile(
                  leading: Icon(Icons.qr_code,color: Constants.FGcolor,),
                  title: Text('QR code'),
                  onTap: (){
                    Get.to(()=>QRCodeScreen());
                  },
                ),
                ListTile(
                  leading: Icon(Icons.remove_circle_outline,color: Constants.FGcolor,),
                  title: Text('Reset link'),
                  onTap: (){

                  },
                )
              ],
            ),
          )
      ),
    );
  }
}


