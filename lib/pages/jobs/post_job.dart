import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:remark_app/apis/company/company_api.dart';
import 'package:remark_app/apis/education/education_api.dart';
import 'package:remark_app/apis/industry/industry_api.dart';
import 'package:remark_app/apis/jobs/post_job.dart';
import 'package:remark_app/components/empty/empty_data.dart';
import 'package:remark_app/components/loading/circular_loading.dart';
import 'package:remark_app/config/appSetting.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/company/fetch_company_model.dart';
import 'package:remark_app/model/company/fetch_user_company_model.dart';
import 'package:remark_app/notifier/select_company_notifier.dart';
import 'package:remark_app/pages/candidates/search_candidates.dart';
import 'package:remark_app/pages/company/create_company.dart';
import 'package:remark_app/pages/jobs/search_job.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostJob extends StatefulWidget {
  const PostJob({Key key}) : super(key: key);

  @override
  _PostJobState createState() => _PostJobState();
}

class _PostJobState extends State<PostJob> {
  var userType;
  var userID;
  List<DropdownMenuItem> _educationList = [];
  List<DropdownMenuItem> _industryList = [];
  List _experiences = [];
  List _skillTags = [];
  String _company = "";
  bool _companyStatus = false;
  bool _companySelected = false;
  Data _companyData = Data();
  bool _isJobPosting = false;

  // TEXT EDITING CONTROLLERS

  TextEditingController _jobTitleController = TextEditingController();
  TextEditingController _skillController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String _education = "";
  TextEditingController _qualificationController = TextEditingController();
  String _industry = "";
  TextEditingController _hireController = TextEditingController();
  TextEditingController _minSalaryController = TextEditingController();
  TextEditingController _maxSalaryController = TextEditingController();
  String _jobType = "";
  List _skills = [];

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    _getEducationList().then((value) {
      setState(() {
        _educationList = value;
      });
    });

    _getIndustryList().then((value) {
      setState(() {
        _industryList = value;
      });
    });

    super.initState();
  }

  getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userType = pref.getString("userType");
      userID = pref.getString("userID");
    });
  }

  Future<List<DropdownMenuItem>> _getEducationList() async {
    List<DropdownMenuItem> _tempEdu = [];
    await EducationApi().fetchEducation().then((educations) {
      educations.data.forEach((education) {
        _tempEdu.add(DropdownMenuItem(
          child: Text(
            "${education.educationName}",
            style: GoogleFonts.poppins(color: Colors.black),
          ),
          value: education.educationName,
        ));
      });
    });

    return _tempEdu;
  }

  Future<List<DropdownMenuItem>> _getIndustryList() async {
    List<DropdownMenuItem> _tempInd = [];
    await IndustryApi().fetchIndustries().then((industries) {
      industries.data.forEach((industry) {
        _tempInd.add(DropdownMenuItem(
            child: Text("${industry.industryTitle}",
                style: GoogleFonts.poppins(color: Colors.black)),
            value: industry.industryTitle));
      });
    });

    return _tempInd;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData.fallback(),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Hero(
            tag: "splashscreenImage",
            child: Container(
                child: Image.asset(
              application_logo,
              width: 40,
            ))),
        actions: [
          InkWell(
              onTap: () {
                if (userType == "2") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchCandidates(),
                      ));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchJobs(),
                      ));
                }
              },
              child: Container(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.search,
                    color: kDarkColor,
                  )))
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            children: [
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    "Post New Job",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kDarkColor.withOpacity(1)),
                  )),
              TextField(
                controller: _jobTitleController,
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                    labelText: "Job Title",
                    labelStyle: GoogleFonts.poppins(fontSize: 14)),
              ),
              SizedBox(height: 5),
              TextField(
                controller: _descriptionController,
                style: GoogleFonts.poppins(fontSize: 14),
                maxLines: 3,
                maxLength: 150,
                decoration: InputDecoration(
                    labelText: "Description",
                    labelStyle: GoogleFonts.poppins()),
              ),
              SizedBox(
                height: 5,
              ),
              DropdownButtonFormField(
                style: GoogleFonts.poppins(),
                items: _educationList,
                onChanged: (value) {
                  setState(() {
                    _education = value.toString();
                  });
                },
                hint: Text("Select Education"),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: _qualificationController,
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                    labelText: "Qualifications",
                    labelStyle: GoogleFonts.poppins(fontSize: 14)),
              ),
              SizedBox(
                height: 5,
              ),
              DropdownButtonFormField(
                style: GoogleFonts.poppins(),
                items: _industryList,
                onChanged: (value) {
                  setState(() {
                    _industry = value.toString();
                  });
                },
                hint: Text("Select Industry"),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: _hireController,
                style: GoogleFonts.poppins(fontSize: 14),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Total Hiring",
                    labelStyle: GoogleFonts.poppins(fontSize: 14)),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _minSalaryController,
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: false, signed: false),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: "Min Salary",
                        labelStyle: GoogleFonts.poppins(fontSize: 14),
                        helperText: "Per Year",
                        helperStyle: GoogleFonts.poppins(),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "-",
                    style: GoogleFonts.poppins(),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _maxSalaryController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          labelText: "Max Salary",
                          labelStyle: GoogleFonts.poppins(fontSize: 14),
                          helperText: "Per Year",
                          helperStyle: GoogleFonts.poppins()),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              DropdownButtonFormField(
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
                hint: Text(
                  "Select Job Type",
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
                items: [
                  DropdownMenuItem(
                    child: Text("Part Time"),
                    value: "Part Time",
                  ),
                  DropdownMenuItem(
                    child: Text("Full time"),
                    value: "Full Time",
                  ),
                  DropdownMenuItem(
                    child: Text("Work From Home"),
                    value: "Work From Home",
                  )
                ],
                onChanged: (value) {
                  setState(() {
                    _jobType = value.toString();
                  });
                },
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: _skillController,
                decoration: InputDecoration(
                    labelText: "Skills",
                    labelStyle: GoogleFonts.poppins(fontSize: 14)),
                onSubmitted: (value) {
                  _skillTags.add(value);
                  _skillController.text = "";
                  setState(() {});
                },
              ),
              SizedBox(
                height: 5,
              ),
              if (_skillTags.isNotEmpty)
                Container(
                  child: Tags(
                    itemCount: _skillTags.length,
                    itemBuilder: (index) {
                      return ItemTags(
                        onPressed: (i) {
                          _skillTags.removeAt(index);
                          setState(() {});
                        },
                        color: kDarkColor,
                        activeColor: kDarkColor,
                        index: index,
                        title: _skillTags[index],
                        removeButton: ItemTagsRemoveButton(
                          onRemoved: () {
                            _skillTags.removeAt(index);
                            setState(() {});
                            return true;
                          },
                        ),
                      );
                    },
                  ),
                ),
              SizedBox(
                height: 5,
              ),
              ListTile(
                title: Text(
                  "Min Experience",
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
                trailing: GestureDetector(
                  onTap: () {
                    final _formKey = GlobalKey<FormState>();

                    TextEditingController _experienceIn =
                        TextEditingController();
                    TextEditingController _experienceYear =
                        TextEditingController();
                    TextEditingController _experienceMonth =
                        TextEditingController();

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Experience Details",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 250,
                              child: Form(
                                key: _formKey,
                                child: ListView(
                                  physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    TextFormField(
                                      controller: _experienceIn,
                                      validator: (value) {
                                        if (value.isEmpty || value == null) {
                                          return "Experience Title is required";
                                        }
                                        return null;
                                      },
                                      style: GoogleFonts.poppins(),
                                      decoration: InputDecoration(
                                          labelText: "Experience In",
                                          labelStyle: GoogleFonts.poppins(),
                                          hintText: "PHP, HTML",
                                          hintStyle: GoogleFonts.poppins()),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: _experienceYear,
                                            validator: (value) {
                                              if (value.isEmpty ||
                                                  value == null) {
                                                return "Year is required";
                                              }
                                              return null;
                                            },
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                    decimal: false,
                                                    signed: false),
                                            style: GoogleFonts.poppins(),
                                            decoration: InputDecoration(
                                                labelText: "Year",
                                                hintText: "00"),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "-",
                                          style: GoogleFonts.poppins(),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller: _experienceMonth,
                                            validator: (value) {
                                              if (value.isEmpty ||
                                                  value == null) {
                                                return "Month is required";
                                              }
                                              return null;
                                            },
                                            keyboardType: TextInputType.number,
                                            style: GoogleFonts.poppins(),
                                            decoration: InputDecoration(
                                                labelText: "Month",
                                                hintText: "01"),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Spacer(),
                                        MaterialButton(
                                          color: kDarkColor,
                                          elevation: 5,
                                          onPressed: () {
                                            if (_formKey.currentState
                                                .validate()) {
                                              _experiences.add(jsonEncode({
                                                "ExperienceTitle":
                                                    _experienceIn.text,
                                                "ExperienceYear":
                                                    _experienceYear.text,
                                                "ExperienceMonth":
                                                    _experienceMonth.text
                                              }));
                                              setState(() {});
                                              _experienceIn.text = "";
                                              _experienceMonth.text = "";
                                              _experienceYear.text = "";

                                              Navigator.pop(context);
                                            }
                                          },
                                          child: Text(
                                            "Add",
                                            style: GoogleFonts.poppins(
                                                color: Colors.white),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    "+Add Experience",
                    style: GoogleFonts.poppins(fontSize: 13, color: kDarkColor),
                  ),
                ),
              ),
              if (_experiences.length > 0)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                      color: kLightColor,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            spreadRadius: 4,
                            offset: Offset(5, 5))
                      ]),
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: _experiences.length,
                      itemBuilder: (context, index) {
                        var exp = jsonDecode(_experiences[index]);
                        return Row(
                          children: [
                            Container(
                              width: 150,
                              child: Text(
                                exp['ExperienceTitle'],
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                            ),
                            Spacer(),
                            Text(
                              "${exp['ExperienceYear']} Yrs, ${exp['ExperienceMonth']} Mon",
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                _experiences.removeAt(index);
                                setState(() {});
                              },
                              child: Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 10,
                                  )),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    color: kDarkColor,
                    textColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                    onPressed: () async {
                      var selectedCompany = "";

                      Future<FetchUsersCompaniesModel> fetchUserCompanies;

                      fetchUserCompanies =
                          CompanyApi().fetchUserCompanies(userID);

                      showBarModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: FutureBuilder<FetchUsersCompaniesModel>(
                              future: fetchUserCompanies,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data.status) {
                                    return ListView.builder(
                                      physics: AlwaysScrollableScrollPhysics(),
                                      itemCount: snapshot.data.data.length,
                                      itemBuilder: (context, index) {
                                        var company = snapshot.data.data[index];
                                        return Padding(
                                          padding: EdgeInsets.all(8),
                                          child: ListTile(
                                            onTap: () async {
                                              await CompanyApi()
                                                  .fetchCompanyByID(company
                                                      .companyId
                                                      .toString())
                                                  .then((value) {
                                                print(value.data.companyId);
                                                Provider.of<SelectCompanyNotifier>(
                                                        context,
                                                        listen: false)
                                                    .select(
                                                        value.data.companyId
                                                            .toString(),
                                                        true,
                                                        true,
                                                        value.data);

                                                Navigator.pop(context);
                                              });
                                            },
                                            title:
                                                Text("${company.companyName}"),
                                            leading: CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Colors.white,
                                              backgroundImage: company
                                                      .companyLogo.isNotEmpty
                                                  ? AppSetting.showUserImage(
                                                      company.companyLogo)
                                                  : AssetImage(
                                                      application_logo),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    return EmptyData(
                                      message:
                                          "No Company \n Please create new company",
                                    );
                                  }
                                } else if (snapshot.hasError) {
                                  return EmptyData(
                                      message: "Something went wrong");
                                } else {
                                  return CircularLoading();
                                }
                              },
                            ),
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.radio_button_checked_rounded,
                          size: 12,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          "Choose Company",
                          style: GoogleFonts.poppins(fontSize: 12),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    color: kDarkColor,
                    textColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                    onPressed: () {
                      showBarModalBottomSheet(
                        context: context,
                        builder: (context) {
                          print("Creating Company");

                          return CreateCompany();
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          size: 12,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          "Create Company",
                          style: GoogleFonts.poppins(fontSize: 12),
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              //Selected Company Card
              Consumer<SelectCompanyNotifier>(
                builder: (context, value, child) {
                  print('notifier listening');
                  _companySelected = value.companySelected;
                  _companyStatus = value.companyStatus;
                  _company = value.companyID;
                  return value.companySelected
                      ? Padding(
                          padding: EdgeInsets.all(8),
                          child: Card(
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      AvatarGlow(
                                          repeat: true,
                                          glowColor: kDarkColor,
                                          showTwoGlows: true,
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Colors.white,
                                            backgroundImage: value.companyData
                                                    .companyLogo.isNotEmpty
                                                ? AppSetting.showUserImage(value
                                                    .companyData.companyLogo)
                                                : AssetImage(application_logo),
                                          ),
                                          endRadius: 24),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                          child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${value.companyData.companyName}",
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "${value.companyData.companyAddress}",
                                                style: GoogleFonts.poppins(
                                                    color: Colors.grey),
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Provider.of<SelectCompanyNotifier>(
                                                  context,
                                                  listen: false)
                                              .select(
                                                  "0", false, false, Data());
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: Colors.redAccent,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container();
                },
              ),
              SizedBox(
                height: 15,
              ),
              !_isJobPosting
                  ? MaterialButton(
                      onPressed: () async {
                        var validation = {
                          "status": false,
                          "message": "Something went wrong"
                        };

                        if (_companySelected) {
                          validation = {"status": true};
                        } else {
                          print("Choose or create company first");

                          validation = {
                            "status": false,
                            "message": "Choose or create company first"
                          };
                        }

                        print(validation);

                        if (_minSalaryController.text.isEmpty ||
                            _maxSalaryController.text.isEmpty) {
                          validation = {
                            "status": false,
                            "message": "Min or Max Salary should not be empty"
                          };
                        } else {
                          if (int.parse(_minSalaryController.text) >
                              int.parse(_maxSalaryController.text)) {
                            validation = {
                              "status": false,
                              "message":
                                  "Min Salary shouldn't be greater than Max Salary"
                            };
                          } else {
                            validation = {"status": true};
                          }
                        }

                        if (validation['status']) {
                          setState(() {
                            _isJobPosting = true;
                          });

                          var jobData = jsonEncode({
                            "company_status": true,
                            "company_id": _company,
                            "job_details": {
                              "job_title": _jobTitleController.text,
                              "job_description": _descriptionController.text,
                              "job_qualification":
                                  _qualificationController.text,
                              "job_education": _education,
                              "job_industry": _industry,
                              "job_hiring_count": _hireController.text,
                              "job_minimum_salary": _minSalaryController.text,
                              "job_maximum_salary": _maxSalaryController.text,
                              "job_salary_type": "Per Year",
                              "job_schedule": _jobType,
                              "job_ext_experience":
                                  jsonDecode(_experiences.toString()),
                              "job_key_skills": _skillTags
                            }
                          });

                          print(jobData);

                          await PostJobApi().postJob(jobData).then((value) {
                            if (value.status) {
                              print("job uploaded");
                              Provider.of<SelectCompanyNotifier>(context,
                                      listen: false)
                                  .select("0", false, false, Data());
                              var snackBar = SnackBar(
                                content: Text("Job Posted Successfully"),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              Navigator.pop(context);
                            } else {
                              print("Something went wrong");
                              var snackBar = SnackBar(
                                content: Text(
                                    "Something went wrong, please try again later"),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              setState(() {
                                _isJobPosting = false;
                              });
                            }
                          });
                        } else {
                          SnackBar snackBar = SnackBar(
                            content: Text("${validation['message']}"),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: Text("Post Job"),
                      textColor: Colors.white,
                      color: kDarkColor,
                    )
                  : CircularLoading(),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
