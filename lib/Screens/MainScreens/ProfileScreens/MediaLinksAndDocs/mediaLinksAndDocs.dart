import 'package:fire_app/Screens/MainScreens/ProfileScreens/MediaLinksAndDocs/documentsScreen.dart';
import 'package:fire_app/Screens/MainScreens/ProfileScreens/MediaLinksAndDocs/linksScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Utils/constants.dart';
import 'mediaScreen.dart';

//helper widget to switch between media, links and documents
class MediaLinksAndDocs extends StatefulWidget {
  const MediaLinksAndDocs({Key? key}) : super(key: key);

  @override
  State<MediaLinksAndDocs> createState() => _MediaLinksAndDocsState();
}

class _MediaLinksAndDocsState extends State<MediaLinksAndDocs> {

  int currTabIndex = 0;

  TabBar get _tabBar => TabBar(
    tabs: <Widget>[
      Tab(
        text: 'Media',
      ),
      Tab(
        text: 'Documents',
      ),
      Tab(
        text: 'Links',
      ),
    ],
    onTap: (i){
      setState(() {
        currTabIndex = i;
      });
    },
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(initialIndex: 0,length: 3, child: Scaffold(
      appBar: AppBar(
        title: Text(Get.arguments['name']),
        bottom: PreferredSize(
          preferredSize: _tabBar.preferredSize,
          child: ColoredBox(
            color: Constants.secColor,
            child: _tabBar,
          ),
        ),
      ),
      body: TabBarView(
        children: <Widget>[
          MediaScreen(),
          DocumentsScreen(),
          LinksScreen(),
        ],
      ),
    ));
  }
}
