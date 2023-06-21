import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remark_app/components/appbar/appbar.dart';
import 'package:remark_app/components/utilities/verified_tick.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/controllers/company_controller.dart';
import 'package:remark_app/model/company/fetch_company_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewCompany extends StatefulWidget {
  final String companyID;
  const ViewCompany({Key key, this.companyID}) : super(key: key);

  @override
  State<ViewCompany> createState() => _ViewCompanyState();
}

class _ViewCompanyState extends State<ViewCompany> {
  CompanyController companyController = Get.put(CompanyController());
  String userID;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      userID = pref.getString("userID");
    });

    await companyController.fetchCompanyDetails(
        companyID: widget.companyID, userID: userID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kDarkColor,
          leadingWidth: 0,
          title: Obx(() {
            if (companyController.isFetchingCompany.isFalse) {
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${companyController.companyData.value.companyName}",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    companyController.companyData.value.verifiedCompany == '1'
                        ? VerifiedTick(
                            color: Colors.white,
                          )
                        : SizedBox()
                  ],
                ),
              );
            }

            return SizedBox();
          }),
          actions: [],
        ),
        body: Obx(() {
          if (companyController.isFetchingCompany.isFalse) {
            final company = companyController.companyData.value;

            return Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                children: [
                  Container(
                    child: Text(
                      company.companyName,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        }));
  }
}
