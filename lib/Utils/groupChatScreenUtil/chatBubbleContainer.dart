import 'package:fire_app/Utils/groupChatScreenUtil/reactionUtil.dart';
import 'package:fire_app/Utils/constants.dart';
import 'package:fire_app/Utils/dummyData/dummyGroupChatScreenData.dart';
import 'package:flutter/material.dart';

class ChatBubbleContainer extends StatefulWidget {
  final Widget child;
  final bool isMe;
  final String? senderProfileURL;
  final List? seenSoFar;
  final String? senderName;
  final String time;
  final int index;
  final DummyGroupChatScreenData dummyData;
  final ReactionUtil reactionUtil;
  const ChatBubbleContainer(
      {Key? key,
      required this.child,
      required this.isMe,
      this.senderProfileURL,
      this.seenSoFar,
      this.senderName,
      required this.time,
      required this.dummyData,
      required this.reactionUtil,
      required this.index})
      : super(key: key);

  @override
  State<ChatBubbleContainer> createState() => _ChatBubbleContainerState();
}

class _ChatBubbleContainerState extends State<ChatBubbleContainer> {

  double overlayHeigh = 0;
  bool showOverlay = false;
  List commonEmojis = ['👍','♥','😂','😢','😡','😯'];
  int callCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isMe = widget.isMe;
    String? senderProfileURL = widget.senderProfileURL;
    List? seenSoFar = widget.seenSoFar;
    String? senderName = widget.senderName;
    String time = widget.time;
    Widget child = widget.child;
    DummyGroupChatScreenData dummyData = widget.dummyData;
    int dataIndex = widget.index;
    if(widget.index == widget.reactionUtil.chatBubbleIndex && widget.reactionUtil.isEmojiSelected){
      showOverlay = false;
      widget.reactionUtil.chatBubbleIndex = -1;
    }
    callCount+=1;
    if(callCount == 2){
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      final renderBox = context.findRenderObject() as RenderBox;
      final size = renderBox.size;
      setState(() {
        overlayHeigh = size.height;
      });
    });
    }

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
                    Stack(
                      children: [
                        Container(
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
                              SizedBox(height: dummyData.messages[dataIndex]['reactions'].isNotEmpty ? 12 : 0,),
                            ],
                          ),
                        ),
                        dummyData.messages[dataIndex]['reactions'].isNotEmpty ?
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: Container(
                            height: 30,
                            width: dummyData.messages[dataIndex]['reactions'].length==1 ? 35 : 50,
                            decoration: BoxDecoration(
                                color: Constants.priColor,
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: Center(
                              child: Text(dummyData.messages[dataIndex]['reactions'].length==1 ? dummyData.messages[dataIndex]['reactions'][0] :
                                '${dummyData.messages[dataIndex]['reactions'][0]} ${dummyData.messages[dataIndex]['reactions'].length}' ,
                                style: TextStyle(
                                  color: Constants.secColor
                                ),
                              ),
                            ),
                          ),
                        ) : SizedBox(),
                      ],
                    ),
                  ],
                ),
                seenSoFar!.isNotEmpty ? Align(
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    height: 25,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: seenSoFar!.length > 4 ? 4 : seenSoFar!.length,
                      itemBuilder: (context, index){
                        return SizedBox(
                            height: 16,
                            width: 16,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(seenSoFar![index]),
                            )
                        );
                      },
                    ),
                  ),
                ) : SizedBox()
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
            SizedBox(height: overlayHeigh -20),
            Center(
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width - 80,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Constants.priColor
                ),
                child: Row(
                  children: List.generate(7, (index){
                    return InkWell(
                      onTap: index!=6?(){
                        setState(() {
                          dummyData.messages[dataIndex]['reactions'].add(commonEmojis[index]);
                          showOverlay = false;
                        });
                        } : (){
                        widget.reactionUtil.changeReactionKeyboard(true);
                        widget.reactionUtil.chatBubbleIndex = widget.index;
                      },
                      child: SizedBox(
                        height: 50,
                        width: (MediaQuery.of(context).size.width - 100)/7,
                        child: Center(
                          child: index==6?Icon(Icons.add_circle,size: 30,color: Constants.chatBubbleColor,) : Text(commonEmojis[index], style: TextStyle(
                              fontSize: 30
                          ),),
                        ),
                      ),
                    );
                  })
                  ),
                )
              ),
          ],
        ):SizedBox()
      ],
    );
  }
}
