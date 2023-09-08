import 'package:fire_app/Screens/MainScreens/personalChatScreen.dart';
import 'package:fire_app/Utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../Utils/noDataHomePage.dart';
import 'addContact.dart';
import 'package:intl/intl.dart';

class PersonalChats extends StatefulWidget {
  const PersonalChats({Key? key}) : super(key: key);

  @override
  State<PersonalChats> createState() => _PersonalChatsState();
}

class _PersonalChatsState extends State<PersonalChats> with AutomaticKeepAliveClientMixin<PersonalChats>{

  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('personalChatList/${FirebaseAuth.instance.currentUser?.uid}');
  DatabaseReference userDataRef = FirebaseDatabase.instance.ref('users');
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
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child:  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: myMessages.length,
                    itemBuilder: (context,index){
                      return SizedBox(
                        height: 76,
                        child: Column(
                          children: [
                            StreamBuilder(
                              stream: userDataRef.child(uidList[index]).onValue,
                              builder: (context,snapshot2){
                                if(snapshot2.hasData){
                                  final userData = Map<dynamic, dynamic>.from(
                                      (snapshot2.data! as DatabaseEvent).snapshot.value
                                      as Map<dynamic, dynamic>);
                                  return InkWell(
                                    //TODO: go to chat screen function
                                    onTap: (){
                                      Get.to(()=>PersonalChatScreen(),arguments: {
                                        'friendUid' : uidList[index],
                                        'pid' : myMessages[uidList[index]]['pid']
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: (){
                                              //TODO: profile icon tap function
                                              print('hellow');
                                            },
                                            child: ClipOval(
                                              child: Image.network(
                                                userData['profileImg'],
                                                height: 50,
                                                width: 50,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (BuildContext context, Widget child,
                                                    ImageChunkEvent? loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return SizedBox(
                                                    height: 50,
                                                    width: 50,
                                                    child: SpinKitRing(color: Constants.priColor,size: 25,lineWidth: 4,),
                                                  );
                                                },),
                                            ),
                                          ),
                                          const SizedBox(width: 15,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(userData['name'],style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),),
                                              Container(
                                                width: screenSize.width*0.6,
                                                child: Text(myMessages[uidList[index]]['lastMessage'],style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600]
                                                ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                          Expanded(child: Container()),
                                          Text(DateFormat.jm().format(DateTime.parse(myMessages[uidList[index]]['time'])),
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),)
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                else{
                                  return Center(
                                    child: SpinKitThreeBounce(color: Constants.priColor,size: 30,),
                                  );
                                }

                              },
                            ),
                            Divider()
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            }
            else{
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
        child: const ImageIcon(
          AssetImage('assets/home_page/add_chat.png'),
        ),
        onPressed: (){
          Get.to(()=>AddContact());
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
