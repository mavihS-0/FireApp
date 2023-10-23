import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:get/get.dart';

import '../../../../Utils/constants.dart';

//screen for capturing image from camera and initiating an instance of it in chat
class CameraImagePickerScreen extends StatefulWidget {
  const CameraImagePickerScreen({Key? key}) : super(key: key);
  
  @override
  State<CameraImagePickerScreen> createState() => _CameraImagePickerScreenState();
}

class _CameraImagePickerScreenState extends State<CameraImagePickerScreen> {
  XFile? _capturedImage;
  final TextEditingController _captionController = TextEditingController();
  final FocusNode _captionFocusNode = FocusNode();
  DatabaseReference messageRef = FirebaseDatabase.instance.ref('personalChats').child(Get.arguments['pid']);
  final storageRef = FirebaseStorage.instance.ref('personalChatData').child(Get.arguments['pid']);

  //capturing image from camera
  Future<void> _captureImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _capturedImage = image;
      });
    }else{
      Get.back();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _captureImage();
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  //creating image instance in firebase
  Future<void> _sendImage() async{
    if(_capturedImage != null) {
      final newMessageKey = messageRef.child('messages').push();
      final messageKey = newMessageKey.key;
      await newMessageKey.set({
        'sender' : FirebaseAuth.instance.currentUser?.uid,
        'content' : {
          'imageURL' : _capturedImage?.path,
          'caption' : _captionController.text,
        },
        'timestamp' : DateTime.now().millisecondsSinceEpoch.toString(),
        'type' : 'imageUploading',
      });
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            //null check for image
            _capturedImage!=null?
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: double.infinity,
                child: Image.file(
                  File(_capturedImage!.path),
                  fit: BoxFit.cover,
                ),
              ),
            ):SizedBox(),
            Positioned(
              bottom: 70,
              left: 0,
              right: 0,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Constants.FGcolor.withOpacity(0.5),
                ),
                child: TextField(
                  focusNode: _captionFocusNode,
                  controller: _captionController,
                  onTapOutside: (event){
                    _captionFocusNode.unfocus();
                  },
                  style: TextStyle(color: Constants.secColor),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Add a caption',
                    hintStyle: TextStyle(color: Constants.secColor.withOpacity(0.7)),
                  ),
                ),
              ),
            ),

            //close button
            Positioned(
              top: 16.0,
              left: 16.0,
              child: InkWell(
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  child: Icon(Icons.close, color: Colors.white),
                ),
                onTap: () {
                  Get.back();
                },
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 70,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: <Widget>[
                    InkWell(

                      //recapture image
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.black.withOpacity(0.5),
                        child: Icon(Icons.camera_alt, color: Colors.white),
                      ),
                      onTap: _captureImage,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _sendImage();
                        },
                        child: Text('Send Image',style: TextStyle(color: Constants.secColor),),
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Constants.priColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}
