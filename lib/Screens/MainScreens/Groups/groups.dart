import 'package:cached_network_image/cached_network_image.dart';
import 'package:fire_app/Screens/MainScreens/Groups/GroupChatScreen/groupChatScreen.dart';
import 'package:fire_app/Screens/MainScreens/Groups/addGroup.dart';
import 'package:fire_app/Utils/constants.dart';
import 'package:fire_app/Utils/dummyData/dummyGroupsData.dart';
import 'package:fire_app/Utils/noDataHomePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Utils/homeScreenUtil/homeScreenListTIle.dart';
import '../../../Utils/homeScreenUtil/pfpUtil/pfpDialogBox.dart';
import '../ProfileScreens/groupInfo.dart';

//screen to show all the groups (home screen)
class Groups extends StatefulWidget {
  const Groups({Key? key}) : super(key: key);

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  @override
  Widget build(BuildContext context) {

    //if no groups are created then show NoDataHomePage
    if(dummyGroupData.length==0){
      return NoDataHomePage(caption: 'Create a group to start conversation');
    }

    return Scaffold(
      body: ListView.separated(
        itemCount: dummyGroupData.length,
        itemBuilder: (context,index){
          //widget to display each group (in utils)
          return HomeScreenListTile(
            name: dummyGroupData[index].name,
            pfpURL: dummyGroupData[index].pfpURL,
            lastMessage: dummyGroupData[index].lastMessage,
            lastMessageTime: dummyGroupData[index].lastMessageTime,
            onListTileTap: (){
              Get.to(()=>GroupChatScreen());
            },
            onProfileIconTap: (){
              //show dialog box to show group info and chat button
              showDialog(context: context, builder: (context){
                return PfpDialogBox(
                  dummyData: dummyGroupData[index],
                  onInfoButtonPress: () {
                    Get.back();
                    Get.to(()=>GroupInfo(),arguments: {
                      'dummyData' : dummyGroupData[index]
                    });
                  },
                  onChatButtonPress: () {
                    Get.back();
                    Get.to(()=>GroupChatScreen());
                  },);
              });
            },
          );
        },
        separatorBuilder: (context,index){
          return Divider();
        },
      ),
      floatingActionButton: FloatingActionButton(
        //hero tag to differentiate between two floating action buttons on homescreen (personal chats and groups)
        heroTag: const Text('btn1'),
        onPressed: (){
          Get.to(()=>AddGroup());
        },
        child: Icon(Icons.group_add),
      ),
    );
  }
}
