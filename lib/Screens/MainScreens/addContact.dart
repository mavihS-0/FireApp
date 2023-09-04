import 'package:fire_app/Utils/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {

  List <Map<String,String?>> contactsOnApp = [];
  List <Map<String,String?>> contactsNotOnApp = [];
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('usersNumberMap');
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
        phoneContacts.forEach((element) {
          String? phoneNo=element.phones?[0].value.toString().replaceAll(' ', '');
          String? name=element.displayName.toString().capitalize;
          if(data.containsKey(phoneNo)){
            contactsOnApp.add({'name':name,'phone':phoneNo,'profileImg': 'assets/signup/profile.png'});
          }
          else{
            contactsNotOnApp.add({'name':name,'phone':phoneNo,'profileImg': 'assets/signup/profile.png'});
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
            Text('50 contacts', style: TextStyle(
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
              contactsListView(contactsOnApp,(){}),
              contactsNotOnApp.length==0 ? SizedBox() :
              Text('Contacts on FireAppX',style: TextStyle(
                color: Constants.priColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),),
              contactsNotOnApp.length==0 ? SizedBox() :
              contactsListView(contactsNotOnApp,(){}),
            ],
          ),
        ),
      ),
    );
  }
}

Widget contactsListView(List list,Function onPress) {
  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: list.length,
    itemBuilder: (context,index){
      return Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child: InkWell(
              onTap: (){},
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(list[index]['profileImg']!),
                    radius: 25,
                  ),
                  SizedBox(width: 15,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(list[index]['name']!,style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),),
                      Text(list[index]['phone']!,style: TextStyle(
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
  );
}