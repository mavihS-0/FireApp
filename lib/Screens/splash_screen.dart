import 'package:fire_app/Screens/Onboarding/signup.dart';
import 'package:fire_app/Utils/customButton.dart';
import 'package:fire_app/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final PageController _pageController = PageController();
  List PageData = [
    {'image' : 'assets/splash_pages/page1.png', 'title': 'Lorem ipsum dolor sit am',
    'desc': 'Lorem ipsum dolor sit amet, consectetur adipiscing'},
    {'image' : 'assets/splash_pages/page2.png', 'title': 'Lorem ipsum dolor sit am',
      'desc': 'Lorem ipsum dolor sit amet, consectetur adipiscing'},
    {'image' : 'assets/splash_pages/page3.png', 'title': 'Lorem ipsum dolor sit am',
      'desc': 'Lorem ipsum dolor sit amet, consectetur adipiscing'}
  ];
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Container(
        margin: const EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: (){Get.to(()=>SignUp());}, child: Text('SKIP',style: TextStyle(decoration: TextDecoration.underline, color: Constants.priColor ),))
              ],
            ),
            Expanded(
              child: PageView.builder(
                  itemCount: 3,
                  scrollDirection: Axis.horizontal,
                  controller: _pageController,
                  onPageChanged: (int i){
                    setState(() {
                      _index=i;
                    });
                  },
                  itemBuilder: (context,index){
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(PageData[index]['image'],height: 250,width: 350,),
                        const SizedBox(height: 70,),
                        Text(PageData[index]['title'],style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,),
                        const SizedBox(height: 5,),
                        Text(PageData[index]['desc'],textAlign: TextAlign.center,),
                        const SizedBox(height: 10,),
                      ],
                    );
                  },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index2) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: CircleAvatar(
                  radius: 4,
                  backgroundColor: index2==_index ? Constants.priColor:Colors.grey[500],
                ),
              )),
            ),
            const SizedBox(height: 50,),
            CustomTextButton(title: 'CONTINUE', onPress: (){
              _index ==2 ? Get.to(()=>SignUp()) :
              _pageController.animateToPage((_index+1)%3, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
            }),
            const SizedBox(height: 40,)
          ],
        ),
      ),
    ));
  }
}

