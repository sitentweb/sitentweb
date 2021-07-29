import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remark_app/config/constants.dart';

class ApplyButton extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final int abtnType;
  final void Function() onTap;

  const ApplyButton({
    this.width,
    this.height,
    this.padding,
    this.onTap,
    this.abtnType });

  @override
  Widget build(BuildContext context) {

    List btnType = [
      {
        "type" : 0,
        "title" : "Applied",
        "color" : kLightColor,
        "onTap" : () => print('nothing')
      },
      {
        "type" : 1,
        "title" : "Hired",
        "color" : Colors.grey[800],
        "onTap" : () => print('nothing')
      },
      {
        "type" : 2,
        "title" : "Follow Up",
        "color" : Colors.redAccent,
        "onTap" : () => print('nothing')
      },
      {
        "type" : 3,
        "title" : "Rejected",
        "color" : Colors.redAccent,
        "onTap" : () => print('nothing')
      },
      {
        "type" : 4,
        "title" : "Apply",
        "color" : kDarkColor,
        "onTap" : onTap
      },

    ];

    return GestureDetector(
      onTap: btnType[abtnType]["onTap"],
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
            color: btnType[abtnType]["color"],
            borderRadius: BorderRadius.all(Radius.circular(50)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(3,0)
              )
            ]
        ),
        child: Text(btnType[abtnType]["title"] , style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold
        ),),
      ),
    );
  }
}
