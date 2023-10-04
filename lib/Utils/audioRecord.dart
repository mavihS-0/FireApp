import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:flutter_sound_record/flutter_sound_record.dart';

class AudioRecordUtil{

  String _filePath = '';
  String _outputFilePath='';

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
      _filePath = dir.path+'/aud${indices['audioRecordingsCounter']}';
      indices['audioRecordingsCounter']+=1;
      await dataBox.put('indices', indices);
      recorder.start(path: _filePath);
      print(_filePath);
    } catch (e) {
      // Handle recording errors
      print(e);
    }
  }

  Future<void> stopRecording(FlutterSoundRecord recorder) async {
    try {
      final player = AudioPlayer();
      player.play(AssetSource('endRec.mp3'));
      _outputFilePath =  (await recorder.stop())!;
      print(_outputFilePath);
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
        'audioURL' : _outputFilePath
      },
      'timestamp' : DateTime.now().millisecondsSinceEpoch.toString(),
      'type' : 'audio',
      'status' : 'uploading'
    });
  }
}








