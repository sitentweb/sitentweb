// To parse this JSON data, do
//
//     final questionnaireQuestionsModel = questionnaireQuestionsModelFromJson(jsonString);

import 'dart:convert';

List<QuestionnaireQuestionsModel> questionnaireQuestionsModelFromJson(String str) => List<QuestionnaireQuestionsModel>.from(json.decode(str).map((x) => QuestionnaireQuestionsModel.fromJson(x)));

String questionnaireQuestionsModelToJson(List<QuestionnaireQuestionsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class QuestionnaireQuestionsModel {
  QuestionnaireQuestionsModel({
    this.question,
    this.options,
    this.answerA,
    this.answerB,
    this.answerC,
    this.answerD,
    this.rightAnswer,
    this.employeeAnswer,
  });

  String question;
  List<String> options;
  String answerA;
  String answerB;
  String answerC;
  String answerD;
  String rightAnswer;
  String employeeAnswer;

  factory QuestionnaireQuestionsModel.fromJson(Map<String, dynamic> json) => QuestionnaireQuestionsModel(
    question: json["question"],
    options: List<String>.from(json["options"].map((x) => x)),
    answerA: json["answer_A"],
    answerB: json["answer_B"],
    answerC: json["answer_C"],
    answerD: json["answer_D"],
    rightAnswer: json["right_answer"],
    employeeAnswer: json["employee_answer"],
  );

  Map<String, dynamic> toJson() => {
    "question": question,
    "options": List<dynamic>.from(options.map((x) => x)),
    "answer_A": answerA,
    "answer_B": answerB,
    "answer_C": answerC,
    "answer_D": answerD,
    "right_answer": rightAnswer,
    "employee_answer": employeeAnswer,
  };
}
