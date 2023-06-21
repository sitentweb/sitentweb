import 'package:flutter/material.dart';
import 'package:remark_app/config/constants.dart';

class VerifiedTick extends StatelessWidget {
  final Color color;
  const VerifiedTick({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.verified,
      size: 16,
      color: color ?? kDarkColor,
    );
  }
}
