import 'package:flutter/material.dart';
import 'package:remark_app/config/constants.dart';

class CircularLoading extends StatelessWidget {
  const CircularLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kDarkColor),
          ),
        ),
      ),
    );
  }
}
