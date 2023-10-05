import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late RecorderController controller = RecorderController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: AudioWaveforms(
            recorderController: controller,
            size: Size(MediaQuery.of(context).size.width / 2, 70),
            waveStyle: WaveStyle(
            waveColor: Colors.white,
            showDurationLabel: true,
            spacing: 8.0,
            showBottom: false,
            extendWaveform: true,
            showMiddleLine: false,
          ),
        ),
      ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        onPressed: ()async{
          await controller.record(path: 'efeaf.mp3');
        },
      ),
    );
  }
}
