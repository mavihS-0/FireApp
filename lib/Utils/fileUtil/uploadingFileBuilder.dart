import 'dart:ui';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../constants.dart';

class UploadingFileBuilder extends StatefulWidget {
  final Map fileData;
  final String mid;
  final String pid;
  final String friendUid;
  const UploadingFileBuilder({Key? key, required this.fileData, required this.mid, required this.pid, required this.friendUid}) : super(key: key);

  @override
  State<UploadingFileBuilder> createState() => _UploadingFileBuilderState();
}

class _UploadingFileBuilderState extends State<UploadingFileBuilder> {

  bool _uploading = true;
  double _uploadProgress = 0.0;
  UploadTask? _uploadTask;
  String _filePath='';

  Future<void> _uploadImage(File _file, String mid,String pid, Map fileData,String friendUid) async {
    try {
      final Reference reference = FirebaseStorage.instance.ref('personalChatData').child(pid).child('Files').child(mid);

      _uploadTask = reference.putFile(
          _file
      );

      _uploadTask!.snapshotEvents.listen((event) {
        setState(() {
          _uploadProgress = event.bytesTransferred / event.totalBytes;
        });
      });

      await _uploadTask!.whenComplete(() async {
        String downloadUrl = await reference.getDownloadURL();
        DatabaseReference messageRef = FirebaseDatabase.instance.ref('personalChats').child(pid);

        await FirebaseDatabase.instance.ref('personalChatList').child(friendUid).child(FirebaseAuth.instance.currentUser!.uid).update(
            {
              'lastMessage' : '[file] ${fileData['content']['fileName']}',
              'time' : DateTime.now().toString(),
            });
        await FirebaseDatabase.instance.ref('personalChatList').child(FirebaseAuth.instance.currentUser!.uid).child(friendUid).update(
            {
              'lastMessage' : '[file] ${fileData['content']['fileName']}',
              'time' : DateTime.now().toString(),
            });
        await messageRef.child('messages').child(mid).update({
          'sender' : fileData['sender'],
          'content' : {
            'fileURL' : downloadUrl,
            'fileName' : fileData['content']['fileName'],
          },
          'timestamp' : DateTime.now().millisecondsSinceEpoch.toString(),
          'type' : 'file',
        });
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
      setState(() {
        _uploading = false;
      });
    }
  }

  void _reuploadImage(File file,String mid,String pid,Map fileData, String friendUid) {
    setState(() {
      _uploading = true;
      _uploadProgress = 0.0;
    });
    _uploadImage(file,mid,pid,fileData,friendUid);
  }

  void _cancelUpload() {
    if (_uploadTask != null) {
      _uploadTask!.cancel();

    }
    setState(() {
      _uploading = false;
      _uploadProgress = 0.0;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _uploadImage(File(widget.fileData['content']['fileURL']), widget.mid, widget.pid, widget.fileData, widget.friendUid);
  }

  @override
  Widget build(BuildContext context) {
    Map imageData = widget.fileData;
    String mid = widget.mid;
    String pid = widget.pid;
    String friendUid = widget.friendUid;
    return Row(
      children: [
        SizedBox(width: 10,),
        Expanded(child: Text(imageData['content']['fileName'])),
        SizedBox(width: 10,),
        SizedBox(
          height: 50,
          width: 50,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: Constants.priColor,
                  value: _uploadProgress,
                ),
              ),
              IconButton(
                icon: Icon(
                  _uploading?
                  Icons.cancel:Icons.upload),
                onPressed: (){
                  _uploading?
                  _cancelUpload():_reuploadImage(File(imageData['content']['fileURL']), mid, pid, imageData,friendUid);
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}

