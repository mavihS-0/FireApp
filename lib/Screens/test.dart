// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:record_mp3/record_mp3.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:audioplayers/audioplayers.dart';
//
// class VoiceRecordingScreen extends StatefulWidget {
//   @override
//   _VoiceRecordingScreenState createState() => _VoiceRecordingScreenState();
// }
//
// class _VoiceRecordingScreenState extends State<VoiceRecordingScreen> {
//   bool isRecording = false;
//   bool isRecorded = false;
//   String _filePath = '';
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   Future<void> startRecording() async {
//     try {
//       if(!await Permission.microphone.isGranted) {
//         Permission.microphone.request();
//       }
//       Directory dir = await getApplicationDocumentsDirectory();
//       dir = Directory(dir.path+'/audio');
//       if(!await dir.exists()){
//         dir.create();
//       }
//       _filePath = dir.path+'/aud01';
//       RecordMp3.instance.start(_filePath, (p0) {
//         setState(() {
//           isRecording = true;
//         });
//       });
//     } catch (e) {
//       // Handle recording errors
//       print(e);
//       print('wow');
//     }
//   }
//
//   Future<void> stopRecording() async {
//     try {
//       RecordMp3.instance.stop();
//       setState(() {
//         isRecording = false;
//         isRecorded = true;
//       });
//     } catch (e) {
//       // Handle recording stop errors
//       print(e);
//     }
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           IconButton(
//             icon: Icon(Icons.stop),
//             onPressed: ()async{
//               stopRecording();
//             },
//           ),
//           Container(
//             child: isRecorded?IconButton(
//               icon: Icon(Icons.play_arrow),
//               onPressed: (){
//                 final player = AudioPlayer();
//                 player.play(UrlSource('https://firebasestorage.googleapis.com/v0/b/fireapp-a5221.appspot.com/o/Alan%20Walker%20-%20Believers%20ft.%20Conor%20Maynard.wav?alt=media&token=ddde70d1-84b4-4b8b-9b41-ad0cf20e045e'));
//               },
//             ): SizedBox(),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: ()async{
//           isRecording?stopRecording():startRecording();
//         },
//         child: isRecording?Icon(Icons.stop):Icon(Icons.mic),
//       ),
//     );
//   }
// }
