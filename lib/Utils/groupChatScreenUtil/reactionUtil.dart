import 'dart:async';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fire_app/Utils/dummyData/dummyGroupChatScreenData.dart';
import 'package:flutter/cupertino.dart';

//helper class for reactions
class ReactionUtil{
  List commonEmojis = ['👍','♥','😂','😢','😡','😯'];
  bool showReactionKeyboard = false;
  //creating stream to notify the widget to show reaction keyboard (notify parent stateful widget from child stateful widget)
  final StreamController<bool> _keyboardStreamController = StreamController<bool>();
  Stream <bool> get reactionKeyboardStream => _keyboardStreamController.stream;
  bool isEmojiSelected = false;
  //adding event to stream to notify the widget to show reaction keyboard
  void changeReactionKeyboard(bool showReactionKeyboard){
    this.showReactionKeyboard = showReactionKeyboard;
    _keyboardStreamController.add(showReactionKeyboard);
  }

  int chatBubbleIndex = -1;

  //reaction keyboard widget
  Widget ReactionKeyboardWidget(Function(Category? category,Emoji emoji) onEmojiSelected) {
    return showReactionKeyboard ? TapRegion(
      onTapOutside: (event){
        changeReactionKeyboard(false);
      },
      child: Container(
        height: 270,
        child: EmojiPicker(
          onEmojiSelected: onEmojiSelected,
          config: Config(
            columns: 7,
            emojiSizeMax: 32.0,
          ),
        ),
      ),
    ) :SizedBox();
  }

  void dispose(){
    _keyboardStreamController.close();
  }

  //adding emoji to the message
  void addEmoji(Map data,String emoji){
    int index =-1;
    if (data['reactions'].contains(emoji)){
      index = data['reactions'].indexOf(emoji);
      data['reactionUsers'][index].add('Me');
    }
    else {
      data['reactions'].add(emoji);
      index = data['reactions'].length -1 ;
      data['reactionUsers'].add(['Me']);
    }
  }

  //get total number of reactions
  num getTotalLength(Map data){
    List l1 =data['reactionUsers'];
    num total =0;
    l1.forEach((element) {
      total += element.length;
    });
    return total;
  }
}
