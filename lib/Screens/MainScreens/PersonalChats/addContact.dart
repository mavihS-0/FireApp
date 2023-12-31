import 'dart:math';

import 'package:fire_app/Screens/MainScreens/PersonalChats/PersonalChatScreen/personalChatScreen.dart';
import 'package:fire_app/Utils/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

//screen to add contacts to app (has complications)
class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {

  List <Map<String,String?>> contactsOnApp = [];
  List <Map<String,String?>> contactsNotOnApp = [];
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('usersNumberMap');
  DatabaseReference chatRef = FirebaseDatabase.instance.ref('personalChats');
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getContacts();
  }

  Future<void> getContacts()async{
    setState(() {
      isLoading = true;
    });
    //TODO: contact avatar
    try{
      if(await Permission.contacts.request().isGranted){
        Iterable <Contact> phoneContacts = await ContactsService.getContacts(withThumbnails: true);
        final snapshot = await databaseRef.get();
        Map data;
        data = snapshot.value as Map;

        //function to check if contact is on app (in our database)
        phoneContacts.forEach((element) {
          String? phoneNo=element.phones?[0].value.toString().replaceAll(' ', '');
          String? name=element.displayName.toString().capitalize;
          print(phoneNo);
          if(data.containsKey(phoneNo)){
            contactsOnApp.add({'name':name,'phone':phoneNo,'profileImg': 'assets/signup/profile.png','uid':data[phoneNo]});
          }
          else{
            contactsNotOnApp.add({'name':name,'phone':phoneNo,'profileImg': 'assets/signup/profile.png','uid':null});
          }

        });
      }
    }catch(e){
      Get.snackbar('Error', e.toString());
    }
    isLoading=false;
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select contact', style: TextStyle(
              fontSize: 20
            ),),
            Text(contactsOnApp.isEmpty?'...':contactsOnApp.length.toString(), style: TextStyle(
              fontSize: 12
            ),),
          ],
        ),
        actions: [
          IconButton(
              onPressed: (){
              },
              icon: Icon(Icons.search)
          ),
          PopupMenuButton(
              onSelected: (value){
                if(value=='Refresh'){
                  getContacts();
                }
              },
              itemBuilder: (context){
                return {'Invite a friend','Contacts', 'Refresh'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              })
        ],
      ),
      body: isLoading == true ? Center(child: CircularProgressIndicator()) :
      Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Contacts on FireAppX',style: TextStyle(
                color: Constants.priColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: contactsOnApp.length,
                itemBuilder: (context,index){
                  return Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context)=> const Center(child: CircularProgressIndicator()),
                          );
                          String? myUid = FirebaseAuth.instance.currentUser?.uid;
                          String? recUid = contactsOnApp[index]['uid'];
                          String? pid;

                          try{
                            final snapshot = await FirebaseDatabase.instance.ref('personalChatList').child(myUid!).get();
                            Map data = snapshot.value as Map;

                            //check if chat already exists
                            if (data.containsKey(recUid)){
                              pid = data[recUid]['pid'];
                            }
                            else{
                              throw Exception();
                            }
                          }catch(e){
                            //create a new entry in personal chats list if chat doesn't exist
                            final newChatKey = chatRef.push();
                            pid = newChatKey.key;
                            await FirebaseDatabase.instance.ref('personalChatList').child(myUid!).child(recUid!).set({
                              'pid' : pid,
                              'lastMessage' : contactsOnApp[index]['phone'],
                              'time' : DateTime.now().toString(),
                            }).onError((error, stackTrace){
                              Get.snackbar('Error', error.toString());
                            });
                            await FirebaseDatabase.instance.ref('personalChatList').child(recUid!).child(myUid!).set({
                              'pid' : pid,
                              'lastMessage' : contactsOnApp[index]['phone'],
                              'time' : DateTime.now().toString(),
                            }).onError((error, stackTrace){
                              Get.snackbar('Error', error.toString());
                            });
                            await newChatKey.set({
                              'participants' : {
                                myUid : true,
                                recUid : true,
                              },
                              'messages' : '',
                            }).onError((error, stackTrace){
                              Get.snackbar('Error', error.toString());
                            });
                          }
                          Get.back();
                          Get.off(()=>PersonalChatScreen(),arguments: {
                            'pid' : pid,
                            'friendUid' : recUid
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(contactsOnApp[index]['profileImg']!),
                                radius: 25,
                              ),
                              SizedBox(width: 15,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(contactsOnApp[index]['name']!,style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),),
                                  Text(contactsOnApp[index]['phone']!,style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600]
                                  ),)
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Divider()
                    ],
                  );
                },
              ),

              //if there are contacts not on app then show them under this
              contactsNotOnApp.length==0 ? SizedBox() :
              Text('Contacts not on FireAppX',style: TextStyle(
                color: Constants.priColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),),
              contactsNotOnApp.length==0 ? SizedBox() :
                  //TODO: contactsNotOnApp onTap function
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: contactsNotOnApp.length,
                itemBuilder: (context,index){
                  return Column(
                    children: [
                      InkWell(
                        // function to invite contacts not on app
                        onTap: (){},

                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(contactsNotOnApp[index]['profileImg']!),
                                radius: 25,
                              ),
                              SizedBox(width: 15,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(contactsNotOnApp[index]['name']!,style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),),
                                  Text(contactsNotOnApp[index]['phone']!,style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600]
                                  ),)
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Divider()
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}