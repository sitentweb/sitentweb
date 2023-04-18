import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remark_app/apis/responses/questionnaire/fetch_quiz_api.dart';
import 'package:remark_app/components/loading/circular_loading.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/response/questionnaire/questionnaire_questions.dart';
import 'package:remark_app/pages/response/responses.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllQuestions extends StatefulWidget {
  final quizID;
  final fullQuiz;
  final quizRoomID;
  const AllQuestions({Key key, this.quizID, this.fullQuiz, this.quizRoomID})
      : super(key: key);

  @override
  AllQuestionsState createState() => AllQuestionsState();
}

class AllQuestionsState extends State<AllQuestions> {
  var userType;
  bool isLoading = false;
  List rightAnswer = [];
  int _currentQuestion = 0;
  List<QuestionnaireQuestionsModel> _questions = [];
  List options = [];
  List quizAnswers = [];
  var quizDataStorage;
  int _selectOption;
  SwiperController _swiperController = SwiperController();
  GlobalKey<AllQuestionsState> allQuestionKey = GlobalKey();

  @override
  void initState() {
    getUserData();
    questionsLists();
    print(widget.quizID);
    // TODO: implement initState
    super.initState();
  }

  getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      userType = pref.getString("userType");
    });
  }

  questionsLists() {
    List _oldData = jsonDecode(widget.fullQuiz);
    QuestionnaireQuestionsModel _ques;
    _oldData.forEach((element) {
      setState(() {
        if (element['right_answer'] == "0") {
          rightAnswer.add("0");
        } else if (element['right_answer'] == "1") {
          rightAnswer.add("1");
        } else if (element['right_answer'] == "2") {
          rightAnswer.add("2");
        } else if (element['right_answer'] == "3") {
          rightAnswer.add("3");
        }

        print("All Answers ${element['right_answer']}");
      });

      _ques = QuestionnaireQuestionsModel(
          options: [
            element['answerA'],
            element['answerB'],
            element['answerC'],
            element['answerD']
          ],
          question: element['question'],
          employeeAnswer: element['employee_answer'].toString());
      setState(() {
        _questions.add(_ques);
      });
    });
  }

  _onSelectOption(int opIndex) {
    //change background color;
    setState(() {
      _selectOption = opIndex;
    });
  }

  _onSelectFinalOption(int answerIndex) {
    setState(() {
      quizAnswers.add(answerIndex);
    });
    print(rightAnswer);
    print(quizAnswers);
  }

  _createQuizDataForDatabase() async {
    List createData = [];
    var counter = 0;

    _questions.asMap().forEach((index, element) {
      print("${element.question}");
      print("${element.options[0]}");
      print(rightAnswer);
      print(quizAnswers);

      createData.add({
        "question": "${element.question}",
        "answerA": "${element.options[0]}",
        "answerB": "${element.options[1]}",
        "answerC": "${element.options[2]}",
        "answerD": "${element.options[3]}",
        "right_answer": rightAnswer[index],
        "employee_answer": quizAnswers[index]
      });
    });

    // SEND DATA TO DATABASE AFTER CREATING QUIZDATA;

    await FetchQuizRoomApi()
        .updateQuiz(widget.quizRoomID, jsonEncode(createData))
        .then((value) {
      print(value.status);
      var snackBar;
      if (value.status) {
        snackBar = SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Questionnaire Submitted Successfully",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        );
        Navigator.pop(context);
      } else {
        snackBar = SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Something went wrong, please try again",
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('want to exit from this Questionnaire?'),
            content: new Text(
                'You will not be able to access this questionnaire again'),
            actions: <Widget>[
              MaterialButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              MaterialButton(
                onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Responses(
                        initialIndex: 1,
                      ),
                    )),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                Container(
                  width: size.width,
                  height: 50,
                  child: Row(
                    children: [],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Swiper(
                      onTap: (index) => print("swiper "),
                      controller: _swiperController,
                      onIndexChanged: (value) {},
                      scrollDirection: Axis.horizontal,
                      itemWidth: size.width,
                      loop: false,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _questions.length,
                      itemBuilder: (context, index) {
                        var q = _questions[index];

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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    child: Text(
                                      "Question ${index + 1}",
                                      style:
                                          GoogleFonts.lora(color: Colors.white),
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 50),
                                    height: 350,
                                    child: ListView.builder(
                                      itemCount: q.options.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, opIndex) {
                                        return InkWell(
                                          onTap: () {
                                            _onSelectOption(opIndex);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30)),
                                                color: _selectOption != null &&
                                                        _selectOption == opIndex
                                                    ? Colors.green[200]
                                                    : Colors.grey[300]),
                                            padding: EdgeInsets.all(15),
                                            child:
                                                Text("${q.options[opIndex]}"),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // index == 0 ? Container() : MaterialButton(
                                        //     color: kLightColor,
                                        //   onPressed: () {
                                        //     print(_questions.length);
                                        //     print(index);
                                        //     setState(() {
                                        //       _swiperController.previous();
                                        //     });
                                        //   },
                                        //   child: Text("Previous" , style: TextStyle(
                                        //     color: Colors.white
                                        //   ),),
                                        // ),
                                        !isLoading
                                            ? MaterialButton(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 15),
                                                minWidth: 150,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50))),
                                                color: kDarkColor,
                                                onPressed: () {
                                                  print(_questions.length);
                                                  print(index);
                                                  if (_questions.length ==
                                                      index + 1) {
                                                    _onSelectFinalOption(
                                                        _selectOption);
                                                    _createQuizDataForDatabase();
                                                    setState(() {
                                                      isLoading = true;
                                                    });
                                                  } else {
                                                    _onSelectFinalOption(
                                                        _selectOption);
                                                    setState(() {
                                                      _selectOption = null;
                                                      _swiperController.next();
                                                    });
                                                  }
                                                },
                                                child: _questions.length ==
                                                        index + 1
                                                    ? Text(
                                                        "Submit",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )
                                                    : Text(
                                                        "Next",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                              )
                                            : CircularLoading(),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ));
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
