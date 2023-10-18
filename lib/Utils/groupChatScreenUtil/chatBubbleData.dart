import 'package:cached_network_image/cached_network_image.dart';
import 'package:fire_app/Utils/constants.dart';
import 'package:flutter/material.dart';

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
          CachedNetworkImage(
            imageUrl : content['imageURL'],
            placeholder: (context, url) => const CircularProgressIndicator(),
          ),
          SizedBox(height: 5,),
          if(content['caption'] != '') Text(content['caption'])
        ],
      );
    } else
      return Container();
  }
}
