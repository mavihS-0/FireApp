import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fire_app/Utils/chatScreenUtil/chatBubbleContainer.dart';
import 'package:fire_app/Utils/chatScreenUtil/chatBubbleData.dart';
import 'package:fire_app/Utils/chatScreenUtil/chatBubbles/textChatBubble.dart';
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

class _GroupChatScreenState extends State<GroupChatScreen> {

  DummyGroupChatScreenData dummyData = DummyGroupChatScreenData();
  bool _isEmojiKeyboardVisible = false;
  bool _isNotTyping = true;
  bool _isAttachButtonPressed = false;
  TextEditingController _messageController = TextEditingController();
  FocusNode _textFocusNode = FocusNode();

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

  _onBackspacePressed() {
    _messageController
      ..text = _messageController.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _messageController.text.length));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: appBar(),
      ),
      body: GestureDetector(
        onTap: (){
          setState(() {
            _isAttachButtonPressed = false;
            _isEmojiKeyboardVisible = false;
          });
        },
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                child: ListView.builder(
                  itemCount: dummyData.messages.length,
                  reverse: true,
                  itemBuilder: (context,i){
                    int index = dummyData.messages.length - i - 1;
                    bool _isMe = dummyData.messages[index]['sender'] == 'Me';
                    return ChatBubbleContainer(
                      isMe: _isMe,
                      senderName: dummyData.messages[index]['sender'],
                      time: dummyData.messages[index]['timestamp'],
                      senderProfileURL: dummyData.messages[index]['senderProfileURL'],
                      child: ChatBubbleData(
                        type: dummyData.messages[index]['type'],
                        content: dummyData.messages[index]['content'],
                      ),
                      viewedBy: dummyData.messages[index]['viewedBy'],
                    );
                  },
                ),
              ),
            ),
            AttachButton(_isAttachButtonPressed ? 90:0,),
            ChatInput(),
            EmojiPickerWidget()
          ],
        ),
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
      Row(
        children: [
          SizedBox(width: 5,),
          ClipOval(
            child: Image.network(
              dummyData.groupIcon,
              height: 40,
              width: 40,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10,),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(dummyData.name,style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),),
                //TODO: user status
                Text(dummyData.participants.toString().substring(1,dummyData.participants.toString().length-1),style: TextStyle(
                    fontSize: 12
                ),),
              ],
            ),
          ),
        ],
      ),
      Expanded(child: SizedBox()),
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
      margin: EdgeInsets.all(10),
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
          }, Icons.file_copy,Colors.purple),
          CustomAttachButton((){
            //TODO : on press

          }, Icons.audiotrack,Colors.orange),
          CustomAttachButton(()async{
            setState(() {
              _isAttachButtonPressed = false;
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
        config: Config(
          columns: 7,
          emojiSizeMax: 32.0,
        ),
      ),
    ) :SizedBox();
  }
}
