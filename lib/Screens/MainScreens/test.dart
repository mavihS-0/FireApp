import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import '../../Utils/imageData.dart';

class ImageUploadScreen extends StatefulWidget {
  final List<ImageData> selectedImages;
  const ImageUploadScreen({Key? key, required this.selectedImages}) : super(key: key);
  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _imageFile;
  bool _uploading = false;
  bool _uploadCancelled = false;
  double _uploadProgress = 0.0;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  firebase_storage.UploadTask? _uploadTask;

  Future<void> _uploadImage() async {
    try {
      if (_imageFile != null) {
        setState(() {
          _uploading = true;
          _uploadCancelled = false;
          _uploadProgress = 0.0;
        });

        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final Reference reference = _storage.ref().child('images/$fileName');

        _uploadTask = reference.putFile(
          _imageFile!,
          firebase_storage.SettableMetadata(contentType: 'image/jpeg'),
        );

        _uploadTask!.snapshotEvents.listen((event) {
          setState(() {
            _uploadProgress = event.bytesTransferred / event.totalBytes;
          });
        });

        await _uploadTask!.whenComplete(() {
          setState(() {
            _uploading = false;
          });
        });
      }
    } catch (e) {
      print('Error uploading image: $e');
      setState(() {
        _uploading = false;
        _uploadCancelled = true;
      });
    }
  }

  void _reuploadImage() {
    setState(() {
      _uploadCancelled = false;
      _uploadProgress = 0.0;
    });
    _uploadImage();
  }

  void _cancelUpload() {
    if (_uploadTask != null) {
      _uploadTask!.cancel();
      setState(() {
        _uploadCancelled = true;
        _uploading = false;
        _uploadProgress = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload with Cancel'),
      ),
      body: Stack(
        children: <Widget>[
          _imageFile == null
              ? ElevatedButton(
            onPressed: () async {
              final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                setState(() {
                  _imageFile = File(pickedFile.path);
                });
              }
            },
            child: Text('Pick an Image'),
          )
              : Align(
            alignment: Alignment.center,
                child: Image.file(
            _imageFile!,
            height: 200,
          ),
              ),
          SizedBox(height: 16),
          if (_uploading)
            Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                value: _uploadProgress,
              ),
            )
          else if (_uploadCancelled)
            Column(
              children: [
                Text('Upload Cancelled'),
                ElevatedButton(
                  onPressed: _reuploadImage,
                  child: Text('Reupload Image'),
                ),
              ],
            )
          else if (_imageFile != null)
              ElevatedButton(
                onPressed: _uploadImage,
                child: Text('Upload Image'),
              ),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: _cancelUpload,
              child: Text('Cancel Upload'),
            ),
          ),
        ],
      ),
    );
  }
}
