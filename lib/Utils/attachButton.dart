import 'package:fire_app/Screens/MainScreens/imagePickerScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AttachButton extends StatelessWidget {
  final double? containerHeight;
  const AttachButton({Key? key,required this.containerHeight}) : super(key: key);

  Widget CustomAttachButton(Function() onPress,IconData buttonIcon,Color buttonColor){
    return InkWell(
      onTap: onPress,
      child: CircleAvatar(
        radius: 30,
        backgroundColor: buttonColor,
        child: Icon(
          buttonIcon,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      height: containerHeight,
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomAttachButton((){}, Icons.file_copy,Colors.purple),
          CustomAttachButton((){}, Icons.audiotrack,Colors.orange),
          CustomAttachButton(()async{
            final images = await ImagePicker().pickMultiImage();
            Get.to(()=>ImagePickerScreen(),arguments: {
              'images' : images
            });
          }, Icons.photo_library_sharp,Colors.pinkAccent),
        ],
      ),
    );
  }
}
