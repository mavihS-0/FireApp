import 'package:fire_app/Screens/MainScreens/Groups/addGroup.dart';
import 'package:fire_app/Utils/constants.dart';
import 'package:fire_app/Utils/dummyData/dummyGroupsData.dart';
import 'package:fire_app/Utils/noDataHomePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Utils/pfpUtil/pfpDialogBox.dart';
import '../ProfileScreens/groupInfo.dart';

class Groups extends StatefulWidget {
  const Groups({Key? key}) : super(key: key);

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  @override
  Widget build(BuildContext context) {
    if(dummyGroupData.length==0){
      return NoDataHomePage(caption: 'Create a group to start conversation');
    }
    return Scaffold(
      body: ListView.separated(
        itemCount: dummyGroupData.length,
        itemBuilder: (context,index){
          return InkWell(
            //TODO: go to chat screen function
            onTap: (){
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              child: Row(
                children: [
                  InkWell(
                    onTap: (){
                      //TODO: profile icon tap function
                      showDialog(context: context, builder: (context){
                        return PfpDialogBox(
                          dummyData: dummyGroupData[index],
                          onInfoButtonPress: () {
                            Get.back();
                            Get.to(()=>GroupInfo(),arguments: {
                              'dummyData' : dummyGroupData[index]
                            });
                          },
                          onChatButtonPress: () {  },);
                      });
                    },
                    child: ClipOval(
                      child: Image.network(
                        dummyGroupData[index].pfpURL,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(dummyGroupData[index].name,style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),),
                        Text(dummyGroupData[index].lastMessage,style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600]
                        ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text(dummyGroupData[index].lastMessageTime,
                    style: const TextStyle(
                      fontSize: 12,
                    ),)
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context,index){
          return Divider();
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: const Text('btn1'),
        onPressed: (){
          Get.to(()=>AddGroup());
        },
        child: Icon(Icons.group_add),
      ),

    );
  }
}
