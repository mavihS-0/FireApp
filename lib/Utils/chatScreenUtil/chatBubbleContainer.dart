import 'package:fire_app/Utils/constants.dart';
import 'package:flutter/material.dart';

class ChatBubbleContainer extends StatefulWidget {
  final Widget child;
  final bool isMe;
  final String? senderProfileURL;
  final List? viewedBy;
  final String? senderName;
  final String time;
  const ChatBubbleContainer(
      {Key? key,
      required this.child,
      required this.isMe,
      this.senderProfileURL,
      this.viewedBy,
      this.senderName,
      required this.time})
      : super(key: key);

  @override
  State<ChatBubbleContainer> createState() => _ChatBubbleContainerState();
}

class _ChatBubbleContainerState extends State<ChatBubbleContainer> {

  double overlayHeigh = 0;
  bool showOverlay = false;
  bool firstCall = true;

  @override
  Widget build(BuildContext context) {
    bool isMe = widget.isMe;
    String? senderProfileURL = widget.senderProfileURL;
    List? viewedBy = widget.viewedBy;
    String? senderName = widget.senderName;
    String time = widget.time;
    Widget child = widget.child;

    if(firstCall) WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      final renderBox = context.findRenderObject() as RenderBox;
      final size = renderBox.size;
      setState(() {
        firstCall = false;
        overlayHeigh = size.height;
      });
    });

    return Stack(
      children: [
        InkWell(
          onLongPress: (){
            setState(() {
              showOverlay = true;
            });
          },
          child: Container(
            margin: EdgeInsets.only(top: 10,left: 10,right: 10),
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
                      // constraints: BoxConstraints(
                      //   minWidth: MediaQuery.of(context).size.width * 0.3,
                      //   maxWidth: MediaQuery.of(context).size.width * 0.7,
                      // ),
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
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
                                ),
                              ],
                            ),
                          ),
                          if(viewedBy!.isNotEmpty)
                            Row(
                              mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 25,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: viewedBy!.length > 4 ? 4 : viewedBy!.length,
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
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        showOverlay ? InkWell(
          onTap: (){
            setState(() {
              showOverlay = false;
            });
          },
          child: Container(height: overlayHeigh,
          color: Colors.black.withOpacity(0.4),),
        ) :SizedBox(),
        showOverlay ? Column(
          children: [
            SizedBox(height: overlayHeigh -10),
            Center(
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width - 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.red
                ),
              ),
            )
          ],
        ):SizedBox()
      ],
    );
  }
}
