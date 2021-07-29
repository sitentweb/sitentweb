import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remark_app/config/constants.dart';

class IconCircleButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final double radius;
  final double iconSize;
  final Color textColor;
  final void Function() onPressed;
  const IconCircleButton({Key key, this.icon, this.iconColor, this.radius, this.iconSize, this.backgroundColor, this.onPressed, this.title, this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double containerRadius = radius ?? 40;

    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: containerRadius,
            height: containerRadius,
            decoration: BoxDecoration(
                color: backgroundColor ?? kDarkColor,
                borderRadius: BorderRadius.all(
                    Radius.circular(containerRadius*2)
                )
            ),
            child: IconButton(
              color: iconColor ?? Colors.white,
              autofocus: true,
              icon: Icon(icon),
              onPressed: onPressed,
            ),
          ),
          SizedBox(height: 5,),
          if(title != null)
            Text(title, style: GoogleFonts.poppins(
              color: textColor != null ? textColor : kDarkColor
            ),)
        ],
      ),
    );
  }
}
