import 'package:fire_app/Utils/popUpMenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../Utils/constants.dart';

class PersonalChatScreen extends StatefulWidget {
  const PersonalChatScreen({Key? key}) : super(key: key);

  @override
  State<PersonalChatScreen> createState() => _PersonalChatScreenState();
}

class _PersonalChatScreenState extends State<PersonalChatScreen> {

  DatabaseReference userDataRef = FirebaseDatabase.instance.ref('users').child(Get.arguments['friendUid']);
  TextEditingController message = TextEditingController();
  DatabaseReference messageRef = FirebaseDatabase.instance.ref('personalChats').child(Get.arguments['pid']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Get.back();
            },
          ),
          StreamBuilder(
            stream: userDataRef.onValue,
            builder: (context,snapshot){
              if(snapshot.hasData){
                final userData = Map<dynamic, dynamic>.from(
                    (snapshot.data! as DatabaseEvent).snapshot.value
                    as Map<dynamic, dynamic>);
                return Row(
                  children: [
                    SizedBox(width: 5,),
                    ClipOval(
                      child: Image.network(
                        userData['profileImg'],
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return SizedBox(
                            height: 40,
                            width: 40,
                            child: SpinKitRing(color: Constants.priColor,size: 25,lineWidth: 4,),
                          );
                        },),
                    ),
                    SizedBox(width: 10,),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(userData['name'],style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),),
                          //TODO: user status
                          Text('Online',style: TextStyle(
                              fontSize: 12
                          ),),
                        ],
                      ),
                    ),
                  ],
                );
              }
              else{
                return Center(child: SpinKitThreeBounce(color: Constants.priColor,),);
              }
            },
          ),
          Expanded(child: SizedBox()),
          customPopUpMenu('hello', (){

          }),
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
              height: 70,
              width: MediaQuery.of(context).size.width,
              color: Colors.blue,
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width*0.8,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50)
                    ),
                    child: Row(
                      children: [
                        IconButton(onPressed: (){}, icon: Icon(Icons.emoji_emotions_rounded,color: Colors.grey[500],)),
                        SizedBox(width: 5,),
                        Expanded(
                          child: TextField(
                            controller: message,
                            decoration: InputDecoration(
                              hintText: 'Type message here...',
                              hintStyle: TextStyle(
                                color: Colors.grey[500],
                              ),
                            ),
                            onSubmitted: (String value)async{
                              final newMessageKey = messageRef.push();
                              final messageKey = newMessageKey.key;
                              newMessageKey.set({
                                'sender' : FirebaseAuth.instance.currentUser?.uid,
                                'content' : value,
                                'timestamp' : DateTime.now().toString(),
                              });
                              FirebaseDatabase.instance.ref('personalChatList').child(FirebaseAuth.instance.currentUser!.uid).child(Get.arguments['friendUid']).update({
                                'lastMessage' : value,
                                'time' : DateTime.now().toString(),
                              });
                              message.clear();
                            },

                          ),
                        ),
                        SizedBox(width: 5,),
                        IconButton(onPressed: (){}, icon: Icon(Icons.attach_file,color: Colors.grey[500],)),
                        SizedBox(width: 5,),
                        IconButton(onPressed: (){}, icon: Icon(Icons.camera_alt,color: Colors.grey[500],))
                      ],
                    ),
                  ),
                  SizedBox(width: 10,),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: Icon(Icons.mic,color: Colors.blue,),
                      onPressed: (){},
                    ),
                    radius: 30,
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: StreamBuilder(
              stream: messageRef.onValue,
              builder: (context, snapshot2){
                try{
                  if(snapshot2.hasData){
                    final messageData = Map<dynamic, dynamic>.from(
                        (snapshot2.data! as DatabaseEvent).snapshot.value
                        as Map<dynamic, dynamic>);
                    return Container(
                      child: Text(messageData.toString()),
                    );
                  }
                  else{
                    return Container(
                      child: Text('no data yet'),
                    );
                  }
                }catch(e){
                  return Container();
                }
              },
            )
          )
        ],
      )
    );
  }
}
