import 'package:fire_app/Screens/MainScreens/ProfileScreens/MediaLinksAndDocs/mediaLinksAndDocs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants.dart';
import '../roundedContainer.dart';

class MediaWidget extends StatelessWidget {
  final dummyData;
  const MediaWidget({Key? key, required this.dummyData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: (){
              Get.to(()=>MediaLinksAndDocs(),arguments: {
                'name' : dummyData.name
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Media, Links, and docs',style: TextStyle(
                    color: Constants.priColor,
                    fontSize: Constants.smallFontSize
                ),),
                Row(
                  children: [
                    Text(dummyData.media.length.toString(),style: TextStyle(
                        color: Constants.priColor,
                        fontSize: Constants.smallFontSize
                    ),),
                    Icon(Icons.arrow_forward_ios,color: Constants.priColor,size: Constants.smallFontSize,)
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          SizedBox(
            height: 80,
            child: ListView.separated(
              itemCount: dummyData.media.length>4 ? 4 : dummyData.media.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context,index){
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(dummyData.media[index],
                    fit: BoxFit.fill,
                    height: 80,
                    width: 80,
                  ),
                );
              },
              separatorBuilder: (context,index){
                return SizedBox(width: 10,);
              },
            ),
          )
        ],
      ),
    );
  }
}
