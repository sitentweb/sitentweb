import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remark_app/apis/support/inquiryApi.dart';
import 'package:remark_app/components/appbar/appbar.dart';
import 'package:remark_app/components/drawer/application_drawer.dart';
import 'package:remark_app/config/appSetting.dart';
import 'package:remark_app/config/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Support extends StatefulWidget {
  const Support({Key key}) : super(key: key);

  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {
  TextEditingController _inquiryName = TextEditingController();
  TextEditingController _inquiryMobile = TextEditingController();
  TextEditingController _inquiryMessage = TextEditingController();

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
      userType = pref.getString("userType");
      userID = pref.getString("userID");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [ApplicationAppBar()],
          iconTheme: IconThemeData(color: kDarkColor)),
      drawer: Drawer(
        child: ApplicationDrawer(),
      ),
      body: SafeArea(
          child: Container(
        width: AppSetting.size(context).width,
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: AvatarGlow(
                    glowColor: kLightColor,
                    child: Image.asset(application_logo),
                    endRadius: 60),
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              Container(
                width: AppSetting.size(context).width * 0.8,
                height: 200,
                child: Column(
                  children: [
                    SupportDetails(
                      label: "Email",
                      text: "info@remarkable.com",
                      icon: Icons.email,
                      onTap: () async {
                        var email = "mailto:info@remarkhr.com";
                        await canLaunch(email)
                            ? launch(email)
                            : print("Can't Launch This");
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SupportDetails(
                      label: "Mobile Number",
                      text: "+91 9568569856",
                      icon: Icons.phone,
                      onTap: () async {
                        var url = "tel:9568569856";
                        await canLaunch(url)
                            ? launch(url)
                            : print("Can't launch url");
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SupportDetails(
                      label: "Support Time",
                      text: "Mon - Fri 9am - 6pm",
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
                height: 400,
                child: Column(children: [
                  Container(
                    child: Text("Inquiry",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: _inquiryName,
                      decoration: InputDecoration(label: Text("Name")),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: _inquiryMobile,
                      decoration: InputDecoration(label: Text("Mobile Number")),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: _inquiryMessage,
                      minLines: 3,
                      maxLines: 3,
                      decoration: InputDecoration(label: Text("Your Message")),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  MaterialButton(
                    color: kDarkColor,
                    textColor: Colors.white,
                    onPressed: () async {
                      var res = await InquiryApi().sendInquiry(
                          _inquiryName.text,
                          _inquiryMobile.text,
                          _inquiryMessage.text,
                          userID);

                      SnackBar snackBar;

                      if (res['status']) {
                        _inquiryName.clear();
                        _inquiryMobile.clear();
                        _inquiryMessage.clear();
                        snackBar = SnackBar(
                          content: Text(
                            "Inquiry Sent",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.green,
                        );
                      } else {
                        snackBar = SnackBar(
                          content: Text(
                            "${res['message']}",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.redAccent,
                        );
                      }

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: Text("Send"),
                  )
                ]),
              ),
              // Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    var url = "https://sitentweb.com";
                    await canLaunch(url)
                        ? launch(url)
                        : print("Can't launch url");
                  },
                  child: Text("Created by SitentWeb",
                      style: GoogleFonts.poppins(
                          color: kDarkColor.withOpacity(0.5),
                          fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}

class SupportDetails extends StatelessWidget {
  final String label;
  final String text;
  final IconData icon;
  final void Function() onTap;

  const SupportDetails({this.label, this.text, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            height: 50,
            child: ListView(physics: NeverScrollableScrollPhysics(), children: [
              Text(
                "$label",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              Text("$text", style: GoogleFonts.poppins())
            ]),
          ),
        ),
        Expanded(
            flex: 1,
            child: InkWell(
              onTap: onTap,
              child: Icon(
                icon,
                color: kDarkColor,
              ),
            ))
      ],
    );
  }
}
