import 'package:flutter/material.dart';
import 'package:remark_app/apis/jobs/all_jobs.dart';
import 'package:remark_app/components/appbar/appbar.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/pages/jobs/all_jobs.dart';

class EmployerAllJobs extends StatelessWidget {
  const EmployerAllJobs({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [ApplicationAppBar()],
          iconTheme: IconThemeData(
            color: kDarkColor
          ),
        ),
        body: Jobs(
          isSearch: false,
          searchData: [],
        ),
    );
  }
}