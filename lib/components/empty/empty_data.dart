import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyData extends StatelessWidget {
  final message;
  const EmptyData({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/icons/empty.png" , width: 150, color: Colors.grey[400],),
          SizedBox(height: 10,),
          Text(message , style: GoogleFonts.poppins(
            color: Colors.grey[400],
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ), textAlign: TextAlign.center,)
        ],
      ),
    );
  }
}
