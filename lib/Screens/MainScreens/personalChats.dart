import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: myMessages.length,
                itemBuilder: (context,index){
                  return SizedBox(
                    height: 76,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: (){},
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                            child: Row(
                              children: [
                                ClipOval(
                                  child: Image.network(
                                    myMessages[uidList[index]]['profileImg'],
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context, Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },),
                                ),
                                const SizedBox(width: 15,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(myMessages[uidList[index]]['name'],style: const TextStyle(
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
                        ),
                        Divider()
                      ],
                    ),
                  );
                },
              );
            }
            else{
              return Center(
                child: CircularProgressIndicator(),
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
