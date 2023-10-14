import 'package:fire_app/Screens/MainScreens/Groups/inviteLinkScreen.dart';
import 'package:fire_app/Utils/ProfileScreenUtil/mediaWidget.dart';
import 'package:fire_app/Utils/ProfileScreenUtil/themeDataWidget.dart';
import 'package:fire_app/Utils/constants.dart';
import 'package:fire_app/Utils/ProfileScreenUtil/customSwitch.dart';
import 'package:fire_app/Utils/dummyData/dummyContacts.dart';
import 'package:fire_app/Utils/dummyData/dummyGroupInfoData.dart';
import 'package:fire_app/Utils/dummyData/dummyGroupsData.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../Utils/roundedContainer.dart';


class GroupInfo extends StatefulWidget {
  const GroupInfo({Key? key}) : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {

  DummyGroupData dummyData = Get.arguments['dummyData'];
  DummyGroupInfoData dummyGroupInfoData = DummyGroupInfoData();
  DummyContact dummyAdminData = DummyContact('Rahul', 'Heyy i am using FireAppX', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjdiO8KviDeeEnliFi2bIfDxoXA12ee80DOw&usqp=CAU');
  bool showMoreParticipants = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showMoreParticipants = dummyGroupInfoData.participants.length >3;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.scaffoldBGColor,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 5,),
                  CircleAvatar(
                    radius: 120,
                    backgroundImage: NetworkImage(dummyData.pfpURL),
                  ),
                  RoundedContainer(
                    widget: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(dummyData.name,style: TextStyle(
                              fontSize: Constants.largeFontSize
                            ),),
                            Text('Created by ${dummyGroupInfoData.createdBy} on ${dummyGroupInfoData.dateCreated}', style: TextStyle(
                              fontSize: Constants.smallFontSize,
                              color: Constants.FGcolor.withOpacity(0.32)
                            ),)
                          ],
                        ),
                        TextButton(
                          onPressed: (){

                          },
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 14,color: Constants.priColor,),
                              Text(' Change',style: TextStyle(color: Constants.priColor),)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  RoundedContainer(
                    widget: Row(
                      children: [
                        ClipOval(
                          child: Image.network(dummyAdminData.profileURL,
                          height: 50,
                          width: 50,
                          fit: BoxFit.fill,),
                        ),
                        SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(dummyAdminData.name,style: TextStyle(
                                  fontSize: Constants.mediumFontSize,
                                  color: Constants.FGcolor
                                ),),
                                SizedBox(width: 10,),
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border(
                                      top : BorderSide(color: Constants.priColor),
                                        bottom : BorderSide(color: Constants.priColor),
                                        left : BorderSide(color: Constants.priColor),
                                        right : BorderSide(color: Constants.priColor),
                                    ),
                                  ),
                                  child: Text('Group Admin', style: TextStyle(
                                    fontSize: 9,
                                    color: Constants.priColor
                                  ),),
                                )
                              ],
                            ),
                            Text(dummyAdminData.status,style: TextStyle(
                              fontSize: Constants.smallFontSize,
                              color: Constants.FGcolor.withOpacity(0.32)
                            ),)
                          ],
                        )
                      ],
                    )
                  ),
                  ThemeDataWidget(
                    dummyData: dummyGroupInfoData,
                    onThemeChange: (){

                    },
                  ),
                  RoundedContainer(
                    widget: Column(
                      children: [
                        CustomSwitch(
                          title: 'Mute Notifications',
                          onChanged: (event){
                            setState(() {
                              dummyGroupInfoData.muteNotifications = event;
                            });
                          },
                          value: dummyGroupInfoData.muteNotifications,
                        ),
                        CustomSwitch(
                          title: 'Only admins can post',
                          onChanged: (event){
                            setState(() {
                              dummyGroupInfoData.onlyAdminsCanPost = event;
                            });
                          },
                          value: dummyGroupInfoData.onlyAdminsCanPost,
                        )
                      ],
                    )
                  ),
                  MediaWidget(
                    dummyData: dummyGroupInfoData,
                  ),
                  RoundedContainer(
                    widget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${dummyGroupInfoData.participants.length} Participants',style: TextStyle(
                            color: Constants.priColor,
                            fontSize: Constants.smallFontSize
                        ),),
                        SizedBox(height: 10,),
                        InkWell(
                          onTap: (){

                          },
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Constants.priColor
                                ),
                                child: Icon(Icons.person_add_alt_sharp,color: Constants.secColor),
                              ),
                              SizedBox(width: 10,),
                              Text('Add Participants')
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        InkWell(
                          onTap: (){
                            Get.to(()=>InviteLinkScreen());
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Constants.priColor
                                ),
                                child: Icon(Icons.link_outlined,color: Constants.secColor),
                              ),
                              SizedBox(width: 10,),
                              Text('Share Invite links')
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  RoundedContainer(
                    widget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Other Participants',style: TextStyle(
                            color: Constants.priColor,
                            fontSize: Constants.smallFontSize
                        ),),
                        SizedBox(height: 10,),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: showMoreParticipants ? 3: dummyGroupInfoData.participants.length,
                          itemBuilder: (context,index){
                            return Row(
                              children: [
                                ClipOval(
                                  child: Image.network(dummyGroupInfoData.participants[index].profileURL,
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.fill,),
                                ),
                                SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(dummyGroupInfoData.participants[index].name,style: TextStyle(
                                        fontSize: Constants.mediumFontSize,
                                        color: Constants.FGcolor
                                    ),),
                                    Text(dummyGroupInfoData.participants[index].status,style: TextStyle(
                                        fontSize: Constants.smallFontSize,
                                        color: Constants.FGcolor.withOpacity(0.32)
                                    ),)
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border(
                                      top : BorderSide(color: Constants.priColor),
                                      bottom : BorderSide(color: Constants.priColor),
                                      left : BorderSide(color: Constants.priColor),
                                      right : BorderSide(color: Constants.priColor),
                                    ),
                                  ),
                                  child: Text('Group Admin', style: TextStyle(
                                      fontSize: 9,
                                      color: Constants.priColor
                                  ),),
                                )
                              ],
                            );
                          },
                          separatorBuilder: (context,index){
                            return SizedBox(height: 10,);
                          },
                        ),
                        SizedBox(height: showMoreParticipants ? 10 : 0,),
                        showMoreParticipants ? Center(
                          child: OutlinedButton(
                            onPressed: (){

                            },
                            child: Text('View all (${dummyGroupInfoData.participants.length - 3} more)',style: TextStyle(
                              color: Constants.priColor
                            ),),
                            style: ButtonStyle(
                              side: MaterialStatePropertyAll<BorderSide>(BorderSide(color: Constants.priColor))
                            ),
                          ),
                        ) : SizedBox()
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                    decoration: BoxDecoration(
                        color: Constants.secColor,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 5),
                          child: InkWell(
                            onTap: (){

                            },
                            child: Row(
                              children: [
                                Icon(Icons.logout,color: Constants.alertColor,),
                                SizedBox(width: 10,),
                                Text('Exit Group',style: TextStyle(color: Constants.alertColor),)
                              ],
                            ),
                          ),
                        ),
                        Divider(color: Constants.scaffoldBGColor,),
                        Padding(
                          padding: const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                          child: InkWell(
                            onTap: (){

                            },
                            child: Row(
                              children: [
                                Icon(Icons.report,color: Constants.alertColor,),
                                SizedBox(width: 10,),
                                Text('Report Group',style: TextStyle(color: Constants.alertColor),)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,)
                ],
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              color: Constants.FGcolor.withOpacity(0.32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_rounded,color: Constants.secColor,),
                    onPressed: (){
                      Get.back();
                    },
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit,color: Constants.secColor,),
                        onPressed: (){

                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.person_add_alt_sharp,color: Constants.secColor,),
                        onPressed: (){

                        },
                      ),
                    ],
                  )
                ],
              )
            )
          ],
        )
      ),
    );
  }
}
