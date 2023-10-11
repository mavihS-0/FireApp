import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../constants.dart';
import 'package:get/get.dart';

class ChatListProfileIconBuilder extends StatefulWidget {
  final Map userData;
  final String pid;
  const ChatListProfileIconBuilder({Key? key, required this.userData, required this.pid}) : super(key: key);

  @override
  State<ChatListProfileIconBuilder> createState() => _ChatListProfileIconBuilderState();
}

class _ChatListProfileIconBuilderState extends State<ChatListProfileIconBuilder> {
  bool isLoading = true;
  var imageDataBox = Hive.box('imageData');
  String _filePath = '';


  Future<void> getImageFile()  async {
    try{
      Map presentData = await imageDataBox.get('profileIcons');
      if(presentData.containsKey(widget.pid)){
        if(presentData[widget.pid]['web']==widget.userData['profileImg']){
          setState(() {
            _filePath = presentData[widget.pid]['local'];
            isLoading = false;
          });
        }
        else{
          String filePath = presentData[widget.pid]['local'];
          final httpsReference = FirebaseStorage.instance.refFromURL(widget.userData['profileImg']);
          final file = File(filePath);
          await httpsReference.writeToFile(file);
          presentData[widget.pid]['web'] = widget.userData['profileImg'];
          await imageDataBox.put('profileIcons', presentData);
          setState(() {
            _filePath = filePath;
            isLoading = false;
          });
        }
      }else{
        Map dataIndices = imageDataBox.get('indices');
        final httpsReference = FirebaseStorage.instance.refFromURL(widget.userData['profileImg']);
        final appDocDir = await getApplicationDocumentsDirectory();
        dataIndices['profileIconCounter'] += 1;
        String filePath = '${appDocDir.path}/Media/profileIcons/FireAppIMG${dataIndices['profileIconCounter']}';
        final file = File(filePath);
        await httpsReference.writeToFile(file);
        presentData[widget.pid] = {
          'local' : filePath,
          'web' : widget.userData['profileImg']
        };
        await imageDataBox.put('profileIcons', presentData);
        await imageDataBox.put('incides',dataIndices);
        setState(() {
          _filePath = filePath;
          isLoading = false;
        });
      }
    }catch(e){
      Get.snackbar('Error', e.toString());
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
    return Container(
      child: isLoading?SizedBox(
        height: 50,
        width: 50,
        child: SpinKitRing(color: Constants.priColor,size: 25,lineWidth: 4,),
      ):
      Image.file(
        File(_filePath),
        height: 50,
        width: 50,
        fit: BoxFit.cover,
        ),
    );
  }
}
