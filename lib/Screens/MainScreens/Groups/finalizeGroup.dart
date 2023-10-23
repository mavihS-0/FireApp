import 'package:fire_app/Screens/MainScreens/Groups/addGroup.dart';
import 'package:fire_app/Utils/constants.dart';
import 'package:flutter/material.dart';

//screen to finalize the group creation
class FinalizeGroup extends StatefulWidget {
  const FinalizeGroup({Key? key}) : super(key: key);

  @override
  State<FinalizeGroup> createState() => _FinalizeGroupState();
}

class _FinalizeGroupState extends State<FinalizeGroup> {

  bool isGroupIconSelected = false;
  TextEditingController subjectController = TextEditingController();
  FocusNode subjectFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('New group'),
            SizedBox(height: 2,),
            Text('Add subject',style: TextStyle(
                fontSize: 12
            ),)
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                //group icon
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Constants.editableWidgetsColorAddGroup,
                  ),
                  child: isGroupIconSelected ? Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjdiO8KviDeeEnliFi2bIfDxoXA12ee80DOw&usqp=CAU',
                    fit: BoxFit.fill,) :
                  Center(
                    child: Icon(Icons.camera_alt,color: Colors.white,),
                  ),
                ),

                SizedBox(width: 10,),
                Expanded(
                  child: SizedBox(
                    height: 22,
                    child: TextField(
                      controller: subjectController,
                      focusNode: subjectFocusNode,
                      onTapOutside: (event){
                        subjectFocusNode.unfocus();
                      },
                      cursorColor: Constants.FGcolor,
                      style: TextStyle(
                        color: Constants.FGcolor,
                        fontSize: Constants.smallFontSize
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type group subject here...',
                        hintStyle: TextStyle(
                          color: Constants.editableWidgetsColorAddGroup,
                          fontSize: Constants.smallFontSize,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Constants.editableWidgetsColorAddGroup)
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Constants.FGcolor),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10)
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                IconButton(
                  icon: Icon(Icons.emoji_emotions_rounded,color: Constants.editableWidgetsColorAddGroup,),
                  onPressed: (){
                    
                  },
                )
              ],
            ),
          ),
          Divider(color: Color(0xFF1B60E5).withOpacity(0.4),),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Column(
              children: [
                Align(child: Text('Participants: ${AddGroup.selectedContacts.length}',style: TextStyle(
                  color: Constants.FGcolor.withOpacity(0.42)
                ),),
                alignment: Alignment.topLeft,),
                SizedBox(height: 10,),
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    itemCount: AddGroup.selectedContacts.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index){
                      return InkWell(
                        onTap: (){
                          setState(() {
                            AddGroup.selectedContacts.removeAt(index);
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          height: 60,
                          width: 60,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(AddGroup.selectedContacts[index].profileURL),
                                radius: 30,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: CircleAvatar(
                                    radius: 9,
                                    backgroundColor: Constants.priColor,
                                    child: const Icon(Icons.close,color: Colors.white,size: 16,)),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: (){
          setState(() {
            AddGroup.selectedContacts = [];
          });
        },
      ),
    );
  }
}
