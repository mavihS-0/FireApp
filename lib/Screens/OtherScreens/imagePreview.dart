import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Utils/constants.dart';

//screen for previewing image in full screen (on tap)
class ImagePreview extends StatelessWidget {
  const ImagePreview({Key? key}) : super(key: key);

  //fucntion to download image
  Future<void> downloadFile(String fileName) async {
    Directory? directory;
    Get.back();
    try{
      //path for emulator and android device
      directory = Directory('/sdcard/Download');

      //path for real device (ios)
      //directory = await getApplicationDocumentsDirectory();

      String filePath = '${directory!.path}/$fileName';
      print(Get.arguments['imageURL']);
      final httpsReference = FirebaseStorage.instance.refFromURL(Get.arguments['imageURL']);
      await httpsReference.getMetadata().then((value) => filePath+='.${value.name.split('.').last}');
      final file = File(filePath);
      await httpsReference.writeToFile(file);
      Get.snackbar("Download Complete", 'File downloaded successfully');
    }catch(e){
      Get.snackbar("Error downloading file",e.toString(),duration: Duration(seconds: 5));
    }
    return ;
  }

  //function for showing dialog box for downloading file with text-field for file name
  void onDownloadButtonPress(BuildContext context){
    TextEditingController _fileNameController = TextEditingController();
    FocusNode _fileNameFocusNode = FocusNode();
    showDialog(context: context, builder: (context){
      return AlertDialog(
        backgroundColor: Constants.secColor,
        title: Text('Download',textAlign: TextAlign.center, style: TextStyle(
            fontWeight: FontWeight.w600
        ),),
        content: TextField(
          decoration: InputDecoration(
              hintText: 'Enter file name'
          ),
          controller: _fileNameController,
          focusNode: _fileNameFocusNode,
          onTapOutside: (event){
            _fileNameFocusNode.unfocus();
          },
        ),
        actions: [
          OutlinedButton(
            onPressed: (){
              Get.back();
            },
            child: Text('Cancel'),
            style: ButtonStyle(
              foregroundColor: MaterialStatePropertyAll<Color?>(Constants.priColor),
              side: MaterialStatePropertyAll<BorderSide?>(BorderSide(
                width: 1.0,
                color: Colors.blue,
                style: BorderStyle.solid,
              ),),
              fixedSize: MaterialStatePropertyAll<Size?>(Size.fromHeight(50)),
            ),
          ),
          SizedBox(width: 10,),
          FilledButton(
            onPressed: (){
              downloadFile(_fileNameController.text);
              _fileNameController.dispose();
            },
            child: Text('Download'),
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color?>(Constants.priColor),
              fixedSize: MaterialStatePropertyAll<Size?>(Size.fromHeight(50)),
            ),
          )
        ],
        actionsAlignment: MainAxisAlignment.center,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Media Preview'),
        actions: [
          IconButton(onPressed: (){
            onDownloadButtonPress(context);
          }, icon: Icon(Icons.download))
        ],
      ),
      body: Center(
        child: CachedNetworkImage(imageUrl: Get.arguments['imageURL'], fit: BoxFit.fill, width: double.infinity,),
      ),
    );
  }
}
