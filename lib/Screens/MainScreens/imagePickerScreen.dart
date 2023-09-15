import 'package:fire_app/Screens/MainScreens/personalChatScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../Utils/constants.dart';
import '../../Utils/imageData.dart';

class ImagePickerScreen extends StatefulWidget {
  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  List<ImageData> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  FocusNode _captionFocusNode = FocusNode();
  List <TextEditingController> _captionControllers = <TextEditingController>[];
  DatabaseReference messageRef = FirebaseDatabase.instance.ref('personalChats').child(Get.arguments['pid']);
  final storageRef = FirebaseStorage.instance.ref('personalChatData').child(Get.arguments['pid']);

  Future<void> _pickImages() async {
    final images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _selectedImages.addAll(images.map((image)
        {
          _captionControllers.add(TextEditingController());
          return ImageData(imagePath: image.path);
        }));
      });
    }
  }

  Future<void> _sendImages() async{
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context)=> Center(child: SpinKitRing(color: Constants.priColor)),
    );
    _selectedImages.forEach((element) async {
      final newMessageKey = messageRef.child('messages').push();
      final messageKey = newMessageKey.key;
      // final task = await storageRef.child("Images").child(messageKey!).putFile(File(element.imagePath));
      // String imageURL = await task.ref.getDownloadURL();
      newMessageKey.set({
        'sender' : FirebaseAuth.instance.currentUser?.uid,
        'content' : {
          'imageURL' : element.imagePath,
          'caption' : element.caption,
        },
        'timestamp' : DateTime.now().millisecondsSinceEpoch.toString(),
        'type' : 'imageUploading',
      });
    });
    Get.back();
    Get.back();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pickImages();
    _captionControllers.add(TextEditingController());
  }

  Widget _buildImagePreview() {
    return PageView.builder(
      reverse: false,
      itemCount: _selectedImages.length,
      itemBuilder: (context, index) {
        final imageData = _selectedImages[index];
        return Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: double.infinity,
                child: Image.file(
                  File(imageData.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            _selectedImages.length>1 && index != _selectedImages.length-1 ?
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 70,
                margin: EdgeInsets.only(right: 10),
                width: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withOpacity(0.5)
                ),
                  child: Icon(Icons.arrow_forward_ios,color: Constants.secColor,size: 15,)),
            ) : SizedBox(),
            index != 0 ?
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  height: 70,
                  margin: EdgeInsets.only(left: 10),
                  width: 20,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black.withOpacity(0.5)
                  ),
                  child: Icon(Icons.arrow_back_ios,color: Constants.secColor,size: 15,)),
            ) : SizedBox(),
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
                  controller: _captionControllers[index],
                  onChanged: (text) {
                    setState(() {
                      imageData.caption = text;
                    });
                  },
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
              right: 16.0,
              child: InkWell(
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                onTap: () {
                  setState(() {
                    _selectedImages.removeAt(index);
                  });
                },
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
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            _buildImagePreview(),
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
                        child: Icon(Icons.add_photo_alternate, color: Colors.white),
                      ),
                      onTap: _pickImages,
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
                          _sendImages();
                        },
                        child: Text('Send Images',style: TextStyle(color: Constants.secColor),),
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _captionControllers.forEach((element) {
      element.dispose();
    });
  }
}
