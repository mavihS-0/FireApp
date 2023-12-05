import 'package:fire_app/Utils/authState.dart';
import 'package:fire_app/Utils/constants.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
// import 'package:animated_splash_screen/animated_splash_screen.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
// import 'package:permission_handler/permission_handler.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );
  FirebaseDatabase database = FirebaseDatabase.instance;
  // enabling data persistence
  database.setPersistenceEnabled(true);
  database.setPersistenceCacheSizeBytes(10000000);

  //creating hive db
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox('imageData');

  // creating directories to store media locally (using hive db reference)
  // await createFolder('Media');
  // await createFolder('Media/profileIcons');
  // await createFolder('Media/images');
  await createDB();
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
        //fontFamily: GoogleFonts.roboto().fontFamily,
        colorScheme: ColorScheme.fromSeed(seedColor: Constants.secColor),
        appBarTheme: AppBarTheme(
          backgroundColor: Constants.priColor,
          foregroundColor: Constants.secColor,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
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
        dialogBackgroundColor: Constants.secColor,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 16,
          )
        )
      ),
      home: const AuthState(),

      // splash screen (currently not used)
      // home: AnimatedSplashScreen(
      //   duration: 2000,
      //   nextScreen: const AuthState(),
      //   splash: Image.asset('assets/flash_screen.png'),
      //   splashTransition: SplashTransition.fadeTransition,
      //   pageTransitionType: PageTransitionType.fade,
      // ),and
    );
  }
}

// function to create folders to store media locally
// Future<void> createFolder(String cow) async {
//   final dir = Directory((await getApplicationDocumentsDirectory()).path + '/$cow');
//   if ((await dir.exists())) {
//   } else {
//     var status = await Permission.storage.status;
//     if (!status.isGranted) {
//       await Permission.storage.request();
//     }
//     dir.create();
//   }
// }

// function to create hive db
Future <void> createDB() async{
  var box = Hive.box('imageData');
  if(box.get('indices')==null){
    await box.put('indices',{
      //'profileIconCounter' : 0,
      //'chatImageCounter' : 0,
      'audioRecordingsCounter' : 0
    });
  }
  // if(box.get('chats')==null){
  //   await box.put('chats',{
  //     'images': {
  //       '':''
  //     }
  //   });
  // }
  // if(box.get('profileIcons')==null){
  //   await box.put('profileIcons',{
  //     '' :{
  //       'local' : '',
  //       'web' : '',
  //     }
  //   });
  // }
}