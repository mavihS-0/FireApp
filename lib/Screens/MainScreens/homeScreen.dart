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

  TabBar get _tabBar => const TabBar(
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
      body: TabBarView(
        children: <Widget>[
          Center(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/home_page/no_chat.png',width: 350,height: 250,),
                  SizedBox(height: 10,),
                  Text('Create a group to start conversation',style: TextStyle(
                    fontWeight: FontWeight.w600
                  ),)
                ],
              ),
            ),
          ),
          Center(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/home_page/no_chat.png',width: 350,height: 250,),
                  SizedBox(height: 10,),
                  Text('Start a conversation',style: TextStyle(
                      fontWeight: FontWeight.w600
                  ),)
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
