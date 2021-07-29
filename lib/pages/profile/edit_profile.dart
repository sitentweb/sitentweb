import 'dart:convert';
import 'dart:io';
import 'package:code_fields/code_fields.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:remark_app/apis/location/location_api.dart';
import 'package:remark_app/apis/user/UserApi.dart';
import 'package:remark_app/components/loading/circular_loading.dart';
import 'package:remark_app/config/appSetting.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/global/global_status_model.dart';
import 'package:remark_app/model/location/location.dart';
import 'package:remark_app/model/user/fetch_user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  final String userID;
  const EditProfile({Key key, this.userID}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  FilePickerResult _image;
  String userType = "";
  String userID;
  FetchUserDataModel user;
  bool _isLoadingData = false;
  bool _showVerifyOTP = false;
  bool _isUpdatingProfile = false;
  bool mobileNumberVerified = false;
  List<LocationSearchModel> locationSearch = <LocationSearchModel>[];
  List<DropdownMenuItem> _selectOrganizationType = <DropdownMenuItem>[
    DropdownMenuItem(
        child: Text("Company" , style: GoogleFonts.poppins(),),
        value: "Company"
    ),
    DropdownMenuItem(
      child: Text("Consultancy" , style: GoogleFonts.poppins(),),
      value: "Consultancy",
    )
  ];

  // EDITING CONTROLLERS
  String _userPhoto;
  String _userMobile;
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _userMobileController = TextEditingController();
  TextEditingController _userBioController = TextEditingController();
  TextEditingController _userSkillsController = TextEditingController();
  TextEditingController _userExpController = TextEditingController();
  TextEditingController _userQualificationController = TextEditingController();
  TextEditingController _userLangController = TextEditingController();
  TextEditingController _userLocationController = TextEditingController();
  TextEditingController _userJobLocationController = TextEditingController();
  TextEditingController _userOrganizationController = TextEditingController();
  String _userOrganizationType;

  @override
  void initState() {
    // TODO: implement initState
    _isLoadingData = true;
    fetchUserData();
    super.initState();
  }

  Future<List<LocationSearchModel>> fetchSearchLocation(searchString) async {
    List<LocationSearchModel> location = <LocationSearchModel>[];

    location.clear();

    await Location().fetchSearchedLocation(searchString).then((value) {
      value.forEach((element) {
        location.add(element);
      });
    });

    return location;
  }

  fetchUserData() async {

    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      userType = pref.getString("userType");
      userID = pref.getString("userID");
    });

    user = await UserApi().fetchUserData(widget.userID);
    print(widget.userID);
    Data u = user.data;

    setState(() {
      _userPhoto = u.userPhoto;
      _userMobile = u.userMobile;
      _userNameController.text = u.userName;
      _userEmailController.text = u.userEmail;
      _userBioController.text = u.userBio;
      _userMobileController.text = u.userMobile;
      _userSkillsController.text = u.userSkills;
      _userExpController.text = u.userExperience;
      _userQualificationController.text = u.userQualifications;
      _userLangController.text = u.userLanguages;
      _userOrganizationController.text = u.userOrganization;
      _userOrganizationType = u.userOrganizationType;

      var jobLocation;

      if (u.userJobLocation.isNotEmpty) {
        jobLocation = jsonDecode(u.userJobLocation);
        _userJobLocationController.text =
        jobLocation['stringAddress'];
      } else {
        _userJobLocationController.text = "";
      }

      _isLoadingData = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: !_isLoadingData ? Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                      color: kLightColor.withOpacity(0.5),
                      borderRadius:
                      BorderRadius.all(Radius.circular(20))),
                  child: Center(
                    child: Stack(children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 38,
                          backgroundColor: kLightColor,
                          backgroundImage: _image == null ?
                          AppSetting.showUserImage(_userPhoto) :
                          FileImage(File(_image.files.single.path)),
                          foregroundColor:
                          Colors.black.withOpacity(0.5),
                        ),
                      ),
                      if(_image != null)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _image = null;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle
                            ),
                            child: Icon(Icons.close , size: 10, color: Colors.white,),
                          ),
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                              onTap: () async {
                                print("ask for upload image");
                                FilePickerResult pick = await FilePicker
                                    .platform
                                    .pickFiles(type: FileType.image);

                                if (pick != null) {
                                  setState(() {
                                    _image = pick;
                                  });
                                } else {
                                  print("user cancelled the process");
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color:
                                    Colors.white.withOpacity(0.4),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20))),
                                child: Icon(
                                  Icons.add_a_photo,
                                  color: kDarkColor,
                                  size: 16,
                                ),
                              )))
                    ]),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _userNameController,
                  decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 10),
                      labelText: "Name",
                      labelStyle: GoogleFonts.poppins(),
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _userEmailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 10),
                      labelText: "Email",
                      labelStyle: GoogleFonts.poppins(),
                      hintText: "example@domain.com",
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _userMobileController,
                  maxLength: 10,
                  onChanged: (value) {

                    if(value.length == 10 && value != _userMobile){

                        _showVerifyOTP = true;

                    }else{
                      _showVerifyOTP = false;
                    }
                    setState(() {

                    });
                  },
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: true, signed: false),
                  decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 10),
                      labelText: "Mobile Number",
                      labelStyle: GoogleFonts.poppins(),
                      hintText: "+91",
                      border: OutlineInputBorder(),
                      suffix: _showVerifyOTP ? verifyOTP() : SizedBox(width: 0,)
                  ),
                ),
                if(userType != "2")
                SizedBox(
                  height: 10,
                ),
                if(userType != "2")
                TextFormField(
                  controller: _userBioController,
                  maxLines: 3,
                  maxLength: 180,
                  decoration: InputDecoration(
                      labelText: "Self Intro",
                      labelStyle: GoogleFonts.poppins(),
                      hintText: "Hey, I am John Doe from India",
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 10,
                ),
                 if(userType == "1")
                 TextFormField(
                  controller: _userSkillsController,
                  decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 10),
                      labelText: "Skills",
                      labelStyle: GoogleFonts.poppins(),
                      hintText: "HTML, CSS",
                      border: OutlineInputBorder()),
                ),
                if(userType == "1")
                SizedBox(
                  height: 10,
                ),
                if(userType == "1")
                TextFormField(
                  controller: _userExpController,
                  decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 10),
                      labelText: "Experience",
                      labelStyle: GoogleFonts.poppins(),
                      hintText: "5 yrs",
                      border: OutlineInputBorder()),
                ),
                if(userType == "1")
                SizedBox(
                  height: 10,
                ),
                if(userType == "1")
                TextFormField(
                  controller: _userQualificationController,
                  decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 10),
                      labelText: "Qualification",
                      labelStyle: GoogleFonts.poppins(),
                      hintText: "B.com, B.sc",
                      border: OutlineInputBorder()),
                ),
                if(userType == "1")
                SizedBox(
                  height: 10,
                ),
                if(userType == "1")
                TextFormField(
                  controller: _userLangController,
                  decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 10),
                      labelText: "Languages",
                      labelStyle: GoogleFonts.poppins(),
                      hintText: "English, Hindi",
                      border: OutlineInputBorder()),
                ),
                if(userType == "1")
                SizedBox(
                  height: 10,
                ),
                // - - @TODO - -
                if(userType == "1")
                SizedBox(
                  height: 10,
                ),
                if(userType == "1")
                TextFormField(
                  controller: _userJobLocationController,
                  decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 10),
                      labelText: "Job Location",
                      labelStyle: GoogleFonts.poppins(),
                      hintText: "Indore, Bhopal, Ratlam",
                      border: OutlineInputBorder()),
                ),
                if(userType == "2")
                  SizedBox(
                    height: 10,
                  ),
                if(userType == "2")
                  TextFormField(
                    controller: _userOrganizationController,
                    decoration: InputDecoration(
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10),
                        labelText: "Organization Name",
                        labelStyle: GoogleFonts.poppins(),
                        border: OutlineInputBorder()
                    ),
                  ),
                SizedBox(
                  height: 10,
                ),
                if(userType == "2")
                  DropdownButtonFormField(
                      decoration: InputDecoration(
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder()
                      ),
                     value: _userOrganizationType == "0" ? "Company" : "Consultancy",
                     hint: Text("Select Company Type" , style: GoogleFonts.poppins(),),
                     items: [
                       DropdownMenuItem(
                         child: Text("Company" , style: GoogleFonts.poppins(),),
                         value: "Company"
                       ),
                       DropdownMenuItem(
                         child: Text("Consultancy" , style: GoogleFonts.poppins(),),
                         value: "Consultancy",
                       )
                     ],
                    onChanged: (value) {
                      print(value.toString());
                      String _selected = "";
                      if(value.toString() == "Company"){
                        _selected = "0";
                      }else{
                        _selected = "1";
                      }

                      setState(() {
                        _userOrganizationType = _selected;
                      });
                    },
                  ),
                SizedBox(height: 10,),
                !_isUpdatingProfile ? MaterialButton(
                  color: kDarkColor,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  textColor: Colors.white,
                  onPressed: () async {

                    setState(() {
                      _isUpdatingProfile = true;
                    });

                    var imagePath;

                    if(_image != null){

                      imagePath = _image.files.single.path;

                      print("image changed");
                    }else{
                      print("same as before");
                      imagePath = "";
                    }

                    print(_userNameController.text);
                    print(_userEmailController.text);
                    print(_userMobileController.text);
                    print(_userOrganizationController.text);
                    print(_userOrganizationType);

                    Map<String, dynamic> data = {
                      "user_name" : _userNameController.text ?? "",
                      "user_email" : _userEmailController.text ?? ""
                    };

                    if(userType == "2"){
                      data.addAll({
                        "user_organization" : _userOrganizationController.text ?? "",
                        "user_organization_type" : _userOrganizationType.toString() ?? ""
                      });
                    }else{


                    }

                    print(jsonEncode(data));


                    final updateReport = await UserApi().updateUserDetails(userID, jsonEncode(data) , imagePath);

                    if(updateReport.status){

                      var snackBar = SnackBar(
                        content: Text("Profile Updated Successfully" , style: GoogleFonts.poppins()),
                      );
                      setState(() {
                        _isUpdatingProfile = false;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    }else{
                      print("Something went wrong");
                      _isUpdatingProfile = false;

                      var snackBar = SnackBar(
                        content: Text("Something went wrong" , style: GoogleFonts.poppins()),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    }

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Update Profile" , style: GoogleFonts.poppins(
                      )),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.arrow_right_alt_rounded)
                    ],
                  ),
                ) : CircularLoading() ,
                SizedBox(
                  height: 10,
                ),

              ],
            ),
          ),
        ) : CircularLoading()
      ),
    );
  }

  Widget verifyOTP() {
    return GestureDetector(
      onTap: () async {

        String _generatedOTP = "";
        var _otpText = AppSetting.randomOTPGenerator();

        setState(() {
          _generatedOTP = _otpText.toString();
        });

        String _validateOTP = "";

        bool smsSent = true;

        if(smsSent){

          var snackBar = SnackBar(
            content: Text("Your One Time OTP is $_otpText"),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          CodeFieldsController _otp = CodeFieldsController();

          showBarModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("OTP Sent Successfully" , style: GoogleFonts.poppins(
                          color: kDarkColor
                      ),),
                      SizedBox(height: 5,),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CodeFields(
                            controller: _otp,
                            length: 4,
                            inputDecoration: InputDecoration(
                              fillColor: kLightColor,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none),
                            ),
                            closeOnFinish: true,
                            textStyle: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                            onChanged: (code) {
                              print(code);
                            },
                            onCompleted: (code) {
                              setState(() {
                                _validateOTP = code;
                              });
                            },
                          )
                      ),
                      SizedBox(height: 10,),
                      MaterialButton(
                        onPressed: () async {
                          print(_validateOTP);
                          if(_validateOTP == _generatedOTP){
                            print("you can go ahead");

                            GlobalStatusModel login = await UserApi().updateMobileNumber(widget.userID, _userMobileController.text, _generatedOTP);

                            if(login.status){

                              SharedPreferences pref = await SharedPreferences.getInstance();

                              pref.setString("userMobile", _userMobileController.text);
                              setState(() {
                                mobileNumberVerified = true;
                              });
                            }

                          }else{
                            print(_otpText);
                            setState(() {
                              mobileNumberVerified = false;
                            });
                            print("incorrect otp");
                          }
                        },
                        child: Text("Verify" , style: GoogleFonts.poppins(),),
                        textColor: Colors.white,
                        color: kDarkColor,
                        padding: EdgeInsets.symmetric(
                            vertical: 15
                        ),
                        elevation: 8,
                      )
                    ],
                  ),
                ),
              );
            },
          );


        }else{
          var snackBar = SnackBar(content: Text("Something went wrong"));

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }



      },
      child: Text("Verify" , style: GoogleFonts.poppins(
        color: kDarkColor,
        fontWeight: FontWeight.bold,
        fontSize: 12
      ),),
    );
  }
}
