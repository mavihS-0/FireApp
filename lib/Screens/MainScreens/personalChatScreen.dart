import 'package:fire_app/Utils/noDataHomePage.dart';
import 'package:fire_app/Utils/popUpMenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
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
  String? myUid = FirebaseAuth.instance.currentUser?.uid;
  String recName = '...';
  String recProfileImg ='https://firebasestorage.googleapis.com/v0/b/fireapp-a5221.appspot.com/o/new_profile.png?alt=media&token=00795532-a3e8-4088-b335-ce23ee6750d3';
  String myName = '...';
  final ItemScrollController _scrollController = ItemScrollController();
  bool emojiKeyboard = false;
  Map messageData = {};

  Future <void> getUserData()async{
    final snapshot = await FirebaseDatabase.instance.ref('users').child(myUid!).child('name').get();
    if(snapshot.exists){
      myName = snapshot.value.toString();
    }
    setState(() {
    });
  }

  _scrollToBottom() {
    _scrollController.jumpTo(index: messageData.length-1);
  }

  Map orderData(messages){
    List list = messages.entries.toList();
    list.sort((a, b) => a.value['timestamp'].compareTo(b.value['timestamp']));
    Map sortedMessages = {};
    for (var entry in list) {
      sortedMessages[entry.key] = entry.value;
    }
    return sortedMessages;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  Widget chatInput() {
    return Align(
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
                        final newMessageKey = messageRef.child('messages').push();
                        final messageKey = newMessageKey.key;
                        newMessageKey.set({
                          'sender' : FirebaseAuth.instance.currentUser?.uid,
                          'content' : value,
                          'timestamp' : DateTime.now().millisecondsSinceEpoch.toString(),
                        });
                        FirebaseDatabase.instance.ref('personalChatList').child(FirebaseAuth.instance.currentUser!.uid).child(Get.arguments['friendUid']).update({
                          'lastMessage' : value,
                          'time' : DateTime.now().toString(),
                        });
                        _scrollToBottom();
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
    );
  }

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
                recName = userData['name'];
                recProfileImg = userData['profileImg'];
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
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height-(56+MediaQuery.of(context).padding.top),
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.topCenter,
                  child: StreamBuilder(
                    stream: messageRef.child('messages').orderByChild('timestamp').onValue,
                    builder: (context, snapshot2){
                      try{
                        if(snapshot2.hasData){
                          messageData = Map<dynamic, dynamic>.from(
                              (snapshot2.data!).snapshot.value
                              as Map<dynamic, dynamic>);
                          messageData = orderData(messageData);
                          List messageIds = messageData.keys.toList();
                          return SizedBox(
                            height: MediaQuery.of(context).size.height*0.82,
                            child: ListView.builder(
                              //physics: const ClampingScrollPhysics(),
                              itemCount: messageData.length,
                              shrinkWrap: true,
                              //initialScrollIndex: messageData.length,
                             // itemScrollController: _scrollController,
                              itemBuilder: (context,index){
                                return Container(
                                    padding: EdgeInsets.all(10),
                                    child: messageData[messageIds[index]]['sender']!=myUid?
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(recProfileImg),
                                          radius: 15,
                                        ),
                                        SizedBox(width: 10,),
                                        Container(
                                          width: MediaQuery.of(context).size.width*0.7,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.withOpacity(0.3),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.zero,
                                                topRight: Radius.circular(10),
                                                bottomRight:  Radius.circular(10),
                                                bottomLeft:  Radius.circular(10)),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(recName,style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue[900],
                                              ),),
                                              Text(messageData[messageIds[index]]['content']),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(timestampToTime(int.parse(messageData[messageIds[index]]['timestamp'])), style: TextStyle(
                                                      color: Colors.blue[900],
                                                      fontWeight: FontWeight.w400
                                                  ),),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ):
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context).size.width*0.7,
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.blue.withOpacity(0.3),
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(10),
                                                    topRight: Radius.zero,
                                                    bottomRight:  Radius.circular(10),
                                                    bottomLeft:  Radius.circular(10)),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(myName,style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue[900],
                                                  ),),
                                                  Text(messageData[messageIds[index]]['content']),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text(timestampToTime(int.parse(messageData[messageIds[index]]['timestamp'])), style: TextStyle(
                                                          color: Colors.blue[900],
                                                          fontWeight: FontWeight.w400
                                                      ),),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10,),
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(recProfileImg),
                                              radius: 10,
                                            )
                                          ],
                                        ),

                                      ],
                                    )
                                );
                              },
                            ),
                          );
                        }
                        else{
                          return Container(
                            child: Text('...'),
                          );
                        }
                      }catch(e){
                        print(e.toString());
                        return const NoDataHomePage(caption: 'Start a conversation');
                      }
                    },
                  )
              ),
              chatInput(),

            ],
          ),
        ),
      )
    );

  }

  String timestampToTime(int timestamp) {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final String formattedTime = DateFormat.jm().format(dateTime); // 'jm' stands for 12-hour format
    return formattedTime;
  }
}
