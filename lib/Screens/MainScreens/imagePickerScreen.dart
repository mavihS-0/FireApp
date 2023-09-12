import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:get/get.dart';

import '../../Utils/constants.dart';

class ImageData {
  final String imagePath;
  String caption;

  ImageData({required this.imagePath, this.caption = ''});
}

class ImagePickerScreen extends StatefulWidget {
  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  List<ImageData> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  FocusNode _captionFocusNode = FocusNode();

  Future<void> _pickImages() async {
    final images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _selectedImages.addAll(images.map((image) => ImageData(imagePath: image.path)));
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pickImages();
  }

  Widget _buildImagePreview() {
    return PageView.builder(
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
                          _selectedImages.forEach((imageData) {
                            print('Image Path: ${imageData.imagePath}');
                            print('Caption: ${imageData.caption}');
                          });
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

}
