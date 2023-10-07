import 'package:flutter/material.dart';

import '../../../Utils/constants.dart';
import '../../../Utils/dummyData/dummyContacts.dart';

class AddGroup extends StatefulWidget {
  const AddGroup({Key? key}) : super(key: key);

  @override
  State<AddGroup> createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {

  List <DummyContact> selectedContacts =[];
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
            Text('${selectedContacts.length.toString()} of ${totalContacts.toString()} selected',style: TextStyle(
              fontSize: 12
            ),)
          ],
        ),
      ),
      body: Column(
        children: [
          AnimatedContainer(
            margin: EdgeInsets.all(10),
            height: selectedContacts.length!=0 ? 60 : 0,
            duration: Duration(milliseconds: 300),
            child: ListView.builder(
              itemCount: selectedContacts.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context,index){
                return InkWell(
                  onTap: (){
                    setState(() {
                      selectedContacts.removeAt(index);
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: 60,
                    width: 60,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(selectedContacts[index].profileURL),
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
          selectedContacts.length!=0 ? Divider() :SizedBox(),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: dummyContacts.length,
              itemBuilder: (context,index){
                return  InkWell(
                  onTap: (){
                    setState(() {
                      if(!selectedContacts.contains(dummyContacts[index])){
                        selectedContacts.add(dummyContacts[index]);
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(dummyContacts[index].profileURL),
                                radius: 30,
                              ),
                              if(selectedContacts.contains(dummyContacts[index]))Align(
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

        },
        child: Icon(Icons.check),
      ),
    );
  }
}
