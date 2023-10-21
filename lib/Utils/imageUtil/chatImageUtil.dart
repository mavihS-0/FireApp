import 'dart:ui';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../constants.dart';

class ChatImageUtil{
  // var dataBox = Hive.box('imageData');
  // Map notSavedToLocal = {};
  // Map savedToLocal = {};
  //
  // void getLocal(Map firebaseData, String pid)  {
  //   savedToLocal={};
  //   notSavedToLocal={};
  //   Map hiveData = dataBox.get('chats')['images'];
  //   firebaseData.forEach((key, value) {
  //     if(value['type']=='image'){
  //       if(hiveData['$pid+$key']!=null){
  //         savedToLocal[key] = hiveData['$pid+$key'];
  //       }else{
  //         if(value['type']=='image'){
  //           notSavedToLocal[key] = value['content']['imageURL'];
  //         }
  //       }
  //     }
  //   });
  // }



  // Widget chatScreenImageBuilder(Map imageData, String mid){
  //   if(savedToLocal[mid]==null) {
  //     return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       SizedBox(height: 5,),
  //       Stack(
  //         children: [
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(15),
  //             child: Stack(
  //               children: [
  //                 Container(
  //                     height: 200,
  //                     width: 200,
  //                     color: Colors.black.withOpacity(0.4)
  //                 ),
  //                 Positioned.fill(
  //                   child: BackdropFilter(
  //                     filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
  //                     child: const SizedBox(),
  //                   ),
  //                 ),
  //                 Positioned.fill(
  //                   child: Center(
  //                     child: CircularProgressIndicator(
  //                       color: Constants.priColor,
  //                     ),
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //       SizedBox(height: 5,),
  //       Text(imageData['content']['caption'])
  //     ],
  //   );
  //   }else{
  //     return Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         SizedBox(height: 5,),
  //         ClipRRect(
  //           child: Image.file(File(savedToLocal[mid])),
  //           borderRadius: BorderRadius.circular(15),
  //         ),
  //         SizedBox(height: 5,),
  //         Text(imageData['content']['caption']),
  //       ],
  //     );
  //   }
  // }

  Widget chatScreenImageBuilder(Map imageData, String mid){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CachedNetworkImage(
          imageUrl : imageData['content']['imageURL'],
          placeholder: (context, url) => const CircularProgressIndicator(),
          imageBuilder: (context,image){
            return ClipRRect(
              child: Image(image: image,),
              borderRadius: BorderRadius.circular(10),
            );
          },
          errorWidget: (context, url, error) {
            return Column(
              children: [
                Icon(Icons.error,color: Constants.FGcolor.withOpacity(0.4)),
                Text('Image not found',style: TextStyle(
                    fontSize: Constants.mediumFontSize,
                    fontWeight: FontWeight.w400
                ),)
              ],
            );
          },
        ),
        if(imageData['content']['caption'] != '') SizedBox(height: 5,),
        if(imageData['content']['caption'] != '') Text(imageData['content']['caption'])
      ],
    );
  }

  Widget imageUploading(Map imageData){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5,),
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                children: [
                  Container(
                      height: 200,
                      width: 200,
                      color: Colors.black.withOpacity(0.4)
                  ),
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: const SizedBox(),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Constants.priColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 5,),
        Text(imageData['content']['caption'])
      ],
    );
  }
  //
  // void dispose(){
  //   notSavedToLocal = {};
  //   savedToLocal = {};
  // }

}