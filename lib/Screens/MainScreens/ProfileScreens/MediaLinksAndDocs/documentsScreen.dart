import 'package:fire_app/Utils/constants.dart';
import 'package:flutter/material.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.scaffoldBGColor,
      body: ListView(
        children: [
          DocumentsSection(title: 'Recent', docs: ['doc1.pdf','doc2.pdf','doc3.pdf']),
          DocumentsSection(title: 'Last week', docs: ['doc1.pdf','doc2.pdf','doc3.pdf','doc4.pdf','doc5.pdf']),
          DocumentsSection(title: 'Last month', docs: ['doc1.pdf','doc2.pdf','doc3.pdf','doc4.pdf','doc5.pdf','doc6.pdf','doc7.pdf','doc8.pdf','doc9.pdf','doc10.pdf']),
        ],
      ),
    );
  }
}

class DocumentsSection extends StatelessWidget {
  final String title;
  final List docs;
  const DocumentsSection({Key? key,required this.title, required this.docs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.white,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Text(title,style: TextStyle(
              color: Constants.FGcolor,
              fontSize: Constants.mediumFontSize
          ),),
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: docs.length,
          itemBuilder: (context,index){
            return ListTile(
              leading: Icon(Icons.file_present),
              title: Text(docs[index]),
              trailing: Icon(Icons.download),
            );
          },
        )
      ],
    );
  }
}
