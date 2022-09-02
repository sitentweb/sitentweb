import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remark_app/apis/company/employer_company_api.dart';
import 'package:remark_app/components/appbar/appbar.dart';
import 'package:remark_app/components/empty/empty_data.dart';
import 'package:remark_app/components/loading/circular_loading.dart';
import 'package:remark_app/config/appSetting.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/company/get_employer_companies_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class EmployerCompanies extends StatefulWidget {
  const EmployerCompanies({Key key}) : super(key: key);

  @override
  _EmployerCompaniesState createState() => _EmployerCompaniesState();
}

class _EmployerCompaniesState extends State<EmployerCompanies> {
  String userID;
  Future<EmployerCompanyModel> _employerCompanyModel;

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
  }

  getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      userID = pref.getString('userID');
      _employerCompanyModel = EmployerCompany().fetchEmployerCompanies(userID);
    });

    print(userID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [ApplicationAppBar()],
        iconTheme: IconThemeData(color: kDarkColor),
      ),
      body: Container(
          child: FutureBuilder<EmployerCompanyModel>(
        future: _employerCompanyModel,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.status) {
              return ListView.builder(
                itemCount: snapshot.data.data.length,
                itemBuilder: (context, index) {
                  var company = snapshot.data.data[index];

                  return Container(
                    height: 200,
                    padding: EdgeInsets.all(8),
                    child: Card(
                      elevation: 2,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Container(
                                child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.white,
                                  backgroundImage:
                                      company.companyLogo.isNotEmpty
                                          ? AppSetting.showUserImage(
                                              company.companyLogo)
                                          : AssetImage(application_logo),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    "${company.companyName}",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            )),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: Text(
                                    "${company.companyDes}",
                                    style: GoogleFonts.poppins(),
                                    overflow: TextOverflow.ellipsis,
                                  ))
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Icon(Icons.location_pin,
                                      size: 20, color: kDarkColor),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                      child: Text("${company.companyAddress}")),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Icon(Icons.web, size: 20, color: kDarkColor),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                      child: Text("${company.companyWebsite}")),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Icon(Icons.history,
                                      size: 20, color: kDarkColor),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                      child: Text(
                                          timeAgo.format(company.createdOn))),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return EmptyData(
                  message:
                      "No Company Here, Please Post Job to create company");
            }
          } else if (snapshot.hasError) {
            return EmptyData(message: "Something went wrong");
          } else {
            return CircularLoading();
          }
        },
      )),
    );
  }
}
