import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Utils/noDataHomePage.dart';
import 'addContact.dart';

class PersonalChats extends StatefulWidget {
  const PersonalChats({Key? key}) : super(key: key);

  @override
  State<PersonalChats> createState() => _PersonalChatsState();
}

class _PersonalChatsState extends State<PersonalChats> {

  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('personalChatList/${FirebaseAuth.instance.currentUser?.uid}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: databaseRef.onValue,
        builder: (context,snapshot){
          if(snapshot.hasData){
            final myMessages = Map<dynamic, dynamic>.from(
                (snapshot.data! as DatabaseEvent).snapshot.value
                as Map<dynamic, dynamic>);
            return Container(

              child: Text(myMessages.toString()),
            );
          }
          else if(snapshot.data == null){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          else{
            return NoDataHomePage(
              caption: 'Start a conversation',
              floatingBtnIcon: const ImageIcon(
                AssetImage('assets/home_page/add_chat.png'),
              ),
              //TODO: floating button press
              onFloatingBtnPress: (){
                Get.to(()=>AddContact());
              },
            );
          }
        },
      ),
    );
  }
}
