import 'package:fire_app/Screens/SettingsScreens/localBackupSettings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Utils/constants.dart';

class ChatSettings extends StatefulWidget {
  const ChatSettings({Key? key}) : super(key: key);

  @override
  State<ChatSettings> createState() => _ChatSettingsState();
}

class _ChatSettingsState extends State<ChatSettings> {

  bool enterToSendSwitch = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(left: 15,right: 15,top: 10),
            child: Text('Chat settings',style: TextStyle(
              color: Constants.priColor,
              fontWeight: FontWeight.bold,
              fontSize: 14
            ),),
          ),
          ListTile(
            title: Text('Enter key will send your message'),
            trailing: Transform.scale(
              scale: 0.8,
              child: Switch(
                onChanged: (switchState){
                  setState(() {
                    enterToSendSwitch = switchState;
                  });
                },
                value: enterToSendSwitch,
                activeColor: Constants.secColor,
                activeTrackColor: Constants.priColor,
                inactiveThumbColor: Constants.priColor,
                inactiveTrackColor: Constants.secColor,
              ),
            ),
            subtitle: Text('Enter is send',style: TextStyle(
                fontSize: 12,
                color: Colors.black.withOpacity(0.42)
            ),),
          ),
          ListTile(
            title: Text('Chat backup'),
            onTap: (){
              Get.to(()=>LocalBackupSettings());
            },
          ),
          Container(
            padding: EdgeInsets.only(left: 15,right: 15,top: 5, bottom: 5),
            child: Text('Media auto download',style: TextStyle(
                color: Constants.priColor,
                fontWeight: FontWeight.bold,
                fontSize: 14
            ),),
          ),
          ListTile(
            title: Text('When using mobile data'),
            subtitle: Text('Photos',style: TextStyle(
                fontSize: 12,
                color: Colors.black.withOpacity(0.42)
            ),),
          ),
          ListTile(
            title: Text('When roaming'),
            subtitle: Text('no media',style: TextStyle(
                fontSize: 12,
                color: Colors.black.withOpacity(0.42)
            ),),
          ),
          ListTile(
            title: Text('When using Wifi'),
            subtitle: Text('Photos, Audio, Videos',style: TextStyle(
                fontSize: 12,
                color: Colors.black.withOpacity(0.42)
            ),),
          )
        ],
      )
    );
  }
}
