import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Utils/constants.dart';
import '../../../OtherScreens/imagePreview.dart';

class MediaScreen extends StatelessWidget {
  const MediaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.scaffoldBGColor,
      body: ListView(
        children: [
          MediaSection(title: 'Recent', media: [1,2,2,23,2,21,12,2,2,3]),
          MediaSection(title: 'Last week', media: [1,2,2,23,2,21,12,2]),
          MediaSection(title: 'Last month', media: [1,2,2,23,2,21]),
        ],
      ),
    );
  }
}

class MediaSection extends StatelessWidget {
  final List media;
  final String title;
  const MediaSection({Key? key, required this.title, required this.media}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.white,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Text(title,style: TextStyle(
              color: Constants.FGcolor,
              fontSize: Constants.mediumFontSize
          ),),
        ),
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3
          ),
          itemCount: media.length,
          itemBuilder: (context,index){
            return InkWell(
              onTap: (){
                Get.to(()=>ImagePreview(),arguments: {
                  'imageURL' : 'assets/home_page/no_chat.png',
                });
              },
              child: Image.asset('assets/home_page/no_chat.png',
              height: 100,
              fit: BoxFit.fitHeight,),
            );
          },
        ),
      ],
    );
  }
}
