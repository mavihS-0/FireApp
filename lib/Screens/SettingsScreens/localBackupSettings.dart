import 'package:flutter/material.dart';

import '../../Utils/constants.dart';

class LocalBackupSettings extends StatefulWidget {
  const LocalBackupSettings({Key? key}) : super(key: key);

  @override
  State<LocalBackupSettings> createState() => _LocalBackupSettingsState();
}

class _LocalBackupSettingsState extends State<LocalBackupSettings> {

  String lastBackup = 'August 07,02:13 AM';
  bool includeMediaSwitch = true;
  bool sentMediaItemsCheckbox = false;
  bool receivedMediaItemsCheckbox = false;
  bool voiceNotesCheckbox = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Local Backup'),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            leading: Icon(Icons.backup,color: Colors.black.withOpacity(0.24),),
            title: Text('Last Backup'),
            subtitle: Text(lastBackup,style: TextStyle(
                fontSize: 12,
                color: Colors.black.withOpacity(0.42)
            ),),
          ),
          ListTile(
            title: Text('Include Media Files'),
            trailing: Transform.scale(
              scale: 0.8,
              child: Switch(
                onChanged: (switchState){
                  setState(() {
                    includeMediaSwitch = switchState;
                  });
                },
                value: includeMediaSwitch,
                activeColor: Constants.secColor,
                activeTrackColor: Constants.priColor,
                inactiveThumbColor: Constants.priColor,
                inactiveTrackColor: Constants.secColor,
              ),
            ),
            subtitle: Text('On Android 10 and above, after deleting the app you will lose your media files unless you’ve made a backup',style: TextStyle(
                fontSize: 12,
                color: Colors.black.withOpacity(0.42)
            ),),
          ),
          ListTile(
            leading: Checkbox(
              value: sentMediaItemsCheckbox,
              onChanged: (value){
                setState(() {
                  sentMediaItemsCheckbox = value!;
                });
              },
              activeColor: Constants.priColor,
            ),
            title: Text('Sent Media Items'),
            onTap: (){
              setState(() {
                sentMediaItemsCheckbox = !sentMediaItemsCheckbox;
              });
            },
          ),
          ListTile(
            leading: Checkbox(
              value: receivedMediaItemsCheckbox,
              onChanged: (value){
                setState(() {
                  receivedMediaItemsCheckbox = value!;
                });
              },
              activeColor: Constants.priColor,
            ),
            title: Text('Received Media Items'),
            onTap: (){
              setState(() {
                receivedMediaItemsCheckbox = !receivedMediaItemsCheckbox;
              });
            },
          ),
          ListTile(
            leading: Checkbox(
              value: voiceNotesCheckbox,
              onChanged: (value){
                setState(() {
                  voiceNotesCheckbox = value!;
                });
              },
              activeColor: Constants.priColor,
            ),
            title: Text('Sent & Received Voice Notes'),
            onTap: (){
              setState(() {
                voiceNotesCheckbox = !voiceNotesCheckbox;
              });
            },
          ),
          SizedBox(height: 10,),
          Center(
            child: InkWell(
              child: Container(
                height: 45,
                width: 130,
                decoration: BoxDecoration(
                  color: Constants.priColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(child: Text('BACK UP',style: TextStyle(
                    color: Constants.secColor
                ),)),
              ),
              onTap: (){

              },
            ),
          ),
        ],
      ),
    );
  }
}
