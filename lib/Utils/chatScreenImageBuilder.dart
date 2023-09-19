import 'dart:ui';

import 'package:file_saver/file_saver.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'constants.dart';

class ChatScreenImageBuilder extends StatefulWidget {
  final Map imageData;
  final String mid;
  final String pid;
  const ChatScreenImageBuilder({Key? key, required this.imageData,required this.pid,required this.mid}) : super(key: key);

  @override
  State<ChatScreenImageBuilder> createState() => _ChatScreenImageBuilderState();
}

class _ChatScreenImageBuilderState extends State<ChatScreenImageBuilder> {

  bool isLoading = true;
  var imageDataBox = Hive.box('imageData');
  String _filePath='';

  Future<void> getImageFile()  async {
    try{
      String filePath = await imageDataBox.get('chats')['images']['${widget.pid}+${widget.mid}'];
      setState(() {
        _filePath = filePath;
        isLoading = false;
      });
    }catch(e){
      Map presentData = imageDataBox.get('chats');
      Map dataIndices = imageDataBox.get('indices');
      print(presentData);
      final httpsReference = FirebaseStorage.instance.refFromURL(widget.imageData['content']['imageURL']);
      final appDocDir = await getApplicationDocumentsDirectory();
      dataIndices['chatImageCounter'] += 1;
      String filePath = '${appDocDir.path}/Media/images/FireAppIMG${dataIndices['chatImageCounter']}';
      final file = File(filePath);
      await httpsReference.writeToFile(file);
      presentData['images']['${widget.pid}+${widget.mid}'] = filePath;
      await imageDataBox.put('chats', presentData);
      await imageDataBox.put('incides',dataIndices);
      setState(() {
        _filePath = filePath;
        isLoading = false;
      });
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImageFile();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5,),
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                children: [
                  Container(
                      height: 200,
                      width: 200,
                      color: Colors.black.withOpacity(0.4)
                  ),
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: const SizedBox(),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Constants.priColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 5,),
        Text(widget.imageData['content']['caption'])
      ],
    ):
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5,),
        ClipRRect(
          child: Image.file(File(_filePath)),
          borderRadius: BorderRadius.circular(15),
        ),
        SizedBox(height: 5,),
        Text(widget.imageData['content']['caption']),
        // IconButton(onPressed: (){
        //   print(_filePath);
        //   String images = imageDataBox.get('chats')['images'][widget.pid+'+'+widget.mid];
        //   print(widget.mid);
        //   print(images);
        // }, icon: Icon(Icons.add))
      ],
    );
  }
}
