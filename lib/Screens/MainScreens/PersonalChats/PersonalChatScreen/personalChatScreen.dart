import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fire_app/Screens/MainScreens/PersonalChats/PersonalChatScreen/cameraImagePickerScreen.dart';
import 'package:fire_app/Screens/MainScreens/test.dart';
import 'package:fire_app/Utils/audioUtil/audioRecord.dart';
import 'package:fire_app/Utils/audioUtil/chatScreenAudioWidget.dart';
import 'package:fire_app/Utils/audioUtil/uploadingAudioWidget.dart';
import 'package:fire_app/Utils/fileUtil/chatScreenFileWidget.dart';
import 'package:fire_app/Utils/imageUtil/chatImageUtil.dart';
import 'package:fire_app/Utils/noDataHomePage.dart';
import 'package:fire_app/Utils/popUpMenu.dart';
import 'package:fire_app/Utils/fileUtil/uploadingFileBuilder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_record/flutter_sound_record.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../Utils/constants.dart';
import '../../../../Utils/customAttachButtonType.dart';
import '../../../../Utils/imageUtil/uploadingImageBuilder.dart';
import 'filePickerScreen.dart';
import 'imagePickerScreen.dart';
import 'dart:io';

class PersonalChatScreen extends StatefulWidget {
  const PersonalChatScreen({Key? key}) : super(key: key);

  @override
  State<PersonalChatScreen> createState() => _PersonalChatScreenState();
}

class _PersonalChatScreenState extends State<PersonalChatScreen> with AutomaticKeepAliveClientMixin<PersonalChatScreen> {

  DatabaseReference userDataRef = FirebaseDatabase.instance.ref('users').child(Get.arguments['friendUid']);
  TextEditingController message = TextEditingController();
  DatabaseReference messageRef = FirebaseDatabase.instance.ref('personalChats').child(Get.arguments['pid']);
  String? myUid = FirebaseAuth.instance.currentUser?.uid;
  String recName = '...';
  // String recProfileImg =Hive.box('imageData').get('profileIcons')[Get.arguments['pid']]['local'];
  String myName = '...';
  String recProfileImg = 'https://firebasestorage.googleapis.com/v0/b/fireapp-a5221.appspot.com/o/new_profile.png?alt=media&token=00795532-a3e8-4088-b335-ce23ee6750d3&_gl=1*1rqbd46*_ga*MTk4NjQ4MTI2OC4xNjg3Njk1MDg2*_ga_CW55HF8NVT*MTY5Nzg2ODYwNy4xMC4xLjE2OTc4Njg3MTguMTYuMC4w';
  final ScrollController _scrollController = ScrollController();
  bool emojiKeyboard = false;
  Map <dynamic,dynamic> messageData = {};
  final FocusNode _textFocusNode = FocusNode();
  bool _isEmojiKeyboardVisible = false;
  bool _isNotTyping = true;
  bool _isAttachButtonPressed = false;
  bool _isRecording = false;
  bool _isRecorded = false;
  //final FlutterSoundRecord recorder = FlutterSoundRecord();
  AudioRecordUtil audioUtil = AudioRecordUtil();
  ChatImageUtil chatImageUtil = ChatImageUtil();


  Future <void> getUserData()async{
    final snapshot = await FirebaseDatabase.instance.ref('users').child(myUid!).child('name').get();
    if(snapshot.exists){
      myName = snapshot.value.toString();
    }
    setState(() {
    });
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
            Get.to(()=>FilePickerScreen(),arguments: {
              'pid' : Get.arguments['pid'],
              'friendUid' : Get.arguments['friendUid'],
            });
          }, Icons.file_copy,Colors.purple),
          CustomAttachButton((){
            //TODO : on press
          }, Icons.audiotrack,Colors.orange),
          CustomAttachButton(()async{
            setState(() {
              _isAttachButtonPressed = false;
            });
            Get.to(()=>ImagePickerScreen(),arguments: {
              'pid' : Get.arguments['pid'],
              'friendUid' : Get.arguments['friendUid'],
            });
          }, Icons.photo_library_sharp,Colors.pinkAccent),
        ],
      ),
    );
  }

  Map orderData(messages){
    List list = messages.entries.toList();
    list.sort((a, b) => a.value['timestamp'].compareTo(b.value['timestamp']));
    Map sortedMessages = {};
    for (var entry in list) {
      sortedMessages[entry.key] = entry.value;
    }
    return sortedMessages;
  }

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

  void _onEmojiSelected(Category? category, Emoji? emoji) {
    if (emoji != null) {
      message.text += emoji.emoji;
    }
  }

  void onSend(String type)async{
    setState(() {
      _isNotTyping=true;
    });
    final newMessageKey = messageRef.child('messages').push();
    final messageKey = newMessageKey.key;
    final messageText = message.text;
    message.clear();
    await newMessageKey.set({
      'sender' : FirebaseAuth.instance.currentUser?.uid,
      'content' : messageText,
      'timestamp' : DateTime.now().millisecondsSinceEpoch.toString(),
      'type' : type
    });
    await FirebaseDatabase.instance.ref('personalChatList').child(FirebaseAuth.instance.currentUser!.uid).child(Get.arguments['friendUid']).update({
      'lastMessage' : messageText,
      'time' : DateTime.now().toString(),
    });
    await FirebaseDatabase.instance.ref('personalChatList').child(Get.arguments['friendUid']).child(FirebaseAuth.instance.currentUser!.uid).update({
      'lastMessage' : messageText,
      'time' : DateTime.now().toString(),
    });
    //_scrollToBottom();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //recorder.dispose();
    //chatImageUtil.dispose();
    audioUtil.dispose();
  }


  Widget chatInput() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        RecordingPreview(containerHeight: _isRecorded?70:0, audioUtil: audioUtil,pid: Get.arguments['pid'],),
        AttachButton(_isAttachButtonPressed ? 90:0,),
        Container(
          padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
          height: 70,
          width: MediaQuery.of(context).size.width,
          color: Colors.blue,
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
                          _toggleKeyboard();
                        },
                        icon: Icon(_isEmojiKeyboardVisible?Icons.keyboard : Icons.emoji_emotions_rounded,color: Constants.editableWidgetsColorChatScreen,),
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        child: TextField(
                          controller: message,
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
                            Get.to(()=>CameraImagePickerScreen(),
                                arguments: {
                                  'pid' : Get.arguments['pid'],
                                  'friendUid' : Get.arguments['friendUid'],
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
                  child: Icon(Icons.mic,color: Colors.blue,),
                  onLongPressStart: (_)async{
                    // setState(() {
                    //   _isRecorded = false;
                    // });
                    //
                    // audioUtil.startRecording(recorder);
                  },
                  onLongPressEnd: (_)async{
                    // await audioUtil.stopRecording(recorder);
                    // await audioUtil.setAudio();
                    // setState(() {
                    //   _isRecorded = true;
                    // });
                    // audioUtil.uploadAudioInstance(messageRef);
                  },
                ) :
                IconButton(
                  icon: Icon(Icons.send,color: Colors.blue,),
                  onPressed: ()  {
                      onSend('text');
                  },
                ),
              )
            ],
          ),
        ),
        _isEmojiKeyboardVisible ? Container(
          height: 270,
          child: EmojiPicker(
            onEmojiSelected: _onEmojiSelected,
            config: Config(
              columns: 7,
              emojiSizeMax: 32.0,
            ),
          ),
        ) :SizedBox(),
      ],
    );
  }

  // Future <void> saveImagesToLocal()async{
  //   var dataBox = Hive.box('imageData');
  //   Map presentData = dataBox.get('chats');
  //   Map dataIndices = dataBox.get('indices');
  //   String pid = Get.arguments['pid'];
  //   chatImageUtil.notSavedToLocal.forEach((key, value) async {
  //     final httpsReference = FirebaseStorage.instance.refFromURL(chatImageUtil.notSavedToLocal[key]);
  //     final appDocDir = await getApplicationDocumentsDirectory();
  //     dataIndices['chatImageCounter'] += 1;
  //     String filePath = '${appDocDir.path}/Media/images/FireAppIMG${dataIndices['chatImageCounter']}';
  //     final file = File(filePath);
  //     await httpsReference.writeToFile(file);
  //     presentData['images']['$pid+$key'] = filePath;
  //   });
  //   await dataBox.put('chats', presentData);
  //   await dataBox.put('incides',dataIndices);
  //   setState(() {
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
                Get.back();
            },
          ),
          StreamBuilder(
            stream: userDataRef.onValue,
            builder: (context,snapshot){
              if(snapshot.hasData){
                final userData = Map<dynamic, dynamic>.from(
                    (snapshot.data! as DatabaseEvent).snapshot.value
                    as Map<dynamic, dynamic>);
                // recName = userData['name'];
                recProfileImg = userData['profileImg'];
                return Row(
                  children: [
                    SizedBox(width: 5,),
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: userData['profileImg'],
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
                          Text(userData['name'],style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),),
                          //TODO: user status
                          Text('Online',style: TextStyle(
                              fontSize: 12
                          ),),
                        ],
                      ),
                    ),
                  ],
                );
              }
              else{
                return Center(child: SpinKitThreeBounce(color: Constants.priColor,),);
              }
            },
          ),
          Expanded(child: SizedBox()),
          customPopUpMenu('hello', (){

          }),
        ],
      ),
      body: GestureDetector(
        onTap: (){
          setState(() {
            _isAttachButtonPressed = false;
            _isRecorded = false;
          });
        },
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height-(56+MediaQuery.of(context).padding.top),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: messageRef.child('messages').orderByChild('timestamp').onValue,
                    builder: (context, snapshot2){
                      try{
                        if(snapshot2.hasData){
                          messageData = Map<dynamic, dynamic>.from(
                              (snapshot2.data!).snapshot.value
                              as Map<dynamic, dynamic>);
                          messageData = orderData(messageData);
                          List messageIds = messageData.keys.toList().reversed.toList();
                          // chatImageUtil.getLocal(messageData,Get.arguments['pid']);
                          // saveImagesToLocal();
                          return SingleChildScrollView(
                            reverse: true,
                            child: Container(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: messageData.length,
                                  shrinkWrap: true,
                                  reverse: true,
                                  addAutomaticKeepAlives: true,
                                  //initialScrollIndex: messageData.length,
                                  // itemScrollController: _scrollController,
                                  //controller: _scrollController,
                                  itemBuilder: (context,index){
                                    return Container(
                                        padding: EdgeInsets.all(10),
                                        child: messageData[messageIds[index]]['sender']!=myUid?
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: CachedNetworkImageProvider(recProfileImg),
                                              radius: 15,
                                            ),
                                            SizedBox(width: 10,),
                                            Container(
                                              width: MediaQuery.of(context).size.width*0.7,
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Constants.chatBubbleColor,
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.zero,
                                                    topRight: Radius.circular(10),
                                                    bottomRight:  Radius.circular(10),
                                                    bottomLeft:  Radius.circular(10)),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(recName,style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Constants.senderNameColor,
                                                  ),),
                                                  messageData[messageIds[index]]['type']=='text'?
                                                  Text(messageData[messageIds[index]]['content'],style: TextStyle(
                                                    fontSize: Constants.mediumFontSize
                                                  ),):
                                                  messageData[messageIds[index]]['type']=='image'?
                                                  chatImageUtil.chatScreenImageBuilder(messageData[messageIds[index]], messageIds[index]) :
                                                  messageData[messageIds[index]]['type']=='imageUploading'?
                                                  chatImageUtil.imageUploading(messageData[messageIds[index]]):
                                                  messageData[messageIds[index]]['type']=='file'?
                                                  ChatScreenFileWidget(fileData: messageData[messageIds[index]]) : SizedBox(),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text(timestampToTime(int.parse(messageData[messageIds[index]]['timestamp'])), style: TextStyle(
                                                          color: Constants.senderNameColor,
                                                          fontWeight: FontWeight.w400,
                                                        fontSize: Constants.timeFontSize
                                                      ),),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ):
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context).size.width*0.7,
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: Constants.chatBubbleColor,
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(10),
                                                        topRight: Radius.zero,
                                                        bottomRight:  Radius.circular(10),
                                                        bottomLeft:  Radius.circular(10)),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(myName,style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          color: Constants.senderNameColor,
                                                      ),),
                                                      messageData[messageIds[index]]['type']=='text'?
                                                      Text(messageData[messageIds[index]]['content'],style: TextStyle(
                                                          fontSize: Constants.mediumFontSize
                                                      ),):
                                                      messageData[messageIds[index]]['type']=='image'?
                                                      chatImageUtil.chatScreenImageBuilder(messageData[messageIds[index]], messageIds[index]) :
                                                      messageData[messageIds[index]]['type']=='imageUploading'?
                                                      UploadingImageBuilder(imageData: messageData[messageIds[index]],mid: messageIds[index], pid: Get.arguments['pid'],friendUid: Get.arguments['friendUid'],) :
                                                      messageData[messageIds[index]]['type']=='fileUploading'?
                                                      UploadingFileBuilder(fileData: messageData[messageIds[index]], mid: messageIds[index], pid: Get.arguments['pid'], friendUid: Get.arguments['friendUid']):
                                                      messageData[messageIds[index]]['type']=='file'?
                                                      ChatScreenFileWidget(fileData: messageData[messageIds[index]]):
                                                      messageData[messageIds[index]]['type']=='audio' ? messageData[messageIds[index]]['status']=='uploading'?
                                                      UploadingAudioWidget(audioData: messageData[messageIds[index]], mid: messageIds[index], pid: Get.arguments['pid'],friendUid: Get.arguments['friendUid'])
                                                      : ChatScreenAudioWidget(audioData: messageData[messageIds[index]]) : SizedBox(),
                                                      // ChatScreenAudioWidget(audioData: messageData[messageIds[index]],mid: messageIds[index], pid: Get.arguments['pid'], friendUid: Get.arguments['friendUid']) : SizedBox(),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Text(timestampToTime(int.parse(messageData[messageIds[index]]['timestamp'])), style: TextStyle(
                                                              color: Constants.senderNameColor,
                                                              fontWeight: FontWeight.w400,
                                                            fontSize: Constants.timeFontSize
                                                          ),),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 10,),
                                                CircleAvatar(
                                                  backgroundImage: CachedNetworkImageProvider(recProfileImg),
                                                  radius: 10,
                                                )
                                              ],
                                            ),

                                          ],
                                        )
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        }
                        else{
                          return Container(
                            child: Text('...'),
                          );
                        }
                      }catch(e){
                        print(e.toString());
                        return const NoDataHomePage(caption: 'Start a conversation');
                      }
                    },
                  ),
                ),
                chatInput(),

              ],
            ),
          ),
        ),
      )
    );

  }
  @override
  bool get wantKeepAlive => true;

  String timestampToTime(int timestamp) {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final String formattedTime = DateFormat.jm().format(dateTime); // 'jm' stands for 12-hour format
    return formattedTime;
  }
}
