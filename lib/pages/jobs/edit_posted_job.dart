import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:get/get.dart';
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
import 'package:remark_app/controllers/jobs/post_job_controller.dart';
import 'package:remark_app/model/company/fetch_company_model.dart';
import 'package:remark_app/model/company/fetch_user_company_model.dart';
import 'package:remark_app/notifier/select_company_notifier.dart';
import 'package:remark_app/pages/candidates/search_candidates.dart';
import 'package:remark_app/pages/company/create_company.dart';
import 'package:remark_app/pages/jobs/search_job.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:remark_app/pages/homepage/homepage.dart';

class EditPostedJob extends StatefulWidget {
  final String jobId;
  const EditPostedJob({Key key, this.jobId}) : super(key: key);

  @override
  State<EditPostedJob> createState() => _EditPostedJobState();
}

class _EditPostedJobState extends State<EditPostedJob> {
  PostJobController postJobController = Get.put(PostJobController());
  var userType;
  var userID;
  // List<DropdownMenuItem> _educationList = [];
  // List<DropdownMenuItem> _industryList = [];
  List _experiences = [];
  List _skillTags = [];
  String _company = "";
  bool _companyStatus = false;
  bool _companySelected = false;
  Data _companyData = Data();
  bool _isJobPosting = false;

  // TEXT EDITING CONTROLLERS

  @override
  void initState() {
    // TODO: implement initState
    postJobController.initEditing(widget.jobId);
    getUserData();

    super.initState();
  }

  getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userType = pref.getString("userType");
      userID = pref.getString("userID");
    });

    // Provider.of<SelectCompanyNotifier>(context, listen: true).unselect();
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
      body: SafeArea(child: Obx(() {
        if (postJobController.readyJobPosting.isFalse) {
          return CircularLoading();
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: ListView(
            children: [
              SizedBox(
                height: 5,
              ),
              Container(
                  width: Get.width,
                  child: Card(
                    elevation: 10,
                    shadowColor: Colors.black.withOpacity(0.3),
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        "Post New Job",
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kDarkColor.withOpacity(1)),
                      ),
                    ),
                  )),
              Container(
                child: Card(
                  elevation: 10,
                  shadowColor: Colors.black.withOpacity(0.3),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    child: Column(
                      children: [
                        TextField(
                          // controller: _jobTitleController,
                          controller: postJobController.jobTitle,
                          style: GoogleFonts.poppins(fontSize: 14),
                          decoration: InputDecoration(
                              labelText: "Job Title",
                              labelStyle: GoogleFonts.poppins(fontSize: 14)),
                        ),
                        SizedBox(height: 5),
                        TextField(
                          // controller: _descriptionController,
                          controller: postJobController.jobDescription,
                          style: GoogleFonts.poppins(fontSize: 14),
                          maxLines: 3,
                          maxLength: 1000,
                          decoration: InputDecoration(
                              labelText: "Description",
                              labelStyle: GoogleFonts.poppins()),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        DropdownButtonFormField(
                          style: GoogleFonts.poppins(),
                          // items: _educationList,
                          value: postJobController.jobEducation.value,
                          items: postJobController.educationList,
                          onChanged: (value) {
                            // setState(() {
                            //   _education = value.toString();
                            // });
                            postJobController.setJobEducation(value);
                          },
                          hint: Text("Select Education"),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextField(
                          // controller: _qualificationController,
                          controller: postJobController.jobQualification,
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
                          value: postJobController.jobIndustry.value,
                          items: postJobController.industryList,
                          onChanged: (value) {
                            postJobController.setJobIndustry(value);
                          },
                          hint: Text("Select Industry"),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextField(
                          // controller: _hireController,
                          controller: postJobController.jobHiring,
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
                                // controller: _minSalaryController,
                                controller: postJobController.jobMinimumSalary,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: false, signed: false),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
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
                                // controller: _maxSalaryController,
                                controller: postJobController.jobMaximumSalary,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                    labelText: "Max Salary",
                                    labelStyle:
                                        GoogleFonts.poppins(fontSize: 14),
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
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.black),
                          hint: Text(
                            "Select Job Type",
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                          value: postJobController.jobType.value,
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
                            // setState(() {
                            //   _jobType = value.toString();
                            // });
                            postJobController.setJobType(value);
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextField(
                          // controller: _skillController,
                          controller: postJobController.jobSkillInput,
                          decoration: InputDecoration(
                              suffix: MaterialButton(
                                onPressed: () {
                                  postJobController.addSkillToSkillsList();
                                },
                                child: Text(
                                  "Add",
                                  style:
                                      GoogleFonts.poppins(color: Colors.white),
                                ),
                                color: kDarkColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              labelText: "Skills",
                              helperText:
                                  "Press done after typing to add skill in Skills List",
                              labelStyle: GoogleFonts.poppins(fontSize: 14)),
                          onSubmitted: (value) {
                            if (value != '') {
                              // _skillTags.add(value);
                              // _skillController.text = "";
                              // setState(() {});
                              postJobController.addSkillToSkillsList();
                            }
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        // if (_skillTags.isNotEmpty)
                        if (postJobController.jobSkills.isNotEmpty)
                          Container(
                            child: Tags(
                              // itemCount: _skillTags.length,
                              itemCount: postJobController.jobSkills.length,
                              itemBuilder: (index) {
                                return ItemTags(
                                  onPressed: (i) {
                                    // _skillTags.removeAt(index);
                                    // postJobController.jobSkills.removeAt(index);
                                    postJobController
                                        .removeJobSkillIndex(index);
                                    // setState(() {});
                                  },
                                  color: kDarkColor,
                                  activeColor: kDarkColor,
                                  index: index,
                                  // title: _skillTags[index],
                                  title: postJobController.jobSkills[index],
                                  removeButton: ItemTagsRemoveButton(
                                    onRemoved: () {
                                      // _skillTags.removeAt(index);
                                      postJobController
                                          .removeJobSkillIndex(index);
                                      // setState(() {});
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("Experience Details",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        height: 250,
                                        child: Form(
                                          // key: _formKey,
                                          key: postJobController
                                              .jobExperienceGlobalKey,
                                          child: ListView(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            children: [
                                              TextFormField(
                                                // controller: _experienceIn,
                                                controller: postJobController
                                                    .jobExperienceTitle,
                                                validator: (value) {
                                                  if (value.isEmpty ||
                                                      value == null) {
                                                    return "Experience Title is required";
                                                  }
                                                  return null;
                                                },
                                                style: GoogleFonts.poppins(),
                                                decoration: InputDecoration(
                                                    labelText: "Experience In",
                                                    labelStyle:
                                                        GoogleFonts.poppins(),
                                                    hintText: "PHP, HTML",
                                                    hintStyle:
                                                        GoogleFonts.poppins()),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: TextFormField(
                                                      // controller:
                                                      // _experienceYear,
                                                      controller:
                                                          postJobController
                                                              .jobExperienceYear,
                                                      validator: (value) {
                                                        if (value.isEmpty ||
                                                            value == null) {
                                                          return "Year is required";
                                                        }
                                                        return null;
                                                      },
                                                      keyboardType: TextInputType
                                                          .numberWithOptions(
                                                              decimal: false,
                                                              signed: false),
                                                      style:
                                                          GoogleFonts.poppins(),
                                                      decoration:
                                                          InputDecoration(
                                                              labelText: "Year",
                                                              hintText: "00"),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "-",
                                                    style:
                                                        GoogleFonts.poppins(),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: TextFormField(
                                                      // controller:
                                                      //     _experienceMonth,
                                                      controller:
                                                          postJobController
                                                              .jobExperienceMonth,
                                                      validator: (value) {
                                                        if (value.isEmpty ||
                                                            value == null) {
                                                          return "Month is required";
                                                        }
                                                        return null;
                                                      },
                                                      keyboardType:
                                                          TextInputType.number,
                                                      style:
                                                          GoogleFonts.poppins(),
                                                      decoration:
                                                          InputDecoration(
                                                              labelText:
                                                                  "Month",
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
                                                      // if (postJobController.jobExperienceGlobalKey.currentState
                                                      //     .validate()) {
                                                      //   _experiences
                                                      //       .add(jsonEncode({
                                                      //     "ExperienceTitle":
                                                      //         _experienceIn
                                                      //             .text,
                                                      //     "ExperienceYear":
                                                      //         _experienceYear
                                                      //             .text,
                                                      //     "ExperienceMonth":
                                                      //         _experienceMonth
                                                      //             .text
                                                      //   }));
                                                      //   setState(() {});
                                                      //   _experienceIn.text = "";
                                                      //   _experienceMonth.text =
                                                      //       "";
                                                      //   _experienceYear.text =
                                                      //       "";

                                                      //   Navigator.pop(context);
                                                      // }
                                                      postJobController
                                                          .validateAndJsonJobExperience();

                                                      Get.back();
                                                    },
                                                    child: Text(
                                                      "Add",
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color:
                                                                  Colors.white),
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
                              style: GoogleFonts.poppins(
                                  fontSize: 13, color: kDarkColor),
                            ),
                          ),
                        ),
                        // if (_experiences.length > 0)
                        if (postJobController.jobExperience.length > 0)
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
                                // itemCount: _experiences.length,
                                itemCount:
                                    postJobController.jobExperience.length,
                                itemBuilder: (context, index) {
                                  // var exp = jsonDecode(_experiences[index]);
                                  var exp =
                                      postJobController.jobExperience[index];

                                  return Row(
                                    children: [
                                      Container(
                                        width: 150,
                                        child: Text(
                                          exp['ExperienceTitle'],
                                          style: GoogleFonts.poppins(
                                              color: Colors.white),
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        "${exp['ExperienceYear']} Yrs, ${exp['ExperienceMonth']} Mon",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // _experiences.removeAt(index);
                                          postJobController
                                              .removeJobExperienceAtIndex(
                                                  index);
                                          // setState(() {});
                                        },
                                        child: Container(
                                            padding: EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                                color: Colors.redAccent,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
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
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 15),
                              onPressed: () async {
                                var selectedCompany = "";

                                Future<FetchUsersCompaniesModel>
                                    fetchUserCompanies;

                                fetchUserCompanies =
                                    CompanyApi().fetchUserCompanies(userID);

                                showBarModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.6,
                                      child: FutureBuilder<
                                          FetchUsersCompaniesModel>(
                                        future: fetchUserCompanies,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            if (snapshot.data.status) {
                                              return ListView.builder(
                                                physics:
                                                    AlwaysScrollableScrollPhysics(),
                                                itemCount:
                                                    snapshot.data.data.length,
                                                itemBuilder: (context, index) {
                                                  var company =
                                                      snapshot.data.data[index];
                                                  return Padding(
                                                    padding: EdgeInsets.all(8),
                                                    child: ListTile(
                                                      onTap: () async {
                                                        await CompanyApi()
                                                            .fetchCompanyByID(
                                                                company
                                                                    .companyId
                                                                    .toString())
                                                            .then((value) {
                                                          Provider.of<SelectCompanyNotifier>(
                                                                  context,
                                                                  listen: false)
                                                              .select(
                                                                  value.data
                                                                      .companyId
                                                                      .toString(),
                                                                  true,
                                                                  true,
                                                                  value.data);

                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                      title: Text(
                                                          "${company.companyName}"),
                                                      leading: CircleAvatar(
                                                        radius: 20,
                                                        backgroundColor:
                                                            Colors.white,
                                                        backgroundImage: company
                                                                .companyLogo
                                                                .isNotEmpty
                                                            ? AppSetting
                                                                .showUserImage(
                                                                    company
                                                                        .companyLogo)
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
                                                message:
                                                    "Something went wrong");
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
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 15),
                              onPressed: () {
                                showBarModalBottomSheet(
                                  context: context,
                                  builder: (context) {
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
                                                      backgroundColor:
                                                          Colors.white,
                                                      backgroundImage: value
                                                              .companyData
                                                              .companyLogo
                                                              .isNotEmpty
                                                          ? AppSetting
                                                              .showUserImage(value
                                                                  .companyData
                                                                  .companyLogo)
                                                          : AssetImage(
                                                              application_logo),
                                                    ),
                                                    endRadius: 24),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                    child: Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "${value.companyData.companyName}",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          "${value.companyData.companyAddress}",
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  color: Colors
                                                                      .grey),
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
                                                        .select("0", false,
                                                            false, Data());
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                        color: Colors.redAccent,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
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
                        postJobController.isPostingJob.isFalse
                            ? MaterialButton(
                                onPressed: () async {
                                  var validation = {
                                    "status": false,
                                    "message": "Something went wrong"
                                  };

                                  if (postJobController.jobCompanyId.value !=
                                      "0") {
                                    validation = {"status": true};
                                  } else {
                                    print("Choose or create company first");

                                    validation = {
                                      "status": false,
                                      "message":
                                          "Choose or create company first"
                                    };
                                  }

                                  if (postJobController
                                          .jobMinimumSalary.isBlank ||
                                      postJobController
                                          .jobMaximumSalary.isBlank) {
                                    validation = {
                                      "status": false,
                                      "message":
                                          "Min or Max Salary should not be empty"
                                    };
                                  } else {
                                    if (int.parse(postJobController
                                            .jobMinimumSalary.text) >
                                        int.parse(postJobController
                                            .jobMaximumSalary.text)) {
                                      validation = {
                                        "status": false,
                                        "message":
                                            "Min Salary shouldn't be greater than Max Salary"
                                      };
                                    } else {
                                      validation = {"status": true};
                                    }
                                  }

                                  if (postJobController.jobSkills.isEmpty) {
                                    validation = {
                                      "status": false,
                                      "message": "Please add atleast one skill",
                                    };
                                  } else {
                                    validation['status'] = true;
                                  }

                                  if (validation['status']) {
                                    await postJobController.updateJob();
                                  } else {
                                    SnackBar snackBar = SnackBar(
                                      content: Text("${validation['message']}"),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                                child: Text("Update Job"),
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
              )
            ],
          ),
        );
      })),
    );
  }
}
