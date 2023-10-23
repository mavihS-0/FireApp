import 'package:flutter/material.dart';

import '../../../../Utils/constants.dart';

//screen for showing shared links
class LinksScreen extends StatelessWidget {
  const LinksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.scaffoldBGColor,
      body: ListView(
        children: [
          LinksSection(title: 'Recent', links: ['link1.com','link2.com','link3.com']),
          LinksSection(title: 'Last week', links: ['link1.com','link2.com','link3.com','link4.com','link5.com']),
          LinksSection(title: 'Last month', links: ['link1.com','link2.com','link3.com','link4.com','link5.com','link6.com','link7.com','link8.com','link9.com','link10.com']),
        ],
      ),
    );
  }
}

class LinksSection extends StatelessWidget {
  final String title;
  final List links;
  const LinksSection({Key? key, required this.title, required this.links}) : super(key: key);

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
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: links.length,
          itemBuilder: (context,index){
            return ListTile(
              leading: Icon(Icons.link),
              title: Text(links[index]),
              trailing: Icon(Icons.open_in_new),
            );
          },
        )
      ],
    );
  }
}
