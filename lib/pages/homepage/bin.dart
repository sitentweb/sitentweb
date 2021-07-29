import 'package:flutter/material.dart';
import 'package:remark_app/components/appbar/appbar.dart';
import 'package:remark_app/components/job_card/job_card.dart';

class Bin extends StatefulWidget {
  const Bin({Key key}) : super(key: key);

  @override
  _BinState createState() => _BinState();
}

class _BinState extends State<Bin> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              ApplicationAppBar(),
              Expanded(
                child: Container(
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context , index){
                      return JobCard(
                        jobTitle: '1',
                        companyImage: 'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_92x30dp.png',
                        companyName: 'Sitent Web & Graphics Design',
                        minimumSalary: '10,000',
                        maximumSalary: '20,000',
                        experience: '0-1',
                        jobSkills: 'HTML, CSS, PHP, JAVA, JAVASCRIPT, JQUERY, SQL',
                        companyLocation: 'Indore, Madhya Pradesh',
                        timeAgo: '2 hours ago',
                        jobLink: 'www.google.com',
                        isUserApplied: true,
                        isUserSavedThis: false,
                        applyBtn: 0,
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}
