import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        child: CachedNetworkImage(imageUrl: Get.arguments['imageURL'], fit: BoxFit.fill, width: double.infinity,),
      ),
    );
  }
}
