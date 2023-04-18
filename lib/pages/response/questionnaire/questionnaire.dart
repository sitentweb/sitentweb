import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:remark_app/apis/responses/questionnaire/fetch_quiz_api.dart';
import 'package:remark_app/components/empty/empty_data.dart';
import 'package:remark_app/components/loading/circular_loading.dart';
import 'package:remark_app/config/appSetting.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/response/fetch_quiz_room.dart';
import 'package:remark_app/pages/candidates/view_candidate.dart';
import 'package:remark_app/pages/homepage/homepage.dart';
import 'package:remark_app/pages/response/questionnaire/all_questions.dart';
import 'package:remark_app/pages/response/questionnaire/employee_report.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Questionnaire extends StatefulWidget {
  const Questionnaire({Key key}) : super(key: key);

  @override
  _QuestionnaireState createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {
  String userID;
  String userType;
  Future<FetchQuizRoomModel> _quizList;

  @override
  void initState() {
    print("Init State Started");
    // TODO: implement initState
    getUserData();
    super.initState();
  }

  getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userID = pref.getString("userID");
      userType = pref.getString("userType");
    });
    print(userID);

    _fetchQuizRoom();
  }

  Future<FetchQuizRoomModel> _fetchQuizRoom() async {
    List<Datum> quizData = <Datum>[];
    final tempQuiz = FetchQuizRoomApi().fetchQuizRoom(userID);
    tempQuiz.then((value) {
      print("Quiz Fetching ${value.status}");
      if (value.status) {
        value.data.forEach((element) {
          if (userType == "1") {
            var quizExpiry = DateFormat('y-M-d').parse(element.quizExpireTime);
            if (DateTime.now().isBefore(quizExpiry)) {
              if (element.quizStartTime.isEmpty) {
                quizData.add(element);
              }
            }
          } else {
            quizData.add(element);
          }
        });
      }
    });

    setState(() {
      tempQuiz.then((value) {
        if (value.status) {
          value.data.length = 0;
          value.data = quizData;
        }
      });

      _quizList = tempQuiz;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(userType: userType),
        ));
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        width: size.width,
        height: size.height,
        child: FutureBuilder<FetchQuizRoomModel>(
          future: _quizList,
          builder: (context, AsyncSnapshot<FetchQuizRoomModel> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.status) {
                return ListView.builder(
                  itemCount: snapshot.data.data.length,
                  itemBuilder: (context, index) {
                    var quiz = snapshot.data.data[index];
                    var statusFullTitle;
                    var statusIcon;
                    var statusColor;

                    double statusSize = 24;

                    if (quiz.quizStatus == "1") {
                      if (quiz.quizStopTime.isNotEmpty) {
                        statusFullTitle = "Questionnaire has submitted";
                        statusIcon = Icons.check;
                        statusColor = Colors.green;
                      } else {
                        statusFullTitle = "Questionnaire has started";
                        statusIcon = Icons.play_arrow;
                        statusColor = Colors.deepOrange;
                      }
                    } else {
                      statusFullTitle = "Questionnaire has not started yet";
                      statusIcon = Icons.circle;
                      statusColor = Colors.grey;
                      statusSize = 20;
                    }

                    return userType == "1"
                        ? QuizRoomCard(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: new Text(
                                    'Start the Questionnaire?',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  content: new Text(
                                    'Do you want to start this Questionnaire, Once the questionnaire starts you can\'t exit the application unless you submit the answers or if you exit the application you will not able to submit or access this questionnaire ',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  actions: <Widget>[
                                    MaterialButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: new Text('No'),
                                    ),
                                    MaterialButton(
                                      onPressed: () async {
                                        await FetchQuizRoomApi()
                                            .startQuiz(quiz.quizRoomId)
                                            .then((value) {
                                          var snackBar;
                                          if (value.status) {
                                            snackBar = SnackBar(
                                              content: Text("Timer Started"),
                                            );
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AllQuestions(
                                                    quizID: quiz.quizId,
                                                    quizRoomID: quiz.quizRoomId,
                                                    fullQuiz: quiz.quiz,
                                                  ),
                                                ));
                                          } else {
                                            snackBar = SnackBar(
                                              content: Text(
                                                  "Something went wrong, Please try again"),
                                            );
                                          }

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        });
                                      },
                                      child: new Text('Yes'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            title: quiz.title,
                            expireDate: quiz.quizExpireTime,
                          )
                        : QuizEmployerRoomCard(
                            title: "${quiz.title}",
                            expireDate: "${quiz.quizExpireTime}",
                            employeePhoto: "${quiz.userPhoto}",
                            employeeName: "${quiz.userName}",
                            employeeUsername: "${quiz.userUsername}",
                            statusIcon: statusIcon,
                            quizRoomID: "${quiz.quizRoomId}",
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EmployeeQuestionnaireReport(
                                    quizRoomID: quiz.quizRoomId,
                                    employeeName: quiz.userName,
                                    employeePhoto: quiz.userPhoto,
                                  ),
                                )),
                            onLongPress: () => showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                                context: context,
                                builder: (context) => QuizActionModal(
                                      quizStatusTitle: statusFullTitle,
                                      quizRoomID: "${quiz.quizRoomId}",
                                    )),
                          );
                  },
                );
              } else {
                return Container(
                  child: Center(
                    child: EmptyData(
                      message: "No Questionnaire here",
                    ),
                  ),
                );
              }
            } else if (snapshot.hasError) {
              print("Snapshot Error Found!");
              print(snapshot.error);
              return CircularLoading();
            } else {
              return CircularLoading();
            }
          },
        ),
      ),
    );
  }
}

class QuizRoomCard extends StatelessWidget {
  final String title;
  final String expireDate;
  final String label;
  final void Function() onTap;
  const QuizRoomCard(
      {Key key, this.title, this.expireDate, this.label, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        "Expire on : $expireDate",
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.play_arrow,
                        color: kDarkColor,
                        size: 24,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class QuizEmployerRoomCard extends StatelessWidget {
  final String title;
  final String expireDate;
  final String employeePhoto;
  final String employeeName;
  final String employeeUsername;
  final IconData statusIcon;
  final Color statusColor;
  final double statusSize;
  final String quizRoomID;
  final String label;
  final void Function() onTap;
  final void Function() onLongPress;
  const QuizEmployerRoomCard(
      {Key key,
      this.title,
      this.expireDate,
      this.label,
      this.onTap,
      this.employeePhoto,
      this.employeeName,
      this.employeeUsername,
      this.quizRoomID,
      this.onLongPress,
      this.statusIcon,
      this.statusColor,
      this.statusSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      GestureDetector(
                        onTap: () {
                          showMaterialModalBottomSheet(
                              context: context,
                              builder: (context) => ViewCandidate(
                                    userUserName: employeeUsername,
                                  ));
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  AppSetting.showUserImage(employeePhoto),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(employeeName)
                          ],
                        ),
                      ),
                      Text(
                        "Expire on : $expireDate",
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        statusIcon,
                        color: statusColor,
                        size: statusSize,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class QuizActionModal extends StatefulWidget {
  final employeePhoto;
  final employeeName;
  final quizStatusTitle;
  final quizRoomID;
  const QuizActionModal(
      {Key key,
      this.employeePhoto,
      this.employeeName,
      this.quizStatusTitle,
      this.quizRoomID})
      : super(key: key);

  @override
  _QuizActionModalState createState() => _QuizActionModalState();
}

class _QuizActionModalState extends State<QuizActionModal> {
  List options = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: size.width,
        height: size.height * 0.2,
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                child: Text(
                  '"${widget.quizStatusTitle}"',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.grey),
                )),
            Expanded(
              child: Container(
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    ListTile(
                      onTap: () => print("Copy this"),
                      leading: Icon(Icons.control_point_duplicate),
                      title: Text("Send to another employee"),
                    ),
                    ListTile(
                      onTap: () => print("Edit"),
                      leading: Icon(Icons.edit),
                      title: Text("Edit Questionnaire"),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
