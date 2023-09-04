import 'package:fire_app/Utils/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {

  List <String> contacts = [];
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('usersNumberMap');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> getContacts()async{
    if(await Permission.contacts.request().isGranted){
      Iterable <Contact> phoneContacts = await ContactsService.getContacts();
      List phoneNos = [];
      phoneContacts.forEach((element) {
        phoneNos.add(element.phones?[0].value.toString().replaceAll(' ', ''));
      });
      print(phoneNos);
      final snapshot = await databaseRef.get();
      Map data;
      data = snapshot.value as Map;
      print(data);
      if(data != null){
        for (Contact c in phoneContacts){
          if (data.containsKey(c.phones?[0].toString().replaceAll(' ', ''))){
            contacts.add(c.phones![0].toString());
          }
        }
      }
    }

    print(contacts);
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
            Text('50 contacts', style: TextStyle(
              fontSize: 12
            ),),
          ],
        ),
        actions: [
          IconButton(
              onPressed: (){
                getContacts();
              },
              icon: Icon(Icons.search)
          ),
          PopupMenuButton(
              onSelected: (value){
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
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contacts on FireAppX',style: TextStyle(
              color: Constants.priColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context,index){
                  return Container(
                    child: Text(index.toString()),
                  );
                },
              ),
            )

          ],
        ),
      ),
    );
  }
}
