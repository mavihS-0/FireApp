import 'package:fire_app/Utils/constants.dart';
import 'package:fire_app/Utils/popUpMenu.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  TabBar get _tabBar => TabBar(
    indicatorColor: Constants.priColor2,
    labelColor: Constants.priColor,
    indicatorSize: TabBarIndicatorSize.tab,
    labelStyle: TextStyle(
      fontWeight: FontWeight.bold
    ),
    unselectedLabelColor: Constants.priColor,
    unselectedLabelStyle: TextStyle(
      fontWeight: FontWeight.normal
    ),
    tabs: <Widget>[
      Tab(
        text: 'Groups',
      ),
      Tab(
        text: 'Personals',
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(initialIndex: 0,length: 2, child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('FireAppX'),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.search)),
          customPopUpMenu()
        ],
        bottom: PreferredSize(
          preferredSize: _tabBar.preferredSize,
          child: ColoredBox(
            color: Constants.secColor,
            child: _tabBar,
          ),
        ),
      ),
      body: const TabBarView(
        children: <Widget>[
          Center(
            child: Text("It's cloudy here"),
          ),
          Center(
            child: Text("It's rainy here"),
          ),
        ],
      ),
    ));
  }
}
