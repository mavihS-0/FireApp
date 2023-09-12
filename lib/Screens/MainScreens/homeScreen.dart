import 'package:fire_app/Screens/MainScreens/personalChats.dart';
import 'package:fire_app/Screens/Onboarding/setProfile.dart';
import 'package:fire_app/Screens/MainScreens/addContact.dart';
import 'package:fire_app/Utils/constants.dart';
import 'package:fire_app/Utils/noDataHomePage.dart';
import 'package:fire_app/Utils/popUpMenu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int currTabIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  TabBar get _tabBar => TabBar(
    tabs: <Widget>[
      Tab(
        text: 'Groups',
      ),
      Tab(
        text: 'Personals',
      ),
    ],
    onTap: (i){
      currTabIndex = i;
      setState(() {

      });
    },

  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(initialIndex: 0,length: 2, child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('X'),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.search)),
          currTabIndex==0 ? customPopUpMenu('New group',(){}) : customPopUpMenu('New chat', (){}),
        ],
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
          NoDataHomePage(
            caption: 'Create a group to start conversation',
          ),
          PersonalChats()
        ],
      ),
    ));
  }
}
