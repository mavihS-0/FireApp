import 'package:fire_app/Screens/Onboarding/setProfile.dart';
import 'package:fire_app/Screens/splash_screen.dart';
import 'package:fire_app/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: GoogleFonts.roboto().fontFamily,
        colorScheme: ColorScheme.fromSeed(seedColor: Constants.secColor),
        appBarTheme: AppBarTheme(
          backgroundColor: Constants.priColor,
          foregroundColor: Constants.secColor,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          )
        ),
        useMaterial3: true,
      ),
      home: AnimatedSplashScreen(
        duration: 2000,
        nextScreen: const SplashScreen(),
        splash: Image.asset('assets/flash_screen.png'),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
      ),
    );
  }
}

