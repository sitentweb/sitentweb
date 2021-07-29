import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginButton extends StatelessWidget {
  final icon;
  final title;
  final color;
  final actionOnClick;

  const LoginButton({Key key, this.title, this.actionOnClick, this.color, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: actionOnClick,
      child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 15,
          ),
          width: size.width * 0.8,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    spreadRadius: 1,
                    offset: Offset(0 , 2)
                )
              ]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon , color: Colors.white,),
              SizedBox(width: 10,),
              Text(title , style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),),
            ],
          )
      ),
    );
  }
}
