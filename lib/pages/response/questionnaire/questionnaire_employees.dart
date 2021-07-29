import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remark_app/apis/responses/questionnaire/fetch_quiz_api.dart';
import 'package:remark_app/components/empty/empty_data.dart';
import 'package:remark_app/components/loading/circular_loading.dart';
import 'package:remark_app/config/appSetting.dart';
import 'package:remark_app/model/response/fetch_quiz_room.dart';
import 'package:remark_app/model/response/questionnaire/fetch_quiz_data.dart';
import 'package:remark_app/model/response/questionnaire/quiz_employees_model.dart';
import 'package:remark_app/pages/response/questionnaire/employee_report.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class QuestionnaireEmployees extends StatefulWidget {
  final quizID;
  const QuestionnaireEmployees({Key key, this.quizID}) : super(key: key);

  @override
  _QuestionnaireEmployeesState createState() => _QuestionnaireEmployeesState();
}

class _QuestionnaireEmployeesState extends State<QuestionnaireEmployees> {

  Future<QuizEmployeesRoomModel> _quizData;
  
  @override
  void initState() {
    // TODO: implement initState
    _quizData = getQuizData();
    super.initState();
  }
  
  Future<QuizEmployeesRoomModel> getQuizData() async {
    Future<QuizEmployeesRoomModel> _quizTempData;
    _quizTempData = FetchQuizRoomApi().fetchQuizEmployeeRoom(widget.quizID);

    return _quizTempData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: FutureBuilder<QuizEmployeesRoomModel>(
            future: _quizData,
            builder: (context, snapshot) {
              if(snapshot.hasData){
                if(snapshot.data.status){
                  return ListView.builder(
                    itemCount: snapshot.data.data.length,
                    itemBuilder: (context, index) {
                      var room = snapshot.data.data[index];
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white,
                          backgroundImage: AppSetting.showUserImage(room.userPhoto),
                        ),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeQuestionnaireReport(quizRoomID: room.quizRoomId, employeeName: room.userName, employeePhoto: room.userPhoto,),)),
                        title: Text("${room.userName}" , style: GoogleFonts.poppins(),),
                        subtitle: Text("${room.quizStartTime.isNotEmpty ? room.quizStopTime.isNotEmpty ? "Submitted at ${room.quizStopTime}" : "Started at ${room.quizStartTime} " : "Not Started yet"}" , style: GoogleFonts.poppins(),),
                      );
                    },
                  );
                }else{
                  return Center(
                    child: EmptyData(message: "You have not sent this questionnaire to any employee",),
                  );
                }
              }else if(snapshot.hasError){
                return Text("has Error");
              }else{
                return CircularLoading();
              }
            },
          ),
        ),
      ),
    );
  }
}
