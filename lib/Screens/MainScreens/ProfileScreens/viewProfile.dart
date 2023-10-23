import 'package:fire_app/Utils/dummyData/dummyViewProfileData.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Utils/ProfileScreenUtil/customSwitch.dart';
import '../../../Utils/ProfileScreenUtil/mediaWidget.dart';
import '../../../Utils/ProfileScreenUtil/themeDataWidget.dart';
import '../../../Utils/constants.dart';
import '../../../Utils/roundedContainer.dart';

//screen to show user profile (other user)
class ViewProfile extends StatefulWidget {
  const ViewProfile({Key? key}) : super(key: key);

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {

  DummyViewProfileData dummyData = DummyViewProfileData();

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
                    CircleAvatar(
                      radius: 120,
                      backgroundImage: NetworkImage(dummyData.pfpURL),
                    ),
                    RoundedContainer(
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(dummyData.name,style: TextStyle(
                              fontSize: Constants.largeFontSize
                          ),),
                          Row(
                            children: [
                              Text(dummyData.phone, style: TextStyle(
                                  fontSize: Constants.smallFontSize,
                                  color: Constants.FGcolor.withOpacity(0.32)
                              ),),
                              IconButton(
                                icon: Icon(Icons.share,color: Constants.priColor,),
                                onPressed: (){

                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    ThemeDataWidget(
                      dummyData: dummyData,
                      //change chat theme
                      onThemeChange: (){

                      },
                    ),
                    RoundedContainer(
                        widget: CustomSwitch(
                          title: 'Mute Notifications',
                          onChanged: (event){
                            setState(() {
                              dummyData.muteNotifications = event;
                            });
                          },
                          value: dummyData.muteNotifications,
                        ),
                    ),
                    //widget to show media shared by user
                    MediaWidget(
                      dummyData: dummyData,
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
                                  Icon(Icons.block,color: Constants.alertColor,),
                                  SizedBox(width: 10,),
                                  Text('Block ${dummyData.name}',style: TextStyle(color: Constants.alertColor),)
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
                                  Text('Report ${dummyData.name}',style: TextStyle(color: Constants.alertColor),)
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
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_rounded,color: Constants.secColor,),
                      onPressed: (){
                        Get.back();
                      },
                    ),
                  )
              )
            ],
          )
      ),
    );
  }
}
