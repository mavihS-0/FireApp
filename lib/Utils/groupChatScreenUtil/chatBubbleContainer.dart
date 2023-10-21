import 'package:cached_network_image/cached_network_image.dart';
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
  List commonEmojis = ['👍', '♥', '😂', '😢', '😡', '😯'];
  int callCount = 0;
  int reactionIndex = 0;

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
    if (widget.index == widget.reactionUtil.chatBubbleIndex && widget.reactionUtil.isEmojiSelected) {
      showOverlay = false;
      widget.reactionUtil.chatBubbleIndex = -1;
    }
    callCount += 1;
    if (callCount == 2) {
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
          onLongPress: () {
            setState(() {
              showOverlay = true;
            });
          },
          child: Container(
            margin: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isMe)
                      SizedBox(
                        height: 36,
                        width: 36,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: senderProfileURL!,
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Constants.FGcolor.withOpacity(0.4)),
                          ),
                        ),
                      ),
                    if (!isMe)
                      SizedBox(
                        width: 5,
                      ),
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Constants.chatBubbleColor.withOpacity(0.9),
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
                                    if (!isMe)
                                      Text(
                                        senderName!,
                                        style: TextStyle(color: Constants.senderNameColor, fontWeight: FontWeight.w600),
                                      ),
                                    child,
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          time,
                                          style: TextStyle(
                                              color: Constants.senderNameColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize: Constants.timeFontSize),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: dummyData.messages[dataIndex]['reactions'].isNotEmpty ? 12 : 0,
                              ),
                            ],
                          ),
                        ),
                        dummyData.messages[dataIndex]['reactions'].isNotEmpty
                            ? Positioned(
                                bottom: 0,
                                left: 0,
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return StatefulBuilder(
                                            builder: (context, setState) {
                                              return AlertDialog(
                                                content: Container(
                                                  height: 350,
                                                  width: double.maxFinite,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        height: 40,
                                                        child: ListView.separated(
                                                          shrinkWrap: true,
                                                          scrollDirection: Axis.horizontal,
                                                          itemCount: dummyData.messages[dataIndex]['reactions'].length,
                                                          itemBuilder: (context, index) {
                                                            return InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  reactionIndex = index;
                                                                });
                                                              },
                                                              child: Text(
                                                                '${dummyData.messages[dataIndex]['reactions'][index]}${dummyData.messages[dataIndex]['reactionUsers'][index].length}',
                                                                style: TextStyle(fontSize: 20),
                                                              ),
                                                            );
                                                          },
                                                          separatorBuilder: (context, index) {
                                                            return SizedBox(
                                                              width: 20,
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      Divider(),
                                                      SizedBox(
                                                        height: 290,
                                                        child: ListView.separated(
                                                            shrinkWrap: true,
                                                            itemCount: dummyData.messages[dataIndex]['reactionUsers'][reactionIndex].length,
                                                            itemBuilder: (context, index) {
                                                              return Container(
                                                                  padding: EdgeInsets.symmetric(vertical: 10),
                                                                  child: Text(dummyData.messages[dataIndex]['reactionUsers'][reactionIndex]
                                                                      [index]));
                                                            },
                                                            separatorBuilder: (context, index) {
                                                              return SizedBox(
                                                                height: 10,
                                                              );
                                                            }),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        });
                                  },
                                  child: Container(
                                    height: 30,
                                    width: widget.reactionUtil.getTotalLength(dummyData.messages[dataIndex]) == 1 ? 35 : 50,
                                    decoration: BoxDecoration(color: Constants.priColor, borderRadius: BorderRadius.circular(30)),
                                    child: Center(
                                      child: Text(
                                        widget.reactionUtil.getTotalLength(dummyData.messages[dataIndex]) == 1
                                            ? dummyData.messages[dataIndex]['reactions'][0]
                                            : '${dummyData.messages[dataIndex]['reactions'][0]} ${widget.reactionUtil.getTotalLength(dummyData.messages[dataIndex])}',
                                        style: TextStyle(color: Constants.secColor),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ],
                ),
                seenSoFar!.isNotEmpty
                    ? Align(
                        alignment: Alignment.bottomRight,
                        child: SizedBox(
                          height: 25,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: seenSoFar!.length > 4 ? 4 : seenSoFar!.length,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(seenSoFar![index]),
                                  ));
                            },
                          ),
                        ),
                      )
                    : SizedBox()
              ],
            ),
          ),
        ),
        showOverlay
            ? InkWell(
                onTap: () {
                  setState(() {
                    showOverlay = false;
                  });
                },
                child: Container(
                  height: overlayHeigh,
                  color: Colors.black.withOpacity(0.4),
                ),
              )
            : SizedBox(),
        showOverlay
            ? Column(
                children: [
                  SizedBox(height: overlayHeigh - 20),
                  Center(
                      child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 80,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Constants.priColor),
                    child: Row(
                        children: List.generate(7, (index) {
                      return InkWell(
                        onTap: index != 6
                            ? () {
                                setState(() {
                                  widget.reactionUtil.addEmoji(dummyData.messages[dataIndex], commonEmojis[index]);
                                  showOverlay = false;
                                });
                              }
                            : () {
                                widget.reactionUtil.changeReactionKeyboard(true);
                                widget.reactionUtil.chatBubbleIndex = widget.index;
                              },
                        child: SizedBox(
                          height: 50,
                          width: (MediaQuery.of(context).size.width - 100) / 7,
                          child: Center(
                            child: index == 6
                                ? Icon(
                                    Icons.add_circle,
                                    size: 30,
                                    color: Constants.chatBubbleColor,
                                  )
                                : Text(
                                    commonEmojis[index],
                                    style: TextStyle(fontSize: 30),
                                  ),
                          ),
                        ),
                      );
                    })),
                  )),
                ],
              )
            : SizedBox()
      ],
    );
  }
}
