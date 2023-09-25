import 'package:fire_app/Screens/SettingsScreens/notificationSettings.dart';
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
        'onPress' : (){}},
      {'title' : 'Chat',
        'leadingIcon' : Icon(Icons.chat),
        'onPress' : (){}},
      {'title' : 'Privacy Policy',
        'leadingIcon' : Icon(Icons.privacy_tip_sharp),
        'onPress' : (){}},
      {'title' : 'About',
        'leadingIcon' : Icon(Icons.info),
        'onPress' : (){}},
      {'title' : 'Delete Account',
        'leadingIcon' : Icon(Icons.notifications),
        'onPress' : (){}},
    ];

    return Scaffold(
        backgroundColor: Colors.grey[200],
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
            Text('version1.0')
          ],
        )
    );
  }
}


