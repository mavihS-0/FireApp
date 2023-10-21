import 'dart:async';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
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
}
