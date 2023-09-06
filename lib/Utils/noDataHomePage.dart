import 'package:flutter/material.dart';

class NoDataHomePage extends StatelessWidget {
  final String caption;
  const NoDataHomePage({Key? key, required this.caption}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/home_page/no_chat.png',width: 350,height: 250,),
            SizedBox(height: 10,),
            Text(caption,style: TextStyle(
                fontWeight: FontWeight.w600
            ),)
          ],
        ),
      ),
    );
  }
}
