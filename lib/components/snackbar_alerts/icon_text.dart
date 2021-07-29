import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IconSnackBar extends StatelessWidget {
  final IconData iconData;
  final String textData;
  final Color textColor;

  const IconSnackBar({Key key, this.iconData, this.textData, this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(iconData , color: textColor,),
        SizedBox(width: 5,),
        Text(textData , style: GoogleFonts.poppins(
            color: textColor
        ),)
      ],

    );
  }
}
