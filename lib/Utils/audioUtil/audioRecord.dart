import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:flutter_sound_record/flutter_sound_record.dart';

class AudioRecordUtil{

  String filePath = '';
  String outputFilePath='';
  AudioPlayer audioPlayer = AudioPlayer();

  Future<void> startRecording(FlutterSoundRecord recorder) async {
    var dataBox = Hive.box('imageData');
    Map indices = dataBox.get('indices');
    final player = AudioPlayer();
    player.play(AssetSource('startRec.mp3'));
    try {
      Directory dir = await getApplicationDocumentsDirectory();
      dir = Directory('${dir.path}/audio');
      if(!await dir.exists()){
        await dir.create();
      }
      filePath = dir.path+'/aud${indices['audioRecordingsCounter']}';
      indices['audioRecordingsCounter']+=1;
      await dataBox.put('indices', indices);
      recorder.start(path: filePath);
      print(filePath);
    } catch (e) {
      // Handle recording errors
      print(e);
    }
  }

  Future<void> stopRecording(FlutterSoundRecord recorder) async {
    try {
      final player = AudioPlayer();
      player.play(AssetSource('endRec.mp3'));
      outputFilePath =  (await recorder.stop())!;
    } catch (e) {
      // Handle recording stop errors
      print(e);
    }
  }

  Future<void> uploadAudioInstance(DatabaseReference messageRef)async {
    final newMessageKey = messageRef.child('messages').push();
    final messageKey = newMessageKey.key;
    await newMessageKey.set({
      'sender' : FirebaseAuth.instance.currentUser?.uid,
      'content' : {
        'audioURL' : outputFilePath
      },
      'timestamp' : DateTime.now().millisecondsSinceEpoch.toString(),
      'type' : 'audioUploading',
    });
  }

  Future setAudio() async{
    audioPlayer.setSource(DeviceFileSource(outputFilePath));
  }

  void dispose() {
    audioPlayer.dispose();
  }
}

class RecordingPreview extends StatefulWidget {
  final AudioRecordUtil audioUtil;
  final double containerHeight;
  final String pid;
  const RecordingPreview({Key? key, required this.containerHeight, required this.audioUtil, required this.pid}) : super(key: key);

  @override
  State<RecordingPreview> createState() => _RecordingPreviewState();
}

class _RecordingPreviewState extends State<RecordingPreview> {

  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.audioUtil.audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        isPlaying = event == PlayerState.playing;
      });
    });

    widget.audioUtil.audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });

    widget.audioUtil.audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });

    widget.audioUtil.audioPlayer.onPlayerComplete.listen((event) {
      widget.audioUtil.audioPlayer.setSource(DeviceFileSource(widget.audioUtil.filePath));
    });

  }

  Future setAudio() async{
    widget.audioUtil.audioPlayer.setSource(DeviceFileSource(widget.audioUtil.filePath));
  }

  @override
  Widget build(BuildContext context) {
    AudioRecordUtil audioUtil = widget.audioUtil;
    double containerHeight = widget.containerHeight;
    String filePath = widget.audioUtil.filePath;
    String pid = widget.pid;
    return AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(10),
        height: containerHeight,
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(isPlaying?Icons.pause:Icons.play_arrow,color: Colors.white,),
              onPressed: ()async{
                print(filePath);
                if(isPlaying){
                  await widget.audioUtil.audioPlayer.pause();
                }else{
                  await widget.audioUtil.audioPlayer.resume();
                }
              },
            ),
            Text("${position.toString().split('.').first.padLeft(8, "0")}  -  ${duration.toString().split('.').first.padLeft(8, "0")}",style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20
            ), ),
            IconButton(onPressed: (){
              audioUtil.uploadAudioInstance(FirebaseDatabase.instance.ref('personalChats').child(pid));
            }, icon: Icon(Icons.send,color: Colors.white,))
          ],
        )
    );
  }
}





