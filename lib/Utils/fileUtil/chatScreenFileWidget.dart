import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class ChatScreenFileWidget extends StatelessWidget {
  final Map fileData;
  const ChatScreenFileWidget({Key? key, required this.fileData}) : super(key: key);

  Future<void> downloadFile() async {
    Directory? directory;
    try{
      //path for emulator
      directory = Directory('/sdcard/Download');

      //path for real device (android)
      //directory = Directory('/storage/emulated/0/Download');

      //path for real device (ios)
      //directory = await getApplicationDocumentsDirectory();

      String filePath = '${directory!.path}/${fileData['content']['fileName']}';
      final file = File(filePath);
      final httpsReference = FirebaseStorage.instance.refFromURL(fileData['content']['fileURL']);
      await httpsReference.getMetadata().then((value) => filePath+='.${value.name.split('.').last}');
      await httpsReference.writeToFile(file);
      Get.snackbar("Download Complete", 'File downloaded successfully');
    }catch(e){
      Get.snackbar("Error",e.toString(),duration: Duration(seconds: 5));
    }
    return ;
  }


  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        SizedBox(width: 10,),
        Expanded(child: Text(fileData['content']['fileName'])),
        SizedBox(width: 10,),
        SizedBox(
            height: 50,
            width: 50,
            child: IconButton(
              icon: Icon(Icons.download),
              onPressed: ()async {
                downloadFile();
              },
            )
        )
      ],
    );
  }
}
