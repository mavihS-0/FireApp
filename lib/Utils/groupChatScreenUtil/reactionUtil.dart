import 'dart:async';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fire_app/Utils/dummyData/dummyGroupChatScreenData.dart';
import 'package:flutter/cupertino.dart';

class ReactionUtil{
  List commonEmojis = ['👍','♥','😂','😢','😡','😯'];
  bool showReactionKeyboard = false;
  final StreamController<bool> _keyboardStreamController = StreamController<bool>();
  Stream <bool> get reactionKeyboardStream => _keyboardStreamController.stream;
  bool isEmojiSelected = false;
  void changeReactionKeyboard(bool showReactionKeyboard){
    this.showReactionKeyboard = showReactionKeyboard;
    _keyboardStreamController.add(showReactionKeyboard);
  }

  int chatBubbleIndex = -1;

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

  num getTotalLength(Map data){
    List l1 =data['reactionUsers'];
    num total =0;
    l1.forEach((element) {
      total += element.length;
    });
    return total;
  }
}
