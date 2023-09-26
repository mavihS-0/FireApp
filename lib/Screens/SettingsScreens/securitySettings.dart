import 'package:flutter/material.dart';

import '../../Utils/constants.dart';

class SecuritySettings extends StatefulWidget {
  const SecuritySettings({Key? key}) : super(key: key);

  @override
  State<SecuritySettings> createState() => _SecuritySettingsState();
}

class _SecuritySettingsState extends State<SecuritySettings> {

  bool unlockWithFingerprintSwitch = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Security'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        child: ListTile(
          title: Text('Unlock with Fingerprint'),
          trailing: Transform.scale(
            scale: 0.8,
            child: Switch(
              onChanged: (switchState){
                setState(() {
                  unlockWithFingerprintSwitch = switchState;
                });
              },
              value: unlockWithFingerprintSwitch,
              activeColor: Constants.secColor,
              activeTrackColor: Constants.priColor,
              inactiveThumbColor: Constants.priColor,
              inactiveTrackColor: Constants.secColor,
            ),
          ),
          subtitle: Text('When enabled, you will need to use your fingerprint to open the app',style: TextStyle(
              fontSize: 12,
              color: Colors.black.withOpacity(0.42)
          ),),
        ),
      ),
    );
  }
}
