import 'dart:io';

import 'package:fire_app/Screens/MainScreens/PersonalChats/PersonalChatScreen/personalChatScreen.dart';
import 'package:fire_app/Screens/MainScreens/ProfileScreens/viewProfile.dart';
import 'package:fire_app/Utils/dummyData/dummyViewProfileData.dart';
import 'package:fire_app/Utils/homeScreenUtil/homeScreenListTIle.dart';
import 'package:fire_app/Utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
// import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../Utils/homeScreenUtil/pfpUtil/pfpDialogBox.dart';
import '../../../Utils/noDataHomePage.dart';
import 'addContact.dart';
import 'package:intl/intl.dart';

//screen to show all the personal chats - list (home screen)
class PersonalChats extends StatefulWidget {
  const PersonalChats({Key? key}) : super(key: key);

  @override
  State<PersonalChats> createState() => _PersonalChatsState();
}

class _PersonalChatsState extends State<PersonalChats> with AutomaticKeepAliveClientMixin<PersonalChats>{

  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('personalChatList/${FirebaseAuth.instance.currentUser?.uid}');
  DatabaseReference userDataRef = FirebaseDatabase.instance.ref('users');
  //dummy data for view profile screen
  DummyViewProfileData dummyData = DummyViewProfileData();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: databaseRef.onValue,
        builder: (context,snapshot){
          Size screenSize = MediaQuery.of(context).size;
          try{
            if(snapshot.hasData){
              final myMessages = Map<dynamic, dynamic>.from(
                  (snapshot.data! as DatabaseEvent).snapshot.value
                  as Map<dynamic, dynamic>);
              final uidList = myMessages.keys.toList();
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.separated(
                  itemCount: myMessages.length,
                  itemBuilder: (context,index){
                    return StreamBuilder(
                      stream: userDataRef.child(uidList[index]).onValue,
                      builder: (context,snapshot2){
                        if(snapshot2.hasData){
                          final userData = Map<dynamic, dynamic>.from(
                              (snapshot2.data! as DatabaseEvent).snapshot.value
                              as Map<dynamic, dynamic>);
                          return HomeScreenListTile(
                            name: userData['name'],
                            lastMessage: myMessages[uidList[index]]['lastMessage'],
                            lastMessageTime: DateFormat.jm().format(DateTime.parse(myMessages[uidList[index]]['time'])),
                            pfpURL: userData['profileImg'],
                            onListTileTap: (){
                              Get.to(()=>PersonalChatScreen(),arguments: {
                                'friendUid' : uidList[index],
                                'pid' : myMessages[uidList[index]]['pid']
                              });
                            },
                            onProfileIconTap: (){
                              showDialog(context: context, builder: (context){
                                return PfpDialogBox(
                                  dummyData: dummyData,
                                  onInfoButtonPress: () {
                                    Get.to(()=>ViewProfile(),arguments: {
                                      'dummyData' : dummyData
                                    });
                                  },
                                  onChatButtonPress: () {
                                    Get.to(()=>PersonalChatScreen(),arguments: {
                                      'friendUid' : uidList[index],
                                      'pid' : myMessages[uidList[index]]['pid']
                                    });
                                  },);
                              });
                            },

                          );
                        }
                        else{
                          return SizedBox();
                        }

                      },
                    );
                  },
                  separatorBuilder: (context,index){
                    return Divider();
                  },
                ),
              );
            }
            else{
              // loading widger
              return Center(
                  child: SpinKitRing(color: Constants.priColor,lineWidth: 5,)
              );
            }
          }catch(e){
            return NoDataHomePage(
              caption: 'Start a conversation',
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        //hero tag to differentiate between two floating action buttons on homescreen (personal chats and groups)
        heroTag: Text('btn2'),
        child: Icon(Icons.question_answer_rounded),
        onPressed: (){
          Get.to(()=>AddContact());
        },
      ),
    );
  }

  //to keep both the home screens alive at the same time
  @override
  bool get wantKeepAlive => true;
}

