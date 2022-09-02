import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:remark_app/apis/company/company_api.dart';
import 'package:remark_app/apis/location/location_api.dart';
import 'package:remark_app/components/loading/circular_loading.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/notifier/select_company_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_select/smart_select.dart';

class CreateCompany extends StatefulWidget {
  const CreateCompany({Key key}) : super(key: key);

  @override
  _CreateCompanyState createState() => _CreateCompanyState();
}

class _CreateCompanyState extends State<CreateCompany> {
  FilePickerResult _image;
  bool _isCreating = false;
  String userID;
  final _formKey = GlobalKey<FormState>();
  List<S2Choice<String>> _locations = <S2Choice<String>>[];
  TextEditingController _companyName = TextEditingController();
  TextEditingController _companyWebsite = TextEditingController();
  TextEditingController _companyEmail = TextEditingController();
  TextEditingController _companyLocation = TextEditingController();
  String _selectedLocation = "";
  TextEditingController _companyDescription = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
  }

  getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userID = pref.getString("userID");
    });
  }

  getLocation() async {
    List<S2Choice<String>> _tempLocation = [];

    await Location().cityState().then((value) {
      value.data.forEach((element) {
        _tempLocation.add(S2Choice(value: element.place, title: element.place));
      });

      setState(() {
        _locations = _tempLocation;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: size.height,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Form(
            autovalidateMode: AutovalidateMode.always,
            child: ListView(
              children: [
                GestureDetector(
                  onTap: () async {
                    try {
                      await FilePicker.platform
                          .pickFiles(type: FileType.image)
                          .then((file) {
                        if (file != null) {
                          print(file.files.single.path);
                          setState(() {
                            _image = file;
                          });
                        } else {
                          print("user cancelled the process");
                        }
                      });
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 100,
                    height: 120,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30.0),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            backgroundImage: _image != null
                                ? FileImage(File(_image.files.single.path))
                                : AssetImage(application_logo),
                          ),
                        ),
                        Positioned(
                          bottom: 25,
                          right: 0,
                          child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: kDarkColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Icon(
                                Icons.add_a_photo_outlined,
                                size: 14,
                                color: Colors.white,
                              )),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(),
                TextFormField(
                  controller: _companyName,
                  decoration: InputDecoration(
                      labelText: "Company Name",
                      labelStyle: GoogleFonts.poppins(fontSize: 14),
                      prefixIcon: Icon(Icons.verified)),
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: _companyWebsite,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                      labelText: "Company Website",
                      labelStyle: GoogleFonts.poppins(fontSize: 14),
                      hintText: "https://example.com",
                      prefixIcon: Icon(Icons.web)),
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: _companyEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "Business Email",
                      labelStyle: GoogleFonts.poppins(fontSize: 14),
                      hintText: "example@gmail.com",
                      prefixIcon: Icon(Icons.email)),
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: _companyLocation,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.place),
                      labelText: "Company Address",
                      labelStyle: GoogleFonts.poppins(fontSize: 14)),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _companyDescription,
                  maxLines: 3,
                  decoration: InputDecoration(
                      labelText: "Description",
                      labelStyle: GoogleFonts.poppins(fontSize: 14),
                      prefixIcon: Icon(Icons.add)),
                ),
                SizedBox(
                  height: 15,
                ),
                !_isCreating
                    ? MaterialButton(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        elevation: 10,
                        onPressed: () async {
                          setState(() {
                            _isCreating = true;
                          });

                          var companyData = jsonEncode({
                            "company_name": _companyName.text ?? "",
                            "company_website": _companyWebsite.text ?? "",
                            "company_email": _companyEmail.text ?? "",
                            "company_location": _companyLocation.text ?? "",
                            "company_des": _companyDescription.text ?? ""
                          });

                          var imagePath = "";

                          if (_image != null) {
                            imagePath = _image.files.single.path;
                          }

                          print(companyData);

                          await CompanyApi()
                              .createCompany(
                                  imagePath, companyData.toString(), userID)
                              .then((response) async {
                            if (response.status) {
                              await CompanyApi()
                                  .fetchCompanyByID(response.data.toString())
                                  .then((value) {
                                print(value.data.companyId);
                                Provider.of<SelectCompanyNotifier>(context,
                                        listen: false)
                                    .select(value.data.companyId.toString(),
                                        true, true, value.data);

                                Navigator.pop(context);
                              });
                            } else {
                              setState(() {
                                _isCreating = false;
                              });

                              var snackBar = SnackBar(
                                  content: Text(
                                      "Something went wrong, Please try again later"));

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          });
                        },
                        child: Text("Create Company"),
                        color: kDarkColor,
                        textColor: Colors.white,
                      )
                    : CircularLoading()
              ],
            )),
      ),
    );
  }
}
