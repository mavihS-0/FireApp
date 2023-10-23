import 'package:fire_app/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

//app info screen
class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 120,
              width: 120,
              child: Image.asset('assets/flash_screen.png'),
            ),
            SizedBox(height: 5,),
            Text('version${Constants.version}'),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  //function to open default mail with 'to' field already filled
                  onPressed: ()async{
                    if (!await launchUrl(Uri.parse('mailto:info@ajanitech.com'))) {
                      throw Exception('Could not launch Url');
                    }
                  },
                  icon: Icon(Icons.mail),
                ),
                SizedBox(width: 10,),
                IconButton(
                  //function to launch url on default web browser
                  onPressed: ()async{
                    if (!await launchUrl(Uri.parse('https://ajanitech.com/'))) {
                      throw Exception('Could not launch Url');
                    }
                  },
                  icon: Icon(Icons.language),
                ),
                SizedBox(width: 10,),
                IconButton(
                  onPressed: ()async{
                    //function to launch url on default web browser/twitter app
                    if (!await launchUrl(Uri.parse('https://twitter.com/ajaniinfotech'))) {
                      throw Exception('Could not launch Url');
                    }
                  },
                  icon: Icon(FontAwesomeIcons.twitter),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
