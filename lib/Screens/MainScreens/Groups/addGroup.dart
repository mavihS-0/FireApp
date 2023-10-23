import 'package:cached_network_image/cached_network_image.dart';
import 'package:fire_app/Screens/MainScreens/Groups/finalizeGroup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Utils/constants.dart';
import '../../../Utils/dummyData/dummyContacts.dart';

//screen to create a group
class AddGroup extends StatefulWidget {
  static List <DummyContact> selectedContacts =[];
  const AddGroup({Key? key}) : super(key: key);

  @override
  State<AddGroup> createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  int totalContacts = 0;
  List <bool> isSelected = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalContacts = dummyContacts.length;
    for(int i=0;i<totalContacts;i++){
      isSelected.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('New group'),
            SizedBox(height: 2,),
            Text('${AddGroup.selectedContacts.length.toString()} of ${totalContacts.toString()} selected',style: TextStyle(
              fontSize: 12
            ),)
          ],
        ),
      ),
      body: Column(
        children: [
          AnimatedContainer(
            margin: EdgeInsets.all(10),

            //if no contacts are selected then the container will be of 0 height
            height: AddGroup.selectedContacts.length!=0 ? 60 : 0,

            duration: Duration(milliseconds: 300),
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
                          backgroundImage: CachedNetworkImageProvider(AddGroup.selectedContacts[index].profileURL),
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

          //if no contacts are selected then the container will be of 0 height
          AddGroup.selectedContacts.isNotEmpty ? Divider() :SizedBox(),

          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: dummyContacts.length,
              itemBuilder: (context,index){
                return  InkWell(
                  onTap: (){
                    setState(() {
                      //if the contact is not already selected then add it to the list
                      if(!AddGroup.selectedContacts.contains(dummyContacts[index])){
                        AddGroup.selectedContacts.add(dummyContacts[index]);
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10,vertical: 5),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(dummyContacts[index].profileURL),
                                radius: 30,
                              ),
                              if(AddGroup.selectedContacts.contains(dummyContacts[index]))Align(
                                alignment: Alignment.bottomRight,
                                child: CircleAvatar(
                                    radius: 9,
                                    backgroundColor: Constants.priColor,
                                    child: const Icon(Icons.check,color: Colors.white,size: 16,)),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 15,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(dummyContacts[index].name,style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),),
                              Text(dummyContacts[index].status,style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600]
                              ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context,index){
                return Divider();
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Get.to(()=>FinalizeGroup())?.then((value) {
            setState(() {
            });
          });
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
