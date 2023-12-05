import 'dart:async';
import 'package:fire_app/Screens/MainScreens/homeScreen.dart';
import 'package:fire_app/Screens/Onboarding/signup.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

//screen for creating entries in database while signing up
class SignupLoading extends StatefulWidget {
  const SignupLoading({Key? key}) : super(key: key);
  @override
  State<SignupLoading> createState() => _SignupLoadingState();
}

class _SignupLoadingState extends State<SignupLoading> {

  final databaseRef = FirebaseDatabase.instance.ref('users');
  final databaseRef2 = FirebaseDatabase.instance.ref('usersNumberMap');
  final databaseRef3 = FirebaseDatabase.instance.ref('personalChatList');
  final storageRef = FirebaseStorage.instance.ref('profileImage').child('${SignUp.auth.currentUser?.uid}');

  //function for uploading data to database
  void uploadData() async{
    String imageURL = '';
    try {
      final task = await storageRef.putFile(Get.arguments['imageFile']);
      imageURL = await task.ref.getDownloadURL();
      await databaseRef2.child('${SignUp.auth.currentUser?.phoneNumber}').set('${SignUp.auth.currentUser?.uid}').onError((error, stackTrace) {
        Get.snackbar('Error', error.toString());
        Get.back();
      });
      await databaseRef3.child('${SignUp.auth.currentUser?.uid}').set('');
      databaseRef.child('${SignUp.auth.currentUser?.uid}').set({
        'name' : Get.arguments['name'],
        'phone' : SignUp.auth.currentUser?.phoneNumber,
        'profileImg' : imageURL,
      }).then((value) {
        Get.offAll(()=>const HomeScreen());
      }).onError((error, stackTrace) {
        Get.snackbar('Error', error.toString());
        Get.back();
      });
    }catch(e){
      Get.snackbar('Error', e.toString());
      Get.back();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uploadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height*0.97,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/signup/loading.png'),
              const Text('Initializing.......',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),)
            ],
          ),
        ),
      ),
    );
  }
}

