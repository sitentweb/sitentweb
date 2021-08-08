import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:remark_app/apis/responses/interview/all_interviews_api.dart';
import 'package:remark_app/components/empty/empty_data.dart';
import 'package:remark_app/components/loading/circular_loading.dart';
import 'package:remark_app/config/appSetting.dart';
import 'package:remark_app/config/userSetting.dart';
import 'package:remark_app/model/response/interview/get_all_interviews_model.dart';
import 'package:remark_app/pages/response/interview/view_interview.dart';
import 'package:shared_preferences/shared_preferences.dart';


class InterviewScreen extends StatefulWidget {
  const InterviewScreen({Key key}) : super(key: key);

  @override
  _InterviewScreenState createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> with AutomaticKeepAliveClientMixin {

  Future<GetAllInterviewModel> _myInterviews;
  List<Datum> _listInterviews = [];

  var userID;
  var userType;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
    Future.delayed(Duration(seconds: 2));
  }

  getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      userID = pref.getString("userID");
      userType = pref.getString("userType");
      _myInterviews = GetAllInterviewsApi().getAllInterviews(userID, userType);
    });

    // NOW GET USER INTERVIEW
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GetAllInterviewModel>(
        future: _myInterviews,
        builder: (_, AsyncSnapshot<GetAllInterviewModel> snapshot) {
            if(snapshot.hasData){
              if(snapshot.data.status){
                return ListView.builder(
                  itemCount: snapshot.data.data.length,
                  itemBuilder: (_, index) {
                    var interview = snapshot.data.data[index];

                    if(userType == "2"){
                      return EmployerInterviewList(interview: interview,);
                    }else{
                      return ListTile(
                        onTap: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => VideoCallScreen(
                          //   employerToken: interview.employerToken,
                          //   employeeToken: interview.employeeToken,
                          //   interviewID: interview.interviewId,
                          // )));
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  ViewInterview(interview: interview)));
                        },
                        title: Text("${interview.employerName} (${interview.interviewTitle}) "),
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: AppSetting.showUserImage(interview.employerLogo),
                        ),
                        subtitle: Text("${UserSetting.interviewType(interview.interviewType)} on (${interview.interviewTime})"),
                      );
                    }
                  },
                );
              }else{
                return Container(
                  child: Center(
                    child: EmptyData(message: "No Interview",),
                  ),
                );
              }
            }else if(snapshot.hasError){
              print(snapshot.error);
              return Container(child: Center(child: Text("Something went wrong")));
            }else{
              return CircularLoading();
            }
        },
    );
  }
}

class EmployerInterviewList extends StatelessWidget {
  final Datum interview;
  const EmployerInterviewList({Key key, this.interview}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        // Navigator.push(context, MaterialPageRoute(builder: (context) => VideoCallScreen(
        //   employerToken: interview.employerToken,
        //   employeeToken: interview.employeeToken,
        //   interviewID: interview.interviewId,
        // )));
          Navigator.push(context, MaterialPageRoute(builder: (context) => ViewInterview(interview: interview)));
      },
      title: Text("${interview.employeeName} (${interview.interviewTitle}) "),
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: AppSetting.showUserImage(interview.employeePhoto),
      ),
      subtitle: Text("${UserSetting.interviewType(interview.interviewType)} on (${interview.interviewTime})"),
    );
  }
}
