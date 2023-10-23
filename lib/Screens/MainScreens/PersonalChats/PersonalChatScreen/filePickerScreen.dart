import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import '../../../../Utils/constants.dart';

//screen for picking files
class FilePickerScreen extends StatefulWidget {
  final bool isAudio;
  const FilePickerScreen({Key? key, required this.isAudio}) : super(key: key);

  @override
  State<FilePickerScreen> createState() => _FilePickerScreenState();
}

class _FilePickerScreenState extends State<FilePickerScreen> {
  List<PlatformFile> _selectedFiles = [];
  DatabaseReference messageRef = FirebaseDatabase.instance.ref('personalChats').child(Get.arguments['pid']);

  //send file instances to firebase (if audio: audioUploading, else: fileUploading)
  Future<void> _sendFiles() async{
    _selectedFiles.forEach((element) async {
      final newMessageKey = messageRef.child('messages').push();
      final messageKey = newMessageKey.key;
      await newMessageKey.set({
        'sender' : FirebaseAuth.instance.currentUser?.uid,
        'content' : {
          'fileURL' : element.path,
          'fileName' : element.name,
        },
        'timestamp' : DateTime.now().millisecondsSinceEpoch.toString(),
        'type' : widget.isAudio?'audioUploading':'fileUploading',
      });
    });
    Get.back();
  }

  //pick files from device
  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        //extensions for audio/files
        allowedExtensions: widget.isAudio ? ['wav','mp3']:['pdf', 'doc', 'docx', 'txt'], // Customize the allowed file types
        allowMultiple: true, // Allow multiple file selection
      );

      if (result != null) {
        setState(() {
          result.files.forEach((element) {
            _selectedFiles.add(element);
          });
        });
      }else{
        Get.back();
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pickFiles();
  }

  //delete file from list
  void _deleteFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            //close button
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0,left: 15,right: 15,bottom: 10),
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
            ),
            //list of selected files
            Expanded(
              child: ListView.builder(
                itemCount: _selectedFiles.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Constants.chatBubbleColor,
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Text(_selectedFiles[index].name)),
                        SizedBox(width: 10,),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteFile(index),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: <Widget>[
                  //add more files
                  InkWell(
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.black.withOpacity(0.5),
                      child: Icon(Icons.add_outlined, color: Colors.white),
                    ),
                    onTap: _pickFiles,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  //send files
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _sendFiles,
                      child: Text('Send Files',style: TextStyle(color: Constants.secColor),),
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Constants.priColor),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
