import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remark_app/apis/responses/questionnaire/fetch_quiz_api.dart';
import 'package:remark_app/components/buttons/icon_circle_button.dart';
import 'package:remark_app/components/loading/circular_loading.dart';
import 'package:remark_app/components/text/IconText.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/response/questionnaire/employer_quiz_room.dart';
import 'package:remark_app/model/response/questionnaire/questionnaire_questions.dart';
import 'package:remark_app/pages/response/questionnaire/preview_questionnaire.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditQuestionnaire extends StatefulWidget {
  final Datum quiz;
  const EditQuestionnaire({Key key, this.quiz}) : super(key: key);

  @override
  _EditQuestionnaireState createState() => _EditQuestionnaireState();
}

class _EditQuestionnaireState extends State<EditQuestionnaire> {

  bool isCreating = false;

  List<QuestionnaireQuestionsModel> questions = [];
  List<QuestionnaireQuestionsModel> newQuestions = [];

  int _quizLength = 1;
  int selectedValue = 0;
  TextEditingController _questionController = TextEditingController();
  TextEditingController _questionnaireTitle = TextEditingController();
  TextEditingController _quizFinishTime = TextEditingController();
  SwiperController _swiperController = SwiperController();
  String quizFinishTimeHour = "00";
  String quizFinishTimeMinute = "00";

  var userID;



  int _rightAnswer = 0;

  TextEditingController _option1 = TextEditingController();
  TextEditingController _option2 = TextEditingController();
  TextEditingController _option3 = TextEditingController();
  TextEditingController _option4 = TextEditingController();

  Future addMoreQuiz() async {

    setState(() {
      _quizLength++;
      questions.add(QuestionnaireQuestionsModel(
          rightAnswer: "0",
          question: "",
          options: ["" , "" , "" , ""],
          employeeAnswer: "",
          answerD: "",
          answerC: "",
          answerB: "",
          answerA: ""
      ));
      _questionController.text = "";
      _option4.text = "";
      _option3.text = "";
      _option2.text = "";
      _option1.text = "";
      _rightAnswer = 0;
      selectedValue = 0;
    });

    print("Added to ${questions.length-1}");

    moveToAddedIndex(questions.length);

  }

  moveToAddedIndex(index) {

    _swiperController.move(index, animation: true);

  }

  _sendToEmployees(data) async {

    // CREATING DATA FOR DATABASE

    var quizData = jsonEncode({
      "quiz_id" : widget.quiz.quizId,
      "employer_id" : "$userID",
      "quiz_title" : _questionnaireTitle.text ?? "",
      "quiz_time" : {
        "hour" : "$quizFinishTimeHour",
        "minute" : "$quizFinishTimeMinute"
      },
      "quiz" : data,
      "quiz_expire_time" : ""
    });

    print(quizData);

    await FetchQuizRoomApi().updateEmpQuiz(quizData).then((response) {
      var snackBar;
      if(response.status){
        print("Quiz Updated Successfully");
        snackBar = SnackBar(
          content: Text("Questionnaire Updated Successfully" , style: GoogleFonts.poppins(
              color: Colors.white
          ),),
          backgroundColor: kLightColor,
        );


      }else{
        setState(() {
          isCreating = false;
        });
        snackBar = SnackBar(
          content: Text("Something went wrong" , style: GoogleFonts.poppins(
              color: Colors.white
          ),),
          backgroundColor: Colors.redAccent,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Future.delayed(Duration(seconds: 3));

      Navigator.pop(context);

    });

  }

  _updateNewQuestionnaire(int index , String question , String answerA , String answerB , String answerC , String answerD , String rightAnswer) async {

    questions[index].question = question;
    questions[index].answerA = answerA;
    questions[index].answerB = answerB;
    questions[index].answerC = answerC;
    questions[index].answerD = answerD;
    questions[index].rightAnswer = rightAnswer.toString();

  }

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    _dataIntoTextControllers();
    super.initState();
  }

  getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      userID = pref.getString("userID");
    });
  }

  _dataIntoTextControllers() async {

    var _quizTime = jsonDecode(widget.quiz.quizTime);

    var _qTime = "${_quizTime['hour']} Hours ${_quizTime['minute']} Minutes";

    _questionnaireTitle.text = widget.quiz.quizTitle;
    _quizFinishTime.text = _qTime;

    List _ques = jsonDecode(widget.quiz.quiz);

    _ques.forEach((element) {
      element['options'] = [element['answer_A'] , element['answer_B'] , element['answer_C'] , element['answer_D']];
      element['employee_answer'] = element['employee_answer'].toString();
    });

    var q = jsonEncode(_ques);

     List<QuestionnaireQuestionsModel> _quesQuiz = questionnaireQuestionsModelFromJson(q);

     setState(() {
       questions = _quesQuiz;
     });


    _questionController.text = questions[0].question;
    _option1.text = questions[0].answerA;
    _option2.text = questions[0].answerB;
    _option3.text = questions[0].answerC;
    _option4.text = questions[0].answerD;
    selectedValue = int.parse(questions[0].rightAnswer);

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData.fallback(),
        title: Text("${widget.quiz.quizTitle}" , style: GoogleFonts.poppins(
          color: kDarkColor,
          fontSize: 14
        )),
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.symmetric(vertical: 10 , horizontal: 20),
                    child: TextField(
                      controller: _questionnaireTitle,
                      decoration: InputDecoration(
                          hintText: "Questionnaire Title",
                          hintStyle: GoogleFonts.poppins(),
                          helperText: "Note : Title will also visible to employee",
                          helperStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold
                          )
                      ),
                    )
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10 , horizontal: 20),
                  child: TextField(
                    controller: _quizFinishTime,
                    decoration: InputDecoration(
                        labelText: "Quiz Finishing Time",
                        labelStyle: GoogleFonts.poppins(),
                        hintText: "00 Hours 00 Minutes",
                        hintStyle: GoogleFonts.poppins(),
                        helperText: "Finishing time for employee",
                        helperStyle: GoogleFonts.poppins()
                    ),
                    onTap: () {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(hour: 00 , minute: 00),
                      ).then((value) {
                        print(value);
                        if(value != null) {
                          var time = value.hour.toString().padLeft(2 , '0') + " Hours " + value.minute.toString().padLeft(2 , '0') + " Minutes";
                          setState(() {
                            _quizFinishTime.text = time;
                            quizFinishTimeHour = value.hour.toString().padLeft(2, '0');
                            quizFinishTimeMinute = value.minute.toString().padLeft(2 , '0');
                          });
                        }
                      });
                    },
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  height: size.height * 0.9,
                  child: Swiper(
                    controller: _swiperController,
                    onIndexChanged: (value) {
                      print(value);
                      _questionController.text = questions[value].question;
                      _option1.text = questions[value].answerA;
                      _option2.text = questions[value].answerB;
                      _option3.text = questions[value].answerC;
                      _option4.text = questions[value].answerD;
                      selectedValue = int.parse(questions[value].rightAnswer);
                    },
                    containerHeight: size.height,
                    itemHeight: size.height,
                    itemCount: questions.length,
                    scrollDirection: Axis.horizontal,
                    itemWidth: size.width,
                    loop: false,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var q = questions[index];

                      return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10
                          ),
                          child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: size.width,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                decoration: BoxDecoration(
                                    color: kDarkColor,
                                    borderRadius: BorderRadius.all(Radius.circular(50))
                                ),
                                child: Text("Question ${index + 1}" , style: GoogleFonts.poppins(
                                    color: Colors.white
                                ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  height: 80,
                                  child: TextField(
                                    controller: _questionController,
                                    onChanged: (value) {
                                      q.question = value;
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Enter your Question",
                                    ),
                                  )
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                  padding: EdgeInsets.only(top: 30),
                                  height: 320,
                                  child: Column(
                                    children: [
                                      InkWell(
                                        child: Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                                color: Colors.grey[300]
                                            ),
                                            padding: EdgeInsets.symmetric(vertical: 5),
                                            child: options( 0 ,"Options" , _option1 ,q, 0 , selectedValue)
                                        ),
                                      ),
                                      InkWell(
                                        child: Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                                color: Colors.grey[300]
                                            ),
                                            padding: EdgeInsets.symmetric(vertical: 5),
                                            child: options( 1,"Options", _option2,q, 1 , selectedValue)
                                        ),
                                      ),
                                      InkWell(
                                        child: Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                                color: Colors.grey[300]
                                            ),
                                            padding: EdgeInsets.symmetric(vertical: 5),
                                            child: options(2,"Options" , _option3,q, 2 , selectedValue)
                                        ),
                                      ),
                                      InkWell(
                                        child: Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                                color: Colors.grey[300]
                                            ),
                                            padding: EdgeInsets.symmetric(vertical: 5),
                                            child: options(3,"Options" , _option4, q, 3 , selectedValue)
                                        ),
                                      )
                                    ],
                                  )
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Select a correct answer, so that we can calculate the score after employee submit the questionnaire" , style: GoogleFonts.poppins(),),
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              Divider(),
                              Container(
                                padding: EdgeInsets.all(0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    if(index != 0)
                                    IconCircleButton(
                                      onPressed: () {
                                        _updateNewQuestionnaire(
                                            index,
                                            _questionController.text,
                                            _option1.text,
                                            _option2.text,
                                            _option3.text,
                                            _option4.text,
                                            selectedValue.toString()
                                        );
                                        _swiperController.previous(animation: true);
                                      },
                                      icon: Icons.chevron_left_rounded,
                                      title: "Previous",
                                    ),
                                    IconCircleButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => PreviewQuestionnaire(questionnaire: questions,),));
                                      },
                                      icon: Icons.remove_red_eye,
                                      title: "Preview",
                                    ),
                                    if(index == questions.length-1)
                                    IconCircleButton(
                                      onPressed: () async {

                                        await addMoreQuiz().then((value) {

                                        });
                                        // control swiper to next

                                      },
                                      icon: Icons.add,
                                      title: "Add",
                                    ),
                                    if(index != questions.length-1)
                                    IconCircleButton(
                                      onPressed: () {
                                        _updateNewQuestionnaire(
                                            index,
                                            _questionController.text,
                                            _option1.text,
                                            _option2.text,
                                            _option3.text,
                                            _option4.text,
                                            selectedValue.toString()
                                        );
                                        _swiperController.next(animation: true);
                                      },
                                      icon: Icons.chevron_right_rounded,
                                      title: "Next",
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                      );
                    },
                  ),
                ),


                Divider(),
                Container(
                  child: !isCreating ? MaterialButton(
                    minWidth: size.width,
                    padding: EdgeInsets.all(0),
                    onPressed: () {

                      setState(() {
                        isCreating = true;
                      });

                      List data = [];
                      questions.forEach((quiz) {
                        data.add({
                          "question" : "${quiz.question.trim()}",
                          "answer_A" : "${quiz.options[0].trim()}",
                          "answer_B" : "${quiz.options[1].trim()}",
                          "answer_C" : "${quiz.options[2].trim()}",
                          "answer_D" : "${quiz.options[3].trim()}",
                          "right_answer" : "${quiz.rightAnswer}",
                          "employee_answer" : 0
                        });
                      });

                      _sendToEmployees(data);

                    },
                    child: Text("Submit" , style: GoogleFonts.poppins(
                        color: kDarkColor,
                        fontWeight: FontWeight.bold
                    ),),
                  ) : CircularLoading(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget options(int ind,hint , textController,QuestionnaireQuestionsModel q , value , groupValue) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              onChanged: (value) {
                q.options[ind] = value;
              },
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 5 , horizontal: 10),
                hintText: "Option",
                hintStyle: GoogleFonts.poppins(
                    fontSize: 14
                ),
                border: InputBorder.none,

              ),
            ),
          ),
          Radio(
            activeColor: kDarkColor,
            value: value,
            groupValue: groupValue,
            onChanged: (value) {
              print(value);
              setState(() {
                selectedValue = value;
                q.rightAnswer = value.toString();
              });
            },
          )
        ],
      ),
    );
  }
}
