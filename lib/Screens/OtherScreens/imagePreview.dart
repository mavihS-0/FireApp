import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Media Preview'),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.download))
        ],
      ),
      body: Center(
        child: Image.asset('assets/home_page/no_chat.png'),
      ),
    );
  }
}
