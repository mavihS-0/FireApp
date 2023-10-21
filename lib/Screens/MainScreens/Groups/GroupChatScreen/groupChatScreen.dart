import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fire_app/Screens/MainScreens/PersonalChats/PersonalChatScreen/cameraImagePickerScreen.dart';
import 'package:fire_app/Screens/MainScreens/PersonalChats/PersonalChatScreen/filePickerScreen.dart';
import 'package:fire_app/Screens/MainScreens/PersonalChats/PersonalChatScreen/imagePickerScreen.dart';
import 'package:fire_app/Utils/groupChatScreenUtil/chatBubbleContainer.dart';
import 'package:fire_app/Utils/groupChatScreenUtil/chatBubbleData.dart';
import 'package:fire_app/Utils/groupChatScreenUtil/reactionUtil.dart';
import 'package:fire_app/Utils/dummyData/dummyGroupChatScreenData.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Utils/constants.dart';
import '../../../../Utils/customAttachButtonType.dart';
import '../../../../Utils/popUpMenu.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({Key? key}) : super(key: key);

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> with AutomaticKeepAliveClientMixin<GroupChatScreen>{

  DummyGroupChatScreenData dummyData = DummyGroupChatScreenData();
  bool _isEmojiKeyboardVisible = false;
  bool _isNotTyping = true;
  bool _isAttachButtonPressed = false;
  TextEditingController _messageController = TextEditingController();
  FocusNode _textFocusNode = FocusNode();
  ScrollController chatScrollController = ScrollController();
  ReactionUtil reactionUtil = ReactionUtil();

  void _toggleKeyboard() {
    setState(() {
      _isEmojiKeyboardVisible = !_isEmojiKeyboardVisible;
      if (_isEmojiKeyboardVisible) {
        FocusScope.of(context).requestFocus(FocusNode());
      } else {
        FocusScope.of(context).requestFocus(_textFocusNode);
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  _onBackspacePressed() {
    _messageController
      ..text = _messageController.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _messageController.text.length));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reactionUtil.reactionKeyboardStream.listen((event) {
      setState(() {
        //print(_isEmojiKeyboardVisible);
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _messageController.dispose();
    _textFocusNode.dispose();
    chatScrollController.dispose();
    reactionUtil.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: appBar(),
      ),
      body: Column(
        children: [
          MembersScrollView(),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: ListView.builder(
                itemCount: dummyData.messages.length,
                reverse: true,
                controller: chatScrollController,
                itemBuilder: (context,i){
                  int index = dummyData.messages.length - i - 1;
                  bool _isMe = dummyData.messages[index]['sender'] == 'Me';
                  return Stack(
                      children: [
                        ChatBubbleContainer(
                          isMe: _isMe,
                          senderName: dummyData.messages[index]['sender'],
                          time: dummyData.messages[index]['timestamp'],
                          senderProfileURL: dummyData.messages[index]['senderProfileURL'],
                          child: ChatBubbleData(
                            type: dummyData.messages[index]['type'],
                            content: dummyData.messages[index]['content'],
                          ),
                          seenSoFar: dummyData.messages[index]['viewedBy'], dummyData: dummyData, index: index,
                          reactionUtil: reactionUtil,
                        ),
                      ]
                  );
                },
              ),
            ),
          ),
          TapRegion(
            onTapOutside: (event){
              setState(() {
                _isAttachButtonPressed = false;
                _isEmojiKeyboardVisible = false;
              });
            },
            child: Column(
              children: [
                AttachButton(_isAttachButtonPressed ? 90:0,),
                ChatInput(),
                EmojiPickerWidget(),
              ],
            ),
          ),
          reactionUtil.ReactionKeyboardWidget(
              (category, emoji){
                setState(() {
                  reactionUtil.addEmoji(dummyData.messages[reactionUtil.chatBubbleIndex], emoji.emoji);
                  reactionUtil.changeReactionKeyboard(false);
                  reactionUtil.isEmojiSelected = true;
                });
              }
          ),
        ],
      ),
    );
  }

  List<Widget> appBar(){
    return [
      IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: (){
          Get.back();
        },
      ),
      Expanded(
        child: Row(
          children: [
            SizedBox(width: 5,),
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: dummyData.groupIcon,
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error,color: Constants.FGcolor),
              )
            ),
            SizedBox(width: 10,),
            Expanded(child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(dummyData.name,style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                  ),),
                  //TODO: user status
                  Text(dummyData.participants.toString().substring(1,dummyData.participants.toString().length-1),style: TextStyle(
                      fontSize: 12
                  ),
                  overflow: TextOverflow.ellipsis,),
                ],
              ),
            ),)
          ],
        ),
      ),
      customPopUpMenu('Group Info', (){

      }),
    ];
  }

  Widget ChatInput(){
    return Container(
      padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
      height: 70,
      width: MediaQuery.of(context).size.width,
      color: Constants.priColor,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50)
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: (){
                      setState(() {
                        _isAttachButtonPressed = false;
                        _toggleKeyboard();
                      });
                    },
                    icon: Icon(_isEmojiKeyboardVisible?Icons.keyboard : Icons.emoji_emotions_rounded,color: Constants.editableWidgetsColorChatScreen,),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      focusNode: _textFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Type message here...',
                        hintStyle: TextStyle(
                          color: Constants.editableWidgetsColorChatScreen,
                        ),
                      ),
                      onTapOutside: (event){
                        _textFocusNode.unfocus();
                      },
                      onChanged: (value){
                        if(value!=''){
                          setState(() {
                            _isNotTyping = false;
                          });
                        }
                        else{
                          setState(() {
                            _isNotTyping = true;
                          });
                        }
                      },
                      maxLines: null,
                      onTap: (){
                        setState(() {
                          _isAttachButtonPressed = false;
                          _isEmojiKeyboardVisible = false;
                        });

                      },
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                  SizedBox(width: 5,),
                  !_isNotTyping?SizedBox():
                  IconButton(
                    onPressed: (){
                      setState(() {
                        _isEmojiKeyboardVisible = false;
                        _isAttachButtonPressed = !_isAttachButtonPressed;
                      });
                    },
                    //focusNode: ,
                    icon: Icon(Icons.attach_file,color: Constants.editableWidgetsColorChatScreen,),
                  ),
                  SizedBox(width: 5,),
                  !_isNotTyping?SizedBox():
                  IconButton(
                      onPressed: (){
                        Get.to(()=>CameraImagePickerScreen(),
                            arguments: {
                              'pid' : '',
                              'friendUid' : '',
                            });
                      },
                      icon: Icon(Icons.camera_alt,color: Constants.editableWidgetsColorChatScreen,))
                ],
              ),
            ),
          ),
          SizedBox(width: 10,),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 30,
            child: _isNotTyping ? GestureDetector(
              child: Icon(Icons.mic,color: Constants.priColor,),
              onLongPressStart: (_)async{

              },
              onLongPressEnd: (_)async{
                setState(() {

                });
              },
            ) :
            IconButton(
              icon: Icon(Icons.send,color: Constants.priColor,),
              onPressed: ()  {
              },
            ),
          )
        ],
      ),
    );
  }

  Widget AttachButton(double containerHeight) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: _isAttachButtonPressed ? EdgeInsets.all(10) : EdgeInsets.all(0),
      padding: EdgeInsets.all(10),
      height: containerHeight,
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomAttachButton((){
            setState(() {
              _isAttachButtonPressed = false;
            });
            Get.to(()=>FilePickerScreen(isAudio: false,),arguments: {
              'pid' : '',
              'friendUid' : '',
            });
          }, Icons.file_copy,Colors.purple),
          CustomAttachButton((){
            //TODO : on press
            setState(() {
              _isAttachButtonPressed = false;
            });
            Get.to(()=>FilePickerScreen(isAudio: true,),arguments: {
              'pid' : '',
              'friendUid' : '',
            });
          }, Icons.audiotrack,Colors.orange),
          CustomAttachButton(()async{
            setState(() {
              _isAttachButtonPressed = false;
            });
            Get.to(()=>ImagePickerScreen(),arguments: {
              'pid' : '',
              'friendUid' : '',
            });
          }, Icons.photo_library_sharp,Colors.pinkAccent),
        ],
      ),
    );
  }

  Widget EmojiPickerWidget() {
    return _isEmojiKeyboardVisible ? Container(
      height: 270,
      child: EmojiPicker(
        onBackspacePressed: _onBackspacePressed,
        textEditingController: _messageController,
        onEmojiSelected: (event,emoji){
          print(_messageController.text);
        },
        config: Config(
          columns: 7,
          emojiSizeMax: 32.0,
        ),
      ),
    ) :SizedBox();
  }

  Widget MembersScrollView(){
    return Container(
      height: 70,
      decoration: BoxDecoration(
          color: Colors.grey[200]
      ),
      child: ListView.builder(
          itemCount: 10,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context,index){
            return Container(
              padding: EdgeInsets.all(5),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: index%2==0?Colors.lightGreen:Colors.grey[200],
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTDV6AFwPlhFA0lutcscKiTdqI-7Mi8IDjrJeLArcE&s',
                  ),
                  radius: 25,
                ),
              ),
            );
          }
      ),
    );
  }
}
