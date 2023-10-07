import 'package:fire_app/Utils/dummyData/profileDummyData.dart';
import 'package:flutter/material.dart';
import '../../Utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileDummyData dummyData = ProfileDummyData();
  TextEditingController nameController = TextEditingController(text: 'Rishabh');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.scaffoldBGColor,
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            height: 104,
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Constants.secColor
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: ClipOval(
                    child: Image.network(dummyData.profileURL),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dummyData.name,style: TextStyle(
                        fontSize: 18
                      ),),
                      Text(dummyData.mob,style: TextStyle(
                        fontSize: Constants.smallFontSize
                      ),),
                    ],
                  ),
                ),
                InkWell(
                  onTap: (){

                  },
                  child: Container(
                    height: 26,
                    width: 64,
                    decoration: BoxDecoration(
                      color: Constants.profileEditButton,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text('Edit',style: TextStyle(
                        color: Constants.secColor
                      ),),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10),
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Constants.secColor
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Groups names & pics', style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),),
                  SizedBox(height: 10,),
                  Expanded(
                    child: ListView.separated(
                      itemCount: dummyData.groupData.length,
                      shrinkWrap: true,
                      itemBuilder: (context,index){
                        return Row(
                          children: [
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: ClipOval(
                                child: Image.network(dummyData.groupData[index].groupIcon),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(dummyData.groupData[index].name, style: TextStyle(
                                    fontSize: Constants.smallFontSize
                                ),),
                                Text(dummyData.groupData[index].admin, style: TextStyle(
                                    fontSize: Constants.smallFontSize,
                                    fontWeight: FontWeight.w400,
                                    color: Constants.FGcolor.withOpacity(0.42)
                                ),),
                              ],
                            )
                          ],
                        );
                      },
                      separatorBuilder: (context,index){
                        return Divider();
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
