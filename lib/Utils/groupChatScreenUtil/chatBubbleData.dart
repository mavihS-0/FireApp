import 'package:cached_network_image/cached_network_image.dart';
import 'package:fire_app/Screens/OtherScreens/imagePreview.dart';
import 'package:fire_app/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatBubbleData extends StatelessWidget {
  final String type;
  final content;
  const ChatBubbleData({Key? key,required this.type, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(type == 'text')
      return Text(content,style: TextStyle(
        fontSize: Constants.mediumFontSize,
        fontWeight: FontWeight.w400
      ),);
    else if(type == 'image') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: (){
              Get.to(()=>ImagePreview(),arguments: {
                'imageURL' : content['imageURL'],
              });
            },
            child: CachedNetworkImage(
              imageUrl : content['imageURL'],
              placeholder: (context, url) => const CircularProgressIndicator(),
              imageBuilder: (context,image){
                return ClipRRect(
                  child: Image(image: image,),
                  borderRadius: BorderRadius.circular(10),
                );
              },
              errorWidget: (context, url, error) {
                return Column(
                  children: [
                    Icon(Icons.error,color: Constants.FGcolor.withOpacity(0.4)),
                    Text('Image not found',style: TextStyle(
                      fontSize: Constants.mediumFontSize,
                      fontWeight: FontWeight.w400
                    ),)
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 5,),
          if(content['caption'] != '') Text(content['caption'])
        ],
      );
    } else
      return Container();
  }
}
