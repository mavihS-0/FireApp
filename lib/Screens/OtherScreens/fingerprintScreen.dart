import 'package:fire_app/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class FingerprintScreen extends StatefulWidget {
  const FingerprintScreen({Key? key}) : super(key: key);

  @override
  State<FingerprintScreen> createState() => _FingerprintScreenState();
}

class _FingerprintScreenState extends State<FingerprintScreen> {

  final LocalAuthentication auth = LocalAuthentication();
  List<BiometricType> _availableBiometric = [];
  bool _canCheckBiometric = false;

  Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;

    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;
    setState(() {
      _canCheckBiometric = canCheckBiometric;
    }
    );
  }

  Future _getAvailableBiometric() async {
    List<BiometricType> availableBiometric = [];

    try {
      availableBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    setState(() {
      _availableBiometric = availableBiometric;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
          localizedReason: "Scan your finger to authenticate",);
    } on PlatformException catch (e) {
      print(e);
    }
    setState(() {
      var authorized = authenticated ? "Authorized success" : "Failed to authenticate";
      print(authorized);
    });
  }

  @override
  void initState() {
    _checkBiometric();
    _getAvailableBiometric();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              flex: 3,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(75.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(child: Icon(Icons.lock,color: Constants.FGcolor.withOpacity(0.42),),onTap: _authenticate,),
                      SizedBox(height: 10,),
                      Text('Locked',style: TextStyle(
                        fontSize: Constants.largeFontSize,
                        color: Constants.FGcolor
                      ),),
                      SizedBox(height: 30,),
                      Image.asset('assets/other_pages/fingerprint.png')
                    ],
                  ),
                ),
              )
            ),
            Flexible(
              flex: 1, child: SizedBox(),
            )
          ],
        ),
      ),
    );
  }
}
