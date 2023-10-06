import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import 'package:get/get.dart';

import '../constants.dart';

class UploadingAudioWidget extends StatefulWidget {
  final Map audioData;
  final String mid;
  final String pid;
  final String friendUid;
  const UploadingAudioWidget({Key? key, required this.audioData, required this.mid, required this.pid, required this.friendUid}) : super(key: key);

  @override
  State<UploadingAudioWidget> createState() => _UploadingAudioWidgetState();
}

class _UploadingAudioWidgetState extends State<UploadingAudioWidget> {

  bool _uploading = true;
  double _uploadProgress = 0.0;
  UploadTask? _uploadTask;
  String _filePath='';

  Future<void> _uploadAudio(File _file, String mid,String pid, Map fileData,String friendUid) async {
    try {
      final Reference reference = FirebaseStorage.instance.ref('personalChatData').child(pid).child('Audio').child(mid);

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
              'lastMessage' : '[audio]',
              'time' : DateTime.now().toString(),
            });
        await FirebaseDatabase.instance.ref('personalChatList').child(FirebaseAuth.instance.currentUser!.uid).child(friendUid).update(
            {
              'lastMessage' : '[audio]',
              'time' : DateTime.now().toString(),
            });
        await messageRef.child('messages').child(mid).update({
          'sender' : fileData['sender'],
          'content' : {
            'audioURL' : downloadUrl,
          },
          'timestamp' : DateTime.now().millisecondsSinceEpoch.toString(),
          'type' : 'audio',
          'status' : 'sent'
        });
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
      setState(() {
        _uploading = false;
      });
    }
  }

  void _reuploadAudio(File file,String mid,String pid,Map fileData, String friendUid) {
    setState(() {
      _uploading = true;
      _uploadProgress = 0.0;
    });
    _uploadAudio(file,mid,pid,fileData,friendUid);
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
    if(widget.audioData['status']=='uploading'){
      _uploadAudio(File(widget.audioData['content']['audioURL']), widget.mid, widget.pid, widget.audioData, widget.friendUid);
    }
  }

  @override
  Widget build(BuildContext context) {
    Map audioData = widget.audioData;
    String mid = widget.mid;
    String pid = widget.pid;
    String friendUid = widget.friendUid;
    return Row(
      children: [
        SizedBox(width: 10,),
        Expanded(child: Text('Audio')),
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
                  _cancelUpload():_reuploadAudio(File(audioData['content']['audioURL']), mid, pid, audioData,friendUid);
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
