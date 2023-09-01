import 'package:fire_app/Utils/authState.dart';
import 'package:fire_app/Utils/constants.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );
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
          titleTextStyle: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          )
        ),
        tabBarTheme: TabBarTheme(
          indicatorColor: Constants.priColor2,
          labelColor: Constants.priColor,
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: const TextStyle(
              fontWeight: FontWeight.bold
          ),
          unselectedLabelColor: Constants.priColor,
          unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Constants.priColor,
          foregroundColor: Constants.secColor,
        ),
        useMaterial3: true,
      ),
      home: AnimatedSplashScreen(
        duration: 2000,
        nextScreen: const AuthState(),
        splash: Image.asset('assets/flash_screen.png'),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
      ),
    );
  }
}

