import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remark_app/apis/responses/questionnaire/fetch_quiz_api.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/response/questionnaire/questionnaire_questions.dart';
import 'package:remark_app/pages/response/questionnaire/preview_questionnaire.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateQuestionnaire extends StatefulWidget {
  const CreateQuestionnaire({Key key}) : super(key: key);

  @override
  _CreateQuestionnaireState createState() => _CreateQuestionnaireState();
}

class _CreateQuestionnaireState extends State<CreateQuestionnaire> {

  bool isCreating = false;

  List<QuestionnaireQuestionsModel> questions = [QuestionnaireQuestionsModel(
    question: "",
    options: ["" , "" , "" , ""],
    answerA: "",
    answerB: "",
    answerC: "",
    answerD: "",
    employeeAnswer: "",
    rightAnswer: "0"
  )];

  var userID;

  int _quizLength = 1;
  int selectedValue = 0;
  SwiperController _swiperController = SwiperController();
  TextEditingController _questionController = TextEditingController();
  TextEditingController _questionnaireTitle = TextEditingController();
  TextEditingController _quizFinishTime = TextEditingController();

  String quizFinishTimeHour = "00";
  String quizFinishTimeMinute = "00";

  TextEditingController _option1 = TextEditingController();
  TextEditingController _option2 = TextEditingController();
  TextEditingController _option3 = TextEditingController();
  TextEditingController _option4 = TextEditingController();

  int _rightAnswer = 0;

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
  }

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userID = pref.getString("userID");
    });
  }

  addMoreQuiz(int i) {
    questions[i].question = _questionController.text;
    questions[i].options[0] = _option1.text;
    questions[i].options[1] = _option2.text;
    questions[i].options[2] = _option3.text;
    questions[i].options[3] = _option4.text;
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

    _swiperController.move(i+1);
  }

  _sendToEmployees(data) async {

    // CREATING DATA FOR DATABASE

    var quizData = jsonEncode({
      "employer_id" : "$userID",
      "quiz_title" : "${_questionnaireTitle.text.replaceAll("\"", "'").trim()}" ?? "",
      "quiz_time" : {
        "hour" : "$quizFinishTimeHour",
        "minute" : "$quizFinishTimeMinute"
      },
      "quiz" : data,
      "quiz_expire_time" : ""
    });

    print(quizData);

    await FetchQuizRoomApi().createQuiz(quizData).then((response) {
        var snackBar;
        if(response.status){
          print("Quiz Created Successfully");
          snackBar = SnackBar(
              content: Text("Questionnaire Created Successfully" , style: GoogleFonts.poppins(
                color: Colors.white
              ),),
            backgroundColor: kLightColor,
          );


        }else{
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                    containerHeight: size.height,
                    itemHeight: size.height,
                    itemCount: questions.length,
                    scrollDirection: Axis.horizontal,
                    itemWidth: size.width,
                    loop: false,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var q = questions[index];
                      print(q);
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
                                    MaterialButton(
                                      color: kDarkColor,
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => PreviewQuestionnaire(questionnaire: questions,),));
                                      },
                                      child: Text("Preview" , style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ),
                                    if(index == (_quizLength -1))
                                    MaterialButton(
                                      onPressed: () {
                                        print(_quizLength.bitLength-1);
                                        addMoreQuiz(index);
                                      },
                                      child: Text("Add More" , style: GoogleFonts.poppins(
                                          color: Colors.white
                                      ),),
                                      color: kDarkColor,
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
                  child: MaterialButton(
                    minWidth: size.width,
                    padding: EdgeInsets.all(0),
                    onPressed: () {

                      setState(() {
                        isCreating = true;
                      });

                      List data = [];
                      questions.forEach((quiz) {
                        data.add({
                          "question" : "${quiz.question.replaceAll("\"", "'").trim()}",
                          "answer_A" : "${quiz.options[0].replaceAll("\"", "'").trim()}",
                          "answer_B" : "${quiz.options[1].replaceAll("\"", "'").trim()}",
                          "answer_C" : "${quiz.options[2].replaceAll("\"", "'").trim()}",
                          "answer_D" : "${quiz.options[3].replaceAll("\"", "'").trim()}",
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
                  ),
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
