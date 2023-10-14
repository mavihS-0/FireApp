import 'package:fire_app/Utils/constants.dart';
import 'package:flutter/material.dart';

class ChatBubbleContainer extends StatelessWidget {
  final Widget child;
  final bool isMe;
  final String? senderProfileURL;
  final List? viewedBy;
  final String? senderName;
  final String time;
  const ChatBubbleContainer({Key? key, required this.child, required this.isMe, this.senderProfileURL, this.viewedBy, this.senderName, required this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(!isMe)
                SizedBox(
                  height: 36,
                  width: 36,
                  child: ClipOval(
                    child: Image.network(senderProfileURL!),
                  ),
                ),
              if(!isMe) SizedBox(width: 5,),
              Container(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * 0.3,
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                decoration: BoxDecoration(
                  color: Constants.chatBubbleColor,
                  borderRadius: BorderRadius.only(
                    topLeft: isMe ? Radius.circular(10) : Radius.circular(0),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: isMe ? Radius.circular(0) : Radius.circular(10),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(!isMe)
                      Text(senderName!, style: TextStyle(
                          color: Constants.senderNameColor,
                          fontWeight: FontWeight.w600
                      ),),
                    child,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(time, style: TextStyle(
                            color: Constants.senderNameColor,
                            fontWeight: FontWeight.w400,
                            fontSize: Constants.timeFontSize
                        ),),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          if(isMe &&  viewedBy!.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 25,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: viewedBy!.length,
                    itemBuilder: (context, index){
                      return SizedBox(
                        height: 16,
                        width: 16,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(viewedBy![index]),
                        )
                      );
                    },
                  ),
                )
              ],
            )
        ],
      ),
    );
  }
}
