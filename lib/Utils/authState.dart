import 'package:fire_app/Screens/MainScreens/homeScreen.dart';
import 'package:fire_app/Screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

//helper class to check if user is logged in or not
class AuthState extends StatelessWidget {
  const AuthState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return HomeScreen();
          }
          else{
            return SplashScreen();
          }
        },
      ),
    );
  }
}
