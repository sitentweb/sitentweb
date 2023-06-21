import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remark_app/apis/responses/questionnaire/fetch_quiz_api.dart';
import 'package:remark_app/components/loading/circular_loading.dart';
import 'package:remark_app/config/appSetting.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/response/questionnaire/fetch_quiz_data.dart';
import 'package:remark_app/model/response/questionnaire/questionnaire_questions.dart';
import 'package:remark_app/pages/response/questionnaire/all_questions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeQuestionnaireReport extends StatefulWidget {
  final String employeePhoto;
  final String employeeName;
  final String quizRoomID;
  const EmployeeQuestionnaireReport(
      {Key key, this.quizRoomID, this.employeePhoto, this.employeeName})
      : super(key: key);

  @override
  _EmployeeQuestionnaireReportState createState() =>
      _EmployeeQuestionnaireReportState();
}

class _EmployeeQuestionnaireReportState
    extends State<EmployeeQuestionnaireReport> {
  Future<FetchQuizDataModel> _quizData;
  List<QuestionnaireQuestionsModel> _questions = [];
  int rightAnswers = 0;

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    getQuizData();
    super.initState();
  }

  getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
  }

  getQuizData() async {
    _quizData = FetchQuizRoomApi().fetchQuizData(widget.quizRoomID);

    getQuizQuestion();
  }

  getQuizQuestion() {
    _quizData.then((value) {
      List<dynamic> questionData = jsonDecode(value.data.quiz);
      QuestionnaireQuestionsModel ques;
      questionData.forEach((element) {
        ques = QuestionnaireQuestionsModel(
            options: [
              element['answerA'],
              element['answerB'],
              element['answerC'],
              element['answerD']
            ],
            question: element['question'],
            rightAnswer: element['right_answer'].toString(),
            employeeAnswer: element['employee_answer'].toString());

        _questions.add(ques);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<FetchQuizDataModel>(
                future: _quizData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.status) {
                      var quiz = snapshot.data.data;
                      return Container(
                        width: size.width,
                        height: size.height,
                        child: Column(
                          children: [
                            // AppBAr
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(color: kDarkColor),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    child: InkWell(
                                      onTap: () => Navigator.pop(context),
                                      child: Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 18,
                                    backgroundImage: AppSetting.showUserImage(
                                        widget.employeePhoto),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${widget.employeeName}",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            // BODY
                            Container(
                              padding: EdgeInsets.all(10),
                              width: size.width,
                              child: quiz.quizStatus == "1"
                                  ? quiz.quizStopTime.isEmpty
                                      ? StartedQuiz(
                                          quiz: quiz,
                                        )
                                      : StoppedQuiz(quiz: quiz, q: _questions)
                                  : Container(),
                            ),
                            Expanded(
                              child: Container(
                                child: Swiper(
                                  loop: false,
                                  itemCount: _questions.length,
                                  itemBuilder: (context, index) {
                                    var q = _questions[index];
                                    print("Question is ${q.question}");
                                    return ShowQuizResult(
                                      index: index,
                                      quiz: quiz,
                                      q: q,
                                      qStatus: quiz.quizStatus,
                                    );
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      return Center(
                        child: Text("No Quiz Data Found"),
                      );
                    }
                  } else if (snapshot.hasError) {
                    print(snapshot.hasError);
                    return Text("${snapshot.hasError}");
                  } else {
                    return CircularLoading();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StartedQuiz extends StatelessWidget {
  final Data quiz;
  const StartedQuiz({Key key, this.quiz}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Started at ${quiz.quizStartTime}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class StoppedQuiz extends StatelessWidget {
  final Data quiz;
  final List<QuestionnaireQuestionsModel> q;
  const StoppedQuiz({Key key, this.quiz, this.q}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var totalQuiz = jsonDecode(quiz.quiz).length;
    int totalRightAnswers = 0;

    q.forEach((ques) {
      if (ques.rightAnswer == ques.employeeAnswer) {
        totalRightAnswers++;
      }
    });

    return Card(
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 10,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Started at ${quiz.quizStartTime}",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 10,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Submitted at ${quiz.quizStopTime}",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Icon(
                  Icons.verified,
                  size: 14,
                  color: Colors.blue,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Score : $totalRightAnswers/$totalQuiz",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ShowQuizResult extends StatelessWidget {
  final index;
  final QuestionnaireQuestionsModel q;
  final qStatus;
  final Data quiz;
  const ShowQuizResult({Key key, this.q, this.qStatus, this.index, this.quiz})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var quizColorNotSelected;
    var quizColorSelected;
    if (qStatus == "1") {}

    Size size = MediaQuery.of(context).size;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                width: size.width,
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                    color: kDarkColor,
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: Text(
                  "Question ${index + 1}",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                height: 80,
                child: Text(
                  "${q.question}",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(top: 50),
                  child: ListView.builder(
                    itemCount: q.options.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, opIndex) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            color: quiz.quizStatus == "1" &&
                                    quiz.quizStopTime.isEmpty
                                ? Colors.grey[300]
                                : quiz.quizStatus == "0"
                                    ? Colors.grey[300]
                                    : int.parse(q.employeeAnswer) != opIndex
                                        ? int.parse(q.rightAnswer) != opIndex
                                            ? Colors.grey[300]
                                            : Colors.green[200]
                                        : q.employeeAnswer == q.rightAnswer
                                            ? Colors.green[400]
                                            : Colors.redAccent),
                        padding: EdgeInsets.all(15),
                        child: Text(
                          "${q.options[opIndex]}",
                          style: GoogleFonts.poppins(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
