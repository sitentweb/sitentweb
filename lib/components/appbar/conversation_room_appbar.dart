import 'package:flutter/material.dart';
import 'package:remark_app/config/constants.dart';

class ConversationRoomAppBar extends StatelessWidget {
  const ConversationRoomAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 10
      ),
      decoration: BoxDecoration(
        color: kDarkColor
      ),
      child: Row(
        children: [
          Text("Chats" , style: TextStyle(
            color: Colors.white
          ),)
        ],
      ),
    );
  }
}
