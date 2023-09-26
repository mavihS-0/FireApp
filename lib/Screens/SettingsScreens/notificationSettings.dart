import 'package:fire_app/Utils/constants.dart';
import 'package:flutter/material.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({Key? key}) : super(key: key);

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {

  bool newMessageSwitch = true;
  bool vibrateSwitch = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView(
        children: [
          SizedBox(height: 10,),
          ListTile(
            title: Text('New message notifications'),
            trailing: Transform.scale(
              scale: 0.8,
              child: Switch(
                onChanged: (switchState){
                  setState(() {
                    newMessageSwitch = switchState;
                  });
                },
                value: newMessageSwitch,
                activeColor: Constants.secColor,
                activeTrackColor: Constants.priColor,
                inactiveThumbColor: Constants.priColor,
                inactiveTrackColor: Constants.secColor,
              ),
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Ringtone'),
          ),
          Divider(),
          ListTile(
            title: Text('Vibrate'),
            trailing: Transform.scale(
              scale: 0.8,
              child: Switch(
                onChanged: (switchState){
                  setState(() {
                    vibrateSwitch = switchState;
                  });
                },
                value: vibrateSwitch,
                activeColor: Constants.secColor,
                activeTrackColor: Constants.priColor,
                inactiveThumbColor: Constants.priColor,
                inactiveTrackColor: Constants.secColor,
              ),
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Ignore Battery Optimization'),
            subtitle: Text('In order to make sure that all messages are delivered correctly you have to disable Battery Optimizations',style: TextStyle(
              fontSize: 12,
              color: Colors.black.withOpacity(0.42)
            ),),
          )
        ],
      ),
    );
  }
}
