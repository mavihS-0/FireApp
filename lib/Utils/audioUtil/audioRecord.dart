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

//helper class for recording audio
class AudioRecordUtil{

  String filePath = '';
  String outputFilePath='';
  AudioPlayer audioPlayer = AudioPlayer();

  //function for starting recording
  Future<void> startRecording(FlutterSoundRecord recorder) async {
    var dataBox = Hive.box('imageData');
    //getting the indices for the audio recordings adding 1 to it and then updating it each time a new recording is made
    //file is saved as aud'index'
    Map indices = dataBox.get('indices');
    final player = AudioPlayer();
    //playing the sound to indicate that recording has started
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

  //function for stopping recording
  Future<void> stopRecording(FlutterSoundRecord recorder) async {
    try {
      final player = AudioPlayer();
      //playing the sound to indicate that recording has stopped
      player.play(AssetSource('endRec.mp3'));
      outputFilePath =  (await recorder.stop())!;
    } catch (e) {
      // Handle recording stop errors
      print(e);
    }
  }

  //function for uploading the audio instance to the database
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

  //function for setting source to play the audio
  Future setAudio() async{
    audioPlayer.setSource(DeviceFileSource(outputFilePath));
  }

  void dispose() {
    audioPlayer.dispose();
  }
}

//widget for showing the recording preview after recording is done
class RecordingPreview extends StatefulWidget {
  final AudioRecordUtil audioUtil;
  final String pid;
  final bool isRecorded;
  const RecordingPreview({Key? key, required this.audioUtil, required this.pid, required this.isRecorded}) : super(key: key);

  @override
  State<RecordingPreview> createState() => _RecordingPreviewState();
}

class _RecordingPreviewState extends State<RecordingPreview> {

  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

 //function for getting the audio player state and updating the UI accordingly
  void gettingThingsStarted(){
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.isRecorded){
      gettingThingsStarted();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  //function for setting source to play the audio
  Future setAudio() async{
    widget.audioUtil.audioPlayer.setSource(DeviceFileSource(widget.audioUtil.filePath));
  }

  @override
  Widget build(BuildContext context) {
    AudioRecordUtil audioUtil = widget.audioUtil;
    String filePath = widget.audioUtil.filePath;
    String pid = widget.pid;
    return Row(
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
        //text showing the duration of the audio and current position of the audio
        Text("${position.toString().split('.').first.padLeft(8, "0")}  -  ${duration.toString().split('.').first.padLeft(8, "0")}",style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20
        ), ),
        IconButton(onPressed: (){
          audioUtil.uploadAudioInstance(FirebaseDatabase.instance.ref('personalChats').child(pid));
        }, icon: Icon(Icons.send,color: Colors.white,))
      ],
    );
  }
}
