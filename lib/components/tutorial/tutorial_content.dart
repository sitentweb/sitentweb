import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTutorialContent extends StatelessWidget {
  final String title;
  final double verticalPadding;
  final double horizontalPadding;
  final String content;
  const CustomTutorialContent({Key key, this.title, this.content, this.verticalPadding, this.horizontalPadding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: verticalPadding ?? 0 , horizontal: horizontalPadding ?? 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          title.isNotEmpty || title != null ? Text(title ?? "" , style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15
          ),) : Container(),
          SizedBox(height: 20,),
          content.isNotEmpty || content != null ? Text(content ?? "" , style: GoogleFonts.poppins(
            color: Colors.white
          ),) : Container()
        ],
      ),
    );
  }
}
