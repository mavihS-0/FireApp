import 'package:fire_app/Screens/SettingsScreens/aboutScreen.dart';
import 'package:fire_app/Screens/SettingsScreens/chatSettings.dart';
import 'package:fire_app/Screens/SettingsScreens/notificationSettings.dart';
import 'package:fire_app/Screens/SettingsScreens/privacyPolicy.dart';
import 'package:fire_app/Screens/SettingsScreens/securitySettings.dart';
import 'package:fire_app/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List tileData= [
      {'title' : 'Notifications',
        'leadingIcon' : Icon(Icons.notifications),
        'onPress' : (){
          Get.to(()=>NotificationSettings());
      }
      },
      {'title' : 'Security',
        'leadingIcon' : Icon(Icons.security),
        'onPress' : (){
            Get.to(()=>SecuritySettings());
        }},
      {'title' : 'Chat',
        'leadingIcon' : Icon(Icons.chat),
        'onPress' : (){
            Get.to(()=>ChatSettings());
        }},
      {'title' : 'Privacy Policy',
        'leadingIcon' : Icon(Icons.privacy_tip_sharp),
        'onPress' : (){
            Get.to(()=>PrivacyPolicy());
        }},
      {'title' : 'About',
        'leadingIcon' : Icon(Icons.info),
        'onPress' : (){
            Get.to(()=>AboutScreen());
        }},
      {'title' : 'Delete Account',
        'leadingIcon' : Icon(Icons.notifications),
        'onPress' : (){
            showDialog(
                context: context,
                builder: (context){
                  return AlertDialog(
                    backgroundColor: Constants.secColor,
                    title: Text('Are you sure you want to delete your account',textAlign: TextAlign.center, style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/deleteAcc.png',height: 90,width: 160,),
                        SizedBox(height: 10,),
                        Text('*By deleting your account you will lose access to ALL  Groups and Messages.',textAlign: TextAlign.center, style: TextStyle(
                          color: Color(0xFFC71C1C)
                        ),)
                      ],
                    ),
                    actions: [
                      OutlinedButton(
                        onPressed: (){

                        },
                        child: Text('Delete'),
                        style: ButtonStyle(
                          foregroundColor: MaterialStatePropertyAll<Color?>(Constants.priColor),
                          side: MaterialStatePropertyAll<BorderSide?>(BorderSide(
                            width: 1.0,
                            color: Colors.blue,
                            style: BorderStyle.solid,
                          ),),
                          fixedSize: MaterialStatePropertyAll<Size?>(Size.fromHeight(50)),
                        ),
                      ),
                      SizedBox(width: 10,),
                      FilledButton(
                        onPressed: (){
                          Get.back();
                        },
                        child: Text('Cancel'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color?>(Constants.priColor),
                            fixedSize: MaterialStatePropertyAll<Size?>(Size.fromHeight(50)),
                          ),
                      )
                    ],
                    actionsAlignment: MainAxisAlignment.center,
                  );
                });
        }},
    ];

    return Scaffold(
        backgroundColor: Constants.scaffoldBGColor,
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: tileData.length,
                separatorBuilder: (context,index){
                  return Divider(
                    color: Colors.grey[200],
                    thickness: 2,
                  );
                },
                itemBuilder: (context,index){
                  return ListTile(
                    leading: tileData[index]['leadingIcon'],
                    title: Text(tileData[index]['title'],style: TextStyle(fontWeight: FontWeight.bold),),
                    trailing: Icon(Icons.arrow_forward_ios,size: 18,),
                    onTap: tileData[index]['onPress'],
                  );
                },
              ),
            ),
            SizedBox(height: 10,),
            Text('version${Constants.version}')
          ],
        )
    );
  }
}


