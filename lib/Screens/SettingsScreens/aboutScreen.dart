import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
            Text('version1.0'),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: ()async{
                    if (!await launchUrl(Uri.parse('mailto:info@ajanitech.com'))) {
                      throw Exception('Could not launch Url');
                    }
                  },
                  icon: Icon(Icons.mail),
                ),
                SizedBox(width: 10,),
                IconButton(
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
