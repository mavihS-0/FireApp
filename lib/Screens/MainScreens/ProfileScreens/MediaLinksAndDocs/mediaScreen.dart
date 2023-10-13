import 'package:flutter/material.dart';

import '../../../../Utils/constants.dart';

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
        Padding(
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
            return Container(
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.5)
              ),
            );
          },
        ),
      ],
    );
  }
}
