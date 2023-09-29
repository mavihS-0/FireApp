import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatScreenFileWidget extends StatelessWidget {
  final Map fileData;
  const ChatScreenFileWidget({Key? key, required this.fileData}) : super(key: key);

  Future<void> downloadFile() async {
    Directory? directory;
    try{
      directory = Directory('${(await getApplicationDocumentsDirectory()).path}/Downloads');
      if(!await directory.exists()) directory.create();
      directory = Directory('${directory.path}/Files');
      if(!await directory.exists()) directory.create();
      String filePath = '${directory!.path}/${fileData['content']['fileName']}';
      final file = File(filePath);
      final httpsReference = FirebaseStorage.instance.refFromURL(fileData['content']['fileURL']);
      await httpsReference.writeToFile(file);
      Get.snackbar("Download Complete", 'File downloaded successfully');
    }catch(e){
      Get.snackbar("Error",e.toString());
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
