import 'dart:convert';
import 'dart:io';

import 'package:code_fields/code_fields.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pinput/pinput.dart';
import 'package:remark_app/apis/candidates/download_resume.dart';
import 'package:remark_app/apis/location/location_api.dart';
import 'package:remark_app/apis/user/UserApi.dart';
import 'package:remark_app/components/appbar/appbar.dart';
import 'package:remark_app/components/loading/circular_loading.dart';
import 'package:remark_app/config/appSetting.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/config/userSetting.dart';
import 'package:remark_app/controllers/auth_controller.dart';
import 'package:remark_app/controllers/profile_controller.dart';
import 'package:remark_app/model/global/global_status_model.dart';
import 'package:remark_app/model/location/location.dart';
import 'package:remark_app/model/user/fetch_user_data.dart';
import 'package:remark_app/pages/homepage/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_cropper/image_cropper.dart';

class EditProfile extends StatefulWidget {
  final String userType;
  final String userID;
  const EditProfile({Key key, this.userID, this.userType}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  ProfileController profileController = Get.put(ProfileController());
  CroppedFile _image;
  FilePickerResult _resume;
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
        child: Text(
          "Company",
          style: GoogleFonts.poppins(),
        ),
        value: "Company"),
    DropdownMenuItem(
      child: Text(
        "Consultancy",
        style: GoogleFonts.poppins(),
      ),
      value: "Consultancy",
    )
  ];

  // EDITING CONTROLLERS
  String _userPhoto;
  String _userMobile;
  String _userToken;
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
  String _userResume;

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

  afterOTPVerified() {
    setState(() {
      _userMobile = _userMobileController.text;
      mobileNumberVerified = true;
      _showVerifyOTP = false;
    });
  }

  fetchUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      userType = widget.userType;
      userID = pref.getString("userID");
      _userToken = pref.getString("userToken");
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
      _userLocationController.text = u.userLocation;
      _userResume = u.userResume;

      if (u.userMobile != "") {
        mobileNumberVerified = true;
      } else {
        mobileNumberVerified = false;
      }

      var jobLocation;

      if (u.userJobLocation.isNotEmpty) {
        jobLocation = jsonDecode(u.userJobLocation);
        _userJobLocationController.text = jobLocation['stringAddress'];
      } else {
        _userJobLocationController.text = "";
      }

      _isLoadingData = false;
    });
  }

  _selectResume() async {
    _resume = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['docx', 'doc', 'pdf'],
        allowMultiple: false,
        allowCompression: true,
        withReadStream: true);

    setState(() {});

    if (_resume != null) {
      if (_resume.files.length != 0) {
        print("File Extension is : ${_resume.files.first.extension}");

        if (_resume.files.first.extension == 'docx' ||
            _resume.files.first.extension == 'doc' ||
            _resume.files.first.extension == 'pdf') {
          print("File Selected : ${_resume.files.first.name}");
        } else {
          _resume.files.clear();
          _resume = null;

          SnackBar snackBar =
              SnackBar(content: Text("Please select only docx, doc or pdf"));

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        print("Resume not selected");
      }
    } else {
      print("File Select aborted");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [ApplicationAppBar()],
          iconTheme: IconThemeData(color: kDarkColor)),
      body: SafeArea(
          child: !_isLoadingData
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        width: size.width,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Column(
                          children: [
                            Container(
                              height: 150,
                              decoration: BoxDecoration(
                                  color: kDarkColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Center(
                                child: Stack(children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.white,
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: _image == null
                                            ? _userPhoto.isNotEmpty
                                                ? CircleAvatar(
                                                    backgroundColor:
                                                        Colors.white,
                                                    radius: 50,
                                                    backgroundImage:
                                                        NetworkImage(base_url +
                                                            _userPhoto),
                                                  )
                                                : Image.asset(
                                                    'assets/logo/logo.png')
                                            : CircleAvatar(
                                                radius: 50,
                                                backgroundImage: FileImage(
                                                  File(_image.path),
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                  if (_image != null)
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
                                              shape: BoxShape.circle),
                                          child: Icon(
                                            Icons.close,
                                            size: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: InkWell(
                                          onTap: () async {
                                            print("ask for upload image");

                                            FilePickerResult pick =
                                                await FilePicker
                                                    .platform
                                                    .pickFiles(
                                                        type: FileType.image);

                                            CroppedFile croppedFile =
                                                await ImageCropper().cropImage(
                                                    sourcePath:
                                                        pick.files.first.path);

                                            if (croppedFile.path != null) {
                                              setState(() {
                                                _image = croppedFile;
                                              });
                                            } else {
                                              print(
                                                  "user cancelled the process");
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.4),
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
                                if (value.length == 10 &&
                                    value != _userMobile) {
                                  _showVerifyOTP = true;
                                } else {
                                  _showVerifyOTP = false;
                                }
                                setState(() {});
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.numberWithOptions(
                                  signed: true, decimal: true),
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  labelText: "Mobile Number",
                                  labelStyle: GoogleFonts.poppins(),
                                  hintText: "+91",
                                  border: OutlineInputBorder(),
                                  enabled:
                                      _userMobile.isNotEmpty ? false : true,
                                  suffix: _showVerifyOTP
                                      ? verifyOTP()
                                      : SizedBox()),
                            ),
                            if (userType != "2")
                              SizedBox(
                                height: 10,
                              ),
                            if (userType != "2")
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
                            if (userType == "1")
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
                            if (userType == "1")
                              SizedBox(
                                height: 10,
                              ),
                            if (userType == "1")
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
                            if (userType == "1")
                              SizedBox(
                                height: 10,
                              ),
                            if (userType == "1")
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
                            if (userType == "1")
                              SizedBox(
                                height: 10,
                              ),
                            if (userType == "1")
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
                            if (userType == "1")
                              SizedBox(
                                height: 10,
                              ),
                            // - - @TODO - -
                            if (userType == "1")
                              SizedBox(
                                height: 10,
                              ),
                            if (userType == "1")
                              TextFormField(
                                controller: _userLocationController,
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    labelText: "Location",
                                    labelStyle: GoogleFonts.poppins(),
                                    hintText: "Indore, Madhya Pradesh",
                                    border: OutlineInputBorder()),
                              ),
                            if (userType == "1")
                              SizedBox(
                                height: 10,
                              ),
                            if (userType == "1")
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
                            if (userType == "2")
                              SizedBox(
                                height: 10,
                              ),
                            if (userType == "2")
                              TextFormField(
                                controller: _userOrganizationController,
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    labelText: "Organization Name",
                                    labelStyle: GoogleFonts.poppins(),
                                    border: OutlineInputBorder()),
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            if (userType == "2")
                              DropdownButtonFormField(
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    border: OutlineInputBorder()),
                                value: _userOrganizationType == "0"
                                    ? "Company"
                                    : "Consultancy",
                                hint: Text(
                                  "Select Company Type",
                                  style: GoogleFonts.poppins(),
                                ),
                                items: [
                                  DropdownMenuItem(
                                      child: Text(
                                        "Company",
                                        style: GoogleFonts.poppins(),
                                      ),
                                      value: "Company"),
                                  DropdownMenuItem(
                                    child: Text(
                                      "Consultancy",
                                      style: GoogleFonts.poppins(),
                                    ),
                                    value: "Consultancy",
                                  )
                                ],
                                onChanged: (value) {
                                  print(value.toString());
                                  String _selected = "";
                                  if (value.toString() == "Company") {
                                    _selected = "0";
                                  } else {
                                    _selected = "1";
                                  }

                                  setState(() {
                                    _userOrganizationType = _selected;
                                  });
                                },
                              ),
                            if (userType == "1") SizedBox(height: 10),
                            if (userType == "1")
                              _userResume.isEmpty && _resume == null
                                  ? InkWell(
                                      onTap: () async {
                                        _selectResume();
                                      },
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 40),
                                        color: kDarkColor,
                                        child: Center(
                                          child: Text(
                                            "Upload Resume",
                                            style: GoogleFonts.poppins(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              _selectResume();
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15),
                                              color: kDarkColor,
                                              child: Center(
                                                child: Text(
                                                  "Change Resume",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: _userResume.isNotEmpty &&
                                                  _resume == null
                                              ? InkWell(
                                                  onTap: () async {
                                                    print("View Resume");
                                                    final res =
                                                        await DownloadResume()
                                                            .downloadCandidateResume(
                                                                user.data
                                                                    .userResume,
                                                                user.data
                                                                    .userName);

                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content:
                                                          Text(res['message']),
                                                    ));
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 15),
                                                    color: kLightColor,
                                                    child: Center(
                                                      child: Text(
                                                        "View Resume",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      _resume.files.clear();
                                                      _resume = null;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 15),
                                                    color: Colors.redAccent,
                                                    child: Center(
                                                      child: Text(
                                                        "Remove Resume",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ],
                                    ),
                            SizedBox(
                              height: 10,
                            ),
                            !_isUpdatingProfile
                                ? MaterialButton(
                                    color: kDarkColor,
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    textColor: Colors.white,
                                    onPressed: () async {
                                      var imagePath;

                                      if (_image != null) {
                                        imagePath = _image.path;

                                        print("image changed");
                                      } else {
                                        print("same as before");
                                        imagePath = "";
                                      }

                                      var resumePath;

                                      if (_resume == null ||
                                          _resume.files.length == 0) {
                                        resumePath = "";
                                      } else {
                                        resumePath = _resume.files.first.path;
                                      }

                                      if (_userNameController.text == "") {
                                        AppSetting.showSnackbar(
                                          title: "Validation Failed",
                                          message: "Name is required",
                                        );

                                        return false;
                                      }

                                      if (_userEmailController.text == "") {
                                        AppSetting.showSnackbar(
                                          title: "Validation Failed",
                                          message: "Email is required",
                                        );

                                        return false;
                                      }

                                      Map<String, dynamic> data = {
                                        "user_name":
                                            _userNameController.text ?? "",
                                        "user_email":
                                            _userEmailController.text ?? "",
                                        "user_type": widget.userType,
                                        "user_mobile": mobileNumberVerified
                                            ? _userMobileController.text
                                            : ""
                                      };

                                      if (userType == "2") {
                                        if (_userOrganizationController.text ==
                                            "") {
                                          AppSetting.showSnackbar(
                                            title: "Validation Failed",
                                            message:
                                                "Organization Name is required",
                                          );

                                          return false;
                                        }

                                        if (_userOrganizationType.toString() ==
                                            "") {
                                          AppSetting.showSnackbar(
                                            title: "Validation Failed",
                                            message:
                                                "Please Select Organization Type",
                                          );

                                          return false;
                                        }

                                        data.addAll({
                                          "user_organization":
                                              _userOrganizationController
                                                      .text ??
                                                  "",
                                          "user_organization_type":
                                              _userOrganizationType
                                                      .toString() ??
                                                  ""
                                        });
                                      } else {
                                        if (_userBioController.text == "") {
                                          AppSetting.showSnackbar(
                                            title: "Validation Failed",
                                            message: "Bio is required",
                                          );

                                          return false;
                                        }

                                        if (_userSkillsController.text == "") {
                                          AppSetting.showSnackbar(
                                            title: "Validation Failed",
                                            message: "Skills is required",
                                          );

                                          return false;
                                        }

                                        if (_userQualificationController.text ==
                                            "") {
                                          AppSetting.showSnackbar(
                                            title: "Validation Failed",
                                            message:
                                                "Qualification is required",
                                          );

                                          return false;
                                        }

                                        if (_userLocationController.text ==
                                            "") {
                                          AppSetting.showSnackbar(
                                            title: "Validation Failed",
                                            message: "Location is required",
                                          );

                                          return false;
                                        }

                                        data.addAll({
                                          "user_bio":
                                              _userBioController.text ?? "",
                                          "user_skills":
                                              _userSkillsController.text ?? "",
                                          "user_experience":
                                              _userExpController.text ?? "",
                                          "user_qualifications":
                                              _userQualificationController
                                                      .text ??
                                                  "",
                                          "user_languages":
                                              _userLangController.text ?? "",
                                          "user_location":
                                              _userLocationController.text ??
                                                  "",
                                          "user_job_location": jsonEncode({
                                                "stringAddress":
                                                    _userJobLocationController
                                                        .text,
                                                "arrayAddress":
                                                    _userJobLocationController
                                                        .text
                                                        .split(",")
                                              }) ??
                                              ""
                                        });
                                      }

                                      setState(() {
                                        _isUpdatingProfile = true;
                                      });

                                      print(jsonEncode(data));

                                      final updateReport = await UserApi()
                                          .updateUserDetails(
                                              userID,
                                              jsonEncode(data),
                                              imagePath,
                                              resumePath);

                                      if (updateReport.status) {
                                        final user = await UserApi()
                                            .fetchUserData(widget.userID);

                                        if (user.status) {
                                          UserSetting.setUserSessionData(user);

                                          pushNewScreen(context,
                                              withNavBar: false,
                                              customPageRoute:
                                                  MaterialPageRoute(
                                                builder: (context) => HomePage(
                                                  userType: userType,
                                                ),
                                              ));
                                        }

                                        var snackBar = SnackBar(
                                          content: Text(
                                              "Profile Updated Successfully",
                                              style: GoogleFonts.poppins()),
                                        );
                                        setState(() {
                                          _isUpdatingProfile = false;
                                        });

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);

                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => HomePage(
                                                    userType: userType)));
                                      } else {
                                        print("${updateReport.data}");
                                        setState(() {
                                          _isUpdatingProfile = false;
                                        });

                                        var snackBar = SnackBar(
                                          content: Text(
                                              updateReport.data.toString(),
                                              style: GoogleFonts.poppins()),
                                        );

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Update Profile",
                                            style: GoogleFonts.poppins()),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(Icons.arrow_right_alt_rounded)
                                      ],
                                    ),
                                  )
                                : CircularLoading(),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : CircularLoading()),
    );
  }

  Widget verifyOTP() {
    return GestureDetector(
      onTap: () async {
        print('start verifying mobile number');
        final res =
            await UserApi().startVerifyMobileNumber(_userMobileController.text);

        print(res.toJson());

        if (res.status) {
          var generatedOTP = "0000";
          var insertedOTP = "1234";
          setState(() {
            generatedOTP = res.data.toString();
          });
          TextEditingController _otp = TextEditingController();

          bool isLoading = false;

          return showBarModalBottomSheet(
            useRootNavigator: true,
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "OTP Sent Successfully",
                              style: GoogleFonts.poppins(color: kDarkColor),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Pinput(
                                  androidSmsAutofillMethod:
                                      AndroidSmsAutofillMethod.smsRetrieverApi,
                                  controller: _otp,
                                  onCompleted: (value) {
                                    insertedOTP = value;
                                  },
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            !isLoading
                                ? MaterialButton(
                                    onPressed: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      if (insertedOTP == generatedOTP) {
                                        final res = await UserApi()
                                            .updateVerifiedMobileNumber(
                                                _userMobileController.text);

                                        if (res.status) {
                                          afterOTPVerified();
                                          Get.back();

                                          AppSetting.showSnackbar(
                                              title: 'Mobile Number Verified',
                                              message:
                                                  'Mobile Number is verified & updated',
                                              type: 'success');
                                        } else {
                                          setState(() {
                                            mobileNumberVerified = false;
                                          });
                                          AppSetting.showSnackbar(
                                              title: 'Validation Failed',
                                              message:
                                                  'entered otp is incorrect');
                                        }
                                      } else {
                                        // print(_otpText);
                                        setState(() {
                                          mobileNumberVerified = false;
                                          isLoading = false;
                                        });
                                        AppSetting.showSnackbar(
                                            title: 'Validation Failed',
                                            message:
                                                'entered otp is incorrect');
                                      }
                                    },
                                    child: Text(
                                      "Verify",
                                      style: GoogleFonts.poppins(),
                                    ),
                                    textColor: Colors.white,
                                    color: kDarkColor,
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    elevation: 8,
                                  )
                                : CircularLoading()
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
      },
      child: Text(
        "Verify",
        style: GoogleFonts.poppins(
            color: kDarkColor, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}
