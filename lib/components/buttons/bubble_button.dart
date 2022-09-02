import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:remark_app/config/constants.dart';

class BubbleButton extends StatefulWidget {
  final Widget title;
  final Widget icon;

  const BubbleButton({Key key, this.title, this.icon}) : super(key: key);

  @override
  _BubbleButtonState createState() => _BubbleButtonState();
}

class _BubbleButtonState extends State<BubbleButton> {
  Future<bool> userTapThis(bool isLiked) async {
    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return LikeButton(
      size: 25,
      onTap: userTapThis,
      circleColor:
      CircleColor(start: kLightColor, end: kDarkColor),
      bubblesColor: BubblesColor(
          dotPrimaryColor: kLightColor,
          dotSecondaryColor: kDarkColor,
          dotLastColor: Colors.greenAccent),

      likeBuilder: (isLiked) {
        return Row(
          children: [
              widget.icon,
            if(widget.title != null)
              widget.title
          ],
        );
      },
    );
  }
}
