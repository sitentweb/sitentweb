import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IconText extends StatelessWidget {
  final String title;
  final IconData icon;
  final double width;
  const IconText({Key key, this.title, this.icon, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Icon(icon , color: Colors.grey[600], size: 16,),
          SizedBox(width: 5,),
          SizedBox(
            width: width ?? 100,
            child: Text(title , style: GoogleFonts.poppins(
                color: Colors.grey[600]
            ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
            ),
          )

        ],
      ),
    );
  }
}
