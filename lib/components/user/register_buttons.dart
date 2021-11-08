import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/pages/profile/edit_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterAs extends StatefulWidget {
  const RegisterAs({Key key}) : super(key: key);

  @override
  _RegisterAsState createState() => _RegisterAsState();
}

class _RegisterAsState extends State<RegisterAs> {

  String userType;
  String userID;

  @override
  void initState() {
    // TODO: implement initState
    getUser();
    super.initState();
  }

  getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      userID = pref.getString("userID");
    });

  }

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
                  onPressed: () async {
                    
                    setState(() {
                      userType = "1";
                    });

                    pushNewScreen(context, screen: EditProfile(userID: userID , userType: userType,) , withNavBar: false);
 
                  },
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
                  onPressed: () async {
                     setState(() {
                       userType = "2";
                       
                        });

                     pushNewScreen(context, screen: EditProfile(userID: userID , userType: userType,) , withNavBar: false);
                  },
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
