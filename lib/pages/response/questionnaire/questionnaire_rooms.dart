import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:remark_app/apis/candidates/all_candidates_api.dart';
import 'package:remark_app/apis/responses/questionnaire/fetch_quiz_api.dart';
import 'package:remark_app/components/empty/empty_data.dart';
import 'package:remark_app/components/loading/circular_loading.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/response/questionnaire/employer_quiz_room.dart';
import 'package:remark_app/model/response/questionnaire/questionnaire_questions.dart';
import 'package:remark_app/pages/response/questionnaire/edit_questionnaire.dart';
import 'package:remark_app/pages/response/questionnaire/preview_questionnaire.dart';
import 'package:remark_app/pages/response/questionnaire/questionnaire.dart';
import 'package:remark_app/pages/response/questionnaire/questionnaire_employees.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_select/awesome_select.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class QuestionnaireRooms extends StatefulWidget {
  const QuestionnaireRooms({Key key}) : super(key: key);

  @override
  _QuestionnaireRoomsState createState() => _QuestionnaireRoomsState();
}

class _QuestionnaireRoomsState extends State<QuestionnaireRooms> {
  Future<EmployerQuizRoomModel> _quizRoom;
  List<S2Choice> _getCandidates = [];
  bool isSending = false;
  TextEditingController _expiryDateTime = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _quizRoom = _fetchQuizRoom();
    });
    super.initState();
  }

  Future<EmployerQuizRoomModel> _fetchQuizRoom() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Future<EmployerQuizRoomModel> _quizTempRoom;
    _quizTempRoom =
        FetchQuizRoomApi().employerQuizRoom(pref.getString("userID"));

    return _quizTempRoom;
  }

  Future<List<S2Choice>> getCandidates() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<S2Choice> _getTempCandidates = [];

    await AllCandidates()
        .getCandidatesForList(pref.getString("userID"))
        .then((candidates) {
      candidates.data.userList.forEach((candidate) {
        _getTempCandidates
            .add(S2Choice(value: candidate.userId, title: candidate.userName));
      });
    });

    return _getTempCandidates;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<EmployerQuizRoomModel>(
        future: _quizRoom,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return LiquidPullToRefresh(
              color: kDarkColor,
              animSpeedFactor: 5,
              child: snapshot.data.status
                  ? ListView.builder(
                      itemCount: snapshot.data.data.length,
                      itemBuilder: (context, index) {
                        var room = snapshot.data.data[index];
                        List quizData = jsonDecode(room.quiz);
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuestionnaireEmployees(
                                    quizID: room.quizId,
                                  ),
                                ));
                          },
                          onLongPress: () {
                            showBarModalBottomSheet(
                              context: context,
                              isDismissible: true,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      topLeft: Radius.circular(20))),
                              builder: (context) {
                                return Container(
                                  height: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListView(
                                      children: [
                                        ListTile(
                                          onTap: () {
                                            Navigator.pop(context);
                                            List<QuestionnaireQuestionsModel>
                                                q = [];
                                            quizData.forEach((element) {
                                              q.add(QuestionnaireQuestionsModel(
                                                  question: element['question'],
                                                  options: [
                                                    element['answer_A'],
                                                    element['answer_B'],
                                                    element['answer_C'],
                                                    element['answer_D'],
                                                  ],
                                                  answerA: element['answer_A'],
                                                  answerB: element['answer_B'],
                                                  answerC: element['answer_C'],
                                                  answerD: element['answer_D'],
                                                  rightAnswer:
                                                      element['right_answer'],
                                                  employeeAnswer:
                                                      element['employee_answer']
                                                          .toString()));
                                            });

                                            q.forEach((element) {
                                              print(element.options);
                                            });
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PreviewQuestionnaire(
                                                    questionnaire: q,
                                                  ),
                                                ));
                                          },
                                          leading:
                                              Icon(Icons.remove_red_eye_sharp),
                                          title: Text(
                                            "Preview",
                                            style: GoogleFonts.poppins(),
                                          ),
                                        ),
                                        ListTile(
                                          onTap: () async {
                                            Navigator.pop(context);
                                            getCandidates()
                                                .then((candidatesList) {
                                              _getCandidates = candidatesList;
                                              setState(() {});
                                            });

                                            String quizExpiryDate = "";
                                            List _selectedEmployees = [];

                                            await showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text(
                                                  "Select Employees",
                                                  style: GoogleFonts.poppins(),
                                                ),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                elevation: 5,
                                                actions: [
                                                  !isSending
                                                      ? Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                          child: SmartSelect
                                                              .multiple(
                                                            placeholder:
                                                                "Employees",
                                                            title:
                                                                "Select Employees",
                                                            choiceEmptyBuilder:
                                                                (context,
                                                                        value) =>
                                                                    Center(
                                                                        child:
                                                                            EmptyData(
                                                              message:
                                                                  "No Employee found",
                                                            )),
                                                            modalConfirm: true,
                                                            choiceConfig: S2ChoiceConfig(
                                                                useDivider:
                                                                    true,
                                                                style: S2ChoiceStyle(
                                                                    titleStyle:
                                                                        GoogleFonts
                                                                            .poppins(),
                                                                    accentColor:
                                                                        kDarkColor,
                                                                    color:
                                                                        kDarkColor)),
                                                            modalConfig:
                                                                S2ModalConfig(
                                                              filterAuto: true,
                                                            ),
                                                            modalFilter: true,
                                                            choiceItems:
                                                                _getCandidates,
                                                            onChange: (value) {
                                                              print(
                                                                  value.value);
                                                              _selectedEmployees =
                                                                  value.value;
                                                            },
                                                          ),
                                                        )
                                                      : CircularLoading(),
                                                  !isSending
                                                      ? Container(
                                                          width:
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.8,
                                                          child: TextField(
                                                              controller:
                                                                  _expiryDateTime,
                                                              decoration:
                                                                  InputDecoration(
                                                                      hintText:
                                                                          "Select Quiz Expiry Date & Time"),
                                                              onTap: () async {
                                                                DateTime pickDate = await showDatePicker(
                                                                    context:
                                                                        context,
                                                                    initialDate:
                                                                        DateTime
                                                                            .now(),
                                                                    firstDate:
                                                                        DateTime
                                                                            .now(),
                                                                    lastDate: DateTime
                                                                            .now()
                                                                        .add(Duration(
                                                                            days:
                                                                                360)));

                                                                TimeOfDay
                                                                    pickTime =
                                                                    await showTimePicker(
                                                                        context:
                                                                            context,
                                                                        initialTime:
                                                                            TimeOfDay.now());

                                                                setState(() {
                                                                  quizExpiryDate =
                                                                      "${pickDate.year}-${pickDate.month}-${pickDate.day} ${pickTime.hour}:${pickTime.minute}:00";
                                                                  _expiryDateTime
                                                                          .text =
                                                                      quizExpiryDate;
                                                                });
                                                                print(pickDate);
                                                                print(pickTime);
                                                              }))
                                                      : CircularLoading(),
                                                  !isSending
                                                      ? Container(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              MaterialButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                child: Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .close,
                                                                      color: Colors
                                                                          .redAccent,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Text(
                                                                      "Cancel",
                                                                      style: GoogleFonts.poppins(
                                                                          color:
                                                                              Colors.redAccent),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              MaterialButton(
                                                                onPressed:
                                                                    () async {
                                                                  isSending =
                                                                      true;
                                                                  setState(
                                                                      () {});
                                                                  _selectedEmployees
                                                                      .forEach(
                                                                          (element) async {
                                                                    var sendData =
                                                                        jsonEncode({
                                                                      "quiz_id":
                                                                          room.quizId,
                                                                      "employee_id":
                                                                          element,
                                                                      "employer_id":
                                                                          room.quizEmployerId,
                                                                      "job_id":
                                                                          "0",
                                                                      "quiz": jsonDecode(
                                                                          room.quiz),
                                                                      "quiz_time":
                                                                          jsonDecode(
                                                                              room.quizTime),
                                                                      "quiz_expire_time":
                                                                          quizExpiryDate
                                                                    });

                                                                    print(
                                                                        sendData);

                                                                    await FetchQuizRoomApi()
                                                                        .sendQuiz(
                                                                            sendData)
                                                                        .then(
                                                                            (value) {
                                                                      if (value
                                                                          .status) {
                                                                        print(
                                                                            "Sent");
                                                                      } else {
                                                                        print(
                                                                            "Not Sent");
                                                                      }
                                                                    });
                                                                  });

                                                                  var snackBar =
                                                                      SnackBar(
                                                                          content:
                                                                              Text("Questionnaire send successfully"));
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .check,
                                                                      color:
                                                                          kDarkColor,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Text(
                                                                      "Send",
                                                                      style: GoogleFonts.poppins(
                                                                          color:
                                                                              kDarkColor),
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      : Container()
                                                ],
                                              ),
                                            );
                                          },
                                          leading: Icon(Icons.send_rounded),
                                          title: Text(
                                            "Send to Employee",
                                            style: GoogleFonts.poppins(),
                                          ),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            Navigator.pop(context);
                                            pushNewScreen(context,
                                                withNavBar: false,
                                                customPageRoute:
                                                    MaterialPageRoute(
                                                  maintainState: true,
                                                  builder: (context) =>
                                                      EditQuestionnaire(
                                                          quiz: room),
                                                ));
                                          },
                                          title: Text(
                                            "Edit",
                                            style: GoogleFonts.poppins(),
                                          ),
                                          leading: Icon(Icons.edit),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          title: Text(
                            "${room.quizTitle}",
                            style: GoogleFonts.poppins(),
                          ),
                          subtitle: Text(
                            "Total Questions : ${quizData.length}",
                            style: GoogleFonts.poppins(),
                          ),
                          trailing: Text(
                            timeAgo.format(room.quizCreatedAt),
                            style: GoogleFonts.poppins(fontSize: 12),
                          ),
                        );
                      },
                    )
                  : EmptyData(
                      message:
                          "Not Created any Questionnaire \n click + icon to create new",
                    ),
              onRefresh: () {
                final Completer<void> completer = Completer<void>();
                Timer(const Duration(seconds: 1), () {
                  completer.complete();
                });

                setState(() {
                  _quizRoom = _fetchQuizRoom();
                });

                return completer.future.then<void>((_) {
                  print("refreshed");
                });
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.hasError}");
          } else {
            return CircularLoading();
          }
        },
      ),
    );
  }
}
