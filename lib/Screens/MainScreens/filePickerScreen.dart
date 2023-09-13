import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';


class FilePickerScreen extends StatefulWidget {
  const FilePickerScreen({Key? key}) : super(key: key);

  @override
  State<FilePickerScreen> createState() => _FilePickerScreenState();
}

class _FilePickerScreenState extends State<FilePickerScreen> {
  List<PlatformFile> _selectedFiles = [];

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'], // Customize the allowed file types
        allowMultiple: true, // Allow multiple file selection
      );

      if (result != null) {
        setState(() {
          _selectedFiles = result.files;
        });
      }
    } catch (e) {
      print('Error picking files: $e');
    }
  }

  void _deleteFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Picker and Viewer'),
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: _pickFiles,
            child: Text('Pick Files'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedFiles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_selectedFiles[index].name),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteFile(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
