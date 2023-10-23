import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

//widget to display list tile on home screens (both personal chats and groups)
class HomeScreenListTile extends StatelessWidget {
  final Function() onListTileTap;
  final Function() onProfileIconTap;
  final String pfpURL;
  final String name;
  final String lastMessage;
  final String lastMessageTime;
  const HomeScreenListTile({Key? key,
    required this.onListTileTap,
    required this.onProfileIconTap,
    required this.pfpURL,
    required this.name,
    required this.lastMessage,
    required this.lastMessageTime
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      //TODO: go to chat screen function
      onTap: onListTileTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
        child: Row(
          children: [
            InkWell(
              onTap: onProfileIconTap,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: pfpURL,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                  //placeholder: (context, url) => const Center( child: CircularProgressIndicator(),)
                  errorWidget: (context, url, error) => Icon(Icons.error,color: Constants.FGcolor.withOpacity(0.4)),
                ),
              ),
            ),
            const SizedBox(width: 15,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),),
                  Text(lastMessage,style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600]
                  ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 10,),
            Text(lastMessageTime,
              style: const TextStyle(
                fontSize: 12,
              ),)
          ],
        ),
      ),
    );
  }
}
