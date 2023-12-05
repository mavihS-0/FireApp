import 'dart:io';
import 'package:fire_app/Screens/Onboarding/signupLoading.dart';
import 'package:fire_app/Utils/constants.dart';
import 'package:fire_app/Utils/customTextButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

//screen to set profile info after successful otp verification
class SetProfileName extends StatefulWidget {
  const SetProfileName({Key? key}) : super(key: key);

  @override
  State<SetProfileName> createState() => _SetProfileNameState();
}

class _SetProfileNameState extends State<SetProfileName> {

  Image _image = Image.asset('assets/signup/profile.png');
  final TextEditingController _nameController = TextEditingController();
  late File _imageFile;

  //get placeholder image from assets
  Future<void> getImageFileFromAssets() async {
    final byteData = await rootBundle.load('assets/signup/profile.png');

    final file = File('${(await getTemporaryDirectory()).path}/signup/profile.png');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    _imageFile = file;
  }

  //pick profile image from gallery
  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _image =Image.file(_imageFile);
        });
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImageFileFromAssets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height*0.97,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 70,),
                Center(
                    child: InkWell(
                      onTap: (){
                        _pickImage(ImageSource.gallery);
                      },
                      child: SizedBox(
                        height: 60,
                        width: 60,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              backgroundImage: _image.image,
                              radius: 30,
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: CircleAvatar(
                                  radius: 11,
                                  backgroundColor: Constants.priColor,
                                  child: const Icon(Icons.add,color: Colors.white,size: 20,)),
                            )
                          ],
                        ),
                      ),
                    )
                ),
                const SizedBox(height: 50,),
                const Text('Profile Name', style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                ), textAlign: TextAlign.left,),
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Enter your name',
                      hintStyle: TextStyle(
                        fontSize: 14,
                      )
                  ),
                  controller: _nameController,
                ),
                const SizedBox(height: 50,),
                Expanded(child: Container()),
                CustomTextButton(title: 'CONTINUE', onPress: (){
                  Get.to(()=>const SignupLoading(),arguments: {
                    'name': _nameController.text,
                    'imageFile' : _imageFile,
                  });
                })
              ],
            )
        ),
      ),
    );
  }
}
