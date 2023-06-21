import 'package:flutter/material.dart';
import 'package:remark_app/components/appbar/appbar.dart';
import 'package:remark_app/components/utilities/verified_tick.dart';
import 'package:remark_app/config/constants.dart';
import 'package:get/get.dart';
import 'package:remark_app/controllers/company_controller.dart';
import 'package:remark_app/pages/company/view_company.dart';
import '';

class CompanyList extends StatefulWidget {
  const CompanyList({Key key}) : super(key: key);

  @override
  State<CompanyList> createState() => _CompanyListState();
}

class _CompanyListState extends State<CompanyList> {
  final companyController = Get.put(CompanyController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    companyController.fetchCompanies();
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
        child: Obx(() {
          if (companyController.companies.isEmpty &&
              companyController.isFetchingCompanies == false) {
            return Text("No Company Found");
          }

          if (companyController.companies.length > 1 &&
              companyController.isFetchingCompanies == true) {
            return Center(child: CircularProgressIndicator());
          }

          if (companyController.companies.length > 0) {
            return ListTile(
              title: ListView.builder(
                itemCount: companyController.companies.length,
                itemBuilder: (context, index) {
                  final company = companyController.companies[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    height: 130,
                    child: Card(
                      elevation: 10,
                      shadowColor: Colors.black.withOpacity(0.3),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 18,
                                      child: company.companyLogo.isNotEmpty
                                          ? Image.network(
                                              base_url + company.companyLogo)
                                          : Image.asset(application_logo),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              Text(
                                                company?.companyName,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              company.verifiedCompany == '1'
                                                  ? VerifiedTick()
                                                  : SizedBox()
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Container(
                                          child: Text(
                                            company.companyAddress,
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                company.companyDes,
                                maxLines: 2,
                                style: TextStyle(color: Colors.black54),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Divider(),
                            // Center(
                            //   child: MaterialButton(
                            //     onPressed: () {
                            //       print('view company');
                            //       Get.to(() => ViewCompany(
                            //             companyID: company.companyId,
                            //           ));
                            //     },
                            //     padding: EdgeInsets.symmetric(
                            //         vertical: 5, horizontal: 10),
                            //     splashColor: Colors.transparent,
                            //     hoverColor: Colors.transparent,
                            //     highlightColor: Colors.transparent,
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: [
                            //         Text(
                            //           'View',
                            //           style: TextStyle(
                            //               fontSize: 18, color: kDarkColor),
                            //         ),
                            //         Icon(Icons.arrow_right_outlined)
                            //       ],
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }
}
