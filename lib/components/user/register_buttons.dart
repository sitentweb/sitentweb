import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remark_app/config/constants.dart';

class RegisterAs extends StatelessWidget {
  const RegisterAs({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Text("Register as" , style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16
          ),),
          SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: MaterialButton(
                  onPressed: () => print("employee"),
                  child: Text("Employee" , style: GoogleFonts.poppins(),),
                  elevation: 10,
                  padding: EdgeInsets.all(15),
                  color: kDarkColor,
                  textColor: Colors.white,
                ),
              ),
              SizedBox(width: 5,),
              Expanded(
                child: MaterialButton(
                  onPressed: () => print("employer"),
                  child: Text("Employer" , style: GoogleFonts.poppins(),),
                  elevation: 10,
                  padding: EdgeInsets.all(15),
                  color: kDarkColor,
                  textColor: Colors.white,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
