import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

//widget for showing message (type: audio) in chat screen and playing the audio
class ChatScreenAudioWidget extends StatefulWidget {
  final Map audioData;
  const ChatScreenAudioWidget({Key? key, required this.audioData}) : super(key: key);

  @override
  State<ChatScreenAudioWidget> createState() => _ChatScreenAudioWidgetState();
}

class _ChatScreenAudioWidgetState extends State<ChatScreenAudioWidget> {
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //functions for getting the audio player state and updating the UI accordingly
    audioPlayer.setSource(UrlSource(widget.audioData['content']['audioURL']));

    audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        isPlaying = event == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });

    audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });

    audioPlayer.onPlayerComplete.listen((event) {
      audioPlayer.setSource(UrlSource(widget.audioData['content']['audioURL']));
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(isPlaying?Icons.pause:Icons.play_arrow,size: 35,),
          onPressed: ()async{
            if(isPlaying){
              await audioPlayer.pause();
            }else{
              await audioPlayer.resume();
            }
          },
        ),
        Expanded(
          child: Column(
            children: [
              Slider(
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) async{
                  final pos = Duration(seconds: value.toInt());
                  await audioPlayer.seek(pos);
                },
                activeColor: Colors.black,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(position.toString().split('.').first.padLeft(8, "0").substring(3)),
                  Text(duration.toString().split('.').first.padLeft(8, "0").substring(3))
                ],
              ),
            ],
          ),
        )
      ]
    );
  }
}
