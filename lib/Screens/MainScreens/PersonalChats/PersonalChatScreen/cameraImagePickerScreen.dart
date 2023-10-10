import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:get/get.dart';

import '../../../../Utils/constants.dart';

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

  Future<void> _captureImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _capturedImage = image;
      });
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
                  color: Colors.black.withOpacity(0.5),
                ),
                child: TextField(
                  focusNode: _captionFocusNode,
                  controller: _captionController,
                  onTapOutside: (event){
                    _captionFocusNode.unfocus();
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Add a caption',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                ),
              ),
            ),
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
                          // Send _selectedImages and their captions
                          // Implement your send logic here
                          // For this example, we'll just print the selectedImages and captions
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
