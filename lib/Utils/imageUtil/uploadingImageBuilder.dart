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

class UploadingImageBuilder extends StatefulWidget {
  final Map imageData;
  final String mid;
  final String pid;
  final String friendUid;
  const UploadingImageBuilder({Key? key, required this.imageData, required this.mid, required this.pid, required this.friendUid}) : super(key: key);

  @override
  State<UploadingImageBuilder> createState() => _UploadingImageBuilderState();
}

class _UploadingImageBuilderState extends State<UploadingImageBuilder> {

  bool _uploading = true;
  double _uploadProgress = 0.0;
  UploadTask? _uploadTask;
  var imageDataBox = Hive.box('imageData');
  String _filePath='';

  Future<void> _uploadImage(File _imageFile, String mid,String pid, Map imageData,String friendUid) async {
    try {
        final Reference reference = FirebaseStorage.instance.ref('personalChatData').child(pid).child('Images').child(mid);

        _uploadTask = reference.putFile(
          _imageFile
        );

        _uploadTask!.snapshotEvents.listen((event) {
          setState(() {
            _uploadProgress = event.bytesTransferred / event.totalBytes;
          });
        });

        await _uploadTask!.whenComplete(() async {
          String downloadUrl = await reference.getDownloadURL();
          DatabaseReference messageRef = FirebaseDatabase.instance.ref('personalChats').child(pid);
          //
          // Map presentData = await imageDataBox.get('chats');
          // Map dataIndices = await imageDataBox.get('indices');
          // //final httpsReference = FirebaseStorage.instance.refFromURL(widget.imageData['content']['imageURL']);
          // final appDocDir = await getApplicationDocumentsDirectory();
          // dataIndices['chatImageCounter'] += 1;
          // String filePath = '${appDocDir.path}/Media/images/FireAppIMG${dataIndices['chatImageCounter']}';
          // await _imageFile.copy(filePath);
          // presentData['images']['${widget.pid}+${widget.mid}'] = filePath;
          // await imageDataBox.put('chats', presentData);
          // await imageDataBox.put('incides',dataIndices);
          await FirebaseDatabase.instance.ref('personalChatList').child(friendUid).child(FirebaseAuth.instance.currentUser!.uid).update(
              {
                'lastMessage' : '[image] ${imageData['content']['caption']}',
                'time' : DateTime.now().toString(),
              });
          await FirebaseDatabase.instance.ref('personalChatList').child(FirebaseAuth.instance.currentUser!.uid).child(friendUid).update(
              {
                'lastMessage' : '[image] ${imageData['content']['caption']}',
                'time' : DateTime.now().toString(),
              });
          await messageRef.child('messages').child(mid).update({
            'sender' : imageData['sender'],
            'content' : {
              'imageURL' : downloadUrl,
              'caption' : imageData['content']['caption'],
            },
            'timestamp' : DateTime.now().millisecondsSinceEpoch.toString(),
            'type' : 'image',
          });
        });
    } catch (e) {
      Get.snackbar('Error', e.toString());
      setState(() {
        _uploading = false;
      });
    }
  }

  void _reuploadImage(File _imageFile,String mid,String pid,Map imageData, String friendUid) {
    setState(() {
      _uploading = true;
      _uploadProgress = 0.0;
    });
    _uploadImage(_imageFile,mid,pid,imageData,friendUid);
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
    _uploadImage(File(widget.imageData['content']['imageURL']), widget.mid, widget.pid, widget.imageData, widget.friendUid);

  }

  @override
  Widget build(BuildContext context) {
    Map imageData = widget.imageData;
    String mid = widget.mid;
    String pid = widget.pid;
    String friendUid = widget.friendUid;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5,),
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                children: [
                  Image.file(File(imageData['content']['imageURL'])),
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: const SizedBox(),
                    ),
                  ),
                  _uploading ?
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(
                          color: Constants.priColor,
                          value: _uploadProgress,
                        ),
                      ),
                    ),
                  ) : SizedBox(),
                  Positioned.fill(
                    child: Center(
                      child: IconButton(
                        icon: Icon(
                            _uploading?
                            Icons.cancel:Icons.upload),
                        onPressed: (){
                          _uploading?
                          _cancelUpload():_reuploadImage(File(imageData['content']['imageURL']), mid, pid, imageData,friendUid);
                        },
                        iconSize: 35,
                        color: Constants.priColor.withOpacity(0.7),
                      ),
                    ),
                  )
                ],
              ),
            ),

          ],
        ),
        SizedBox(height: 5,),
        Text(imageData['content']['caption'])
      ],
    );;
  }
}

