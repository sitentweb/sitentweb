import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/global/global_status_model.dart';
import 'package:remark_app/model/response/fetch_quiz_room.dart';
import 'package:remark_app/model/response/questionnaire/employer_quiz_room.dart';
import 'package:remark_app/model/response/questionnaire/fetch_quiz_data.dart';
import 'package:remark_app/model/response/questionnaire/quiz_employees_model.dart';
import 'package:remark_app/model/response/questionnaire/start_quiz_model.dart';
import 'package:remark_app/model/response/questionnaire/update_quiz_model.dart';

class FetchQuizRoomApi {

  final client = http.Client();

  Future<FetchQuizRoomModel> fetchQuizRoom(userID) async {
      FetchQuizRoomModel thisResponse;
      print(Uri.parse(fetchQuizRoomApiUrl + "?user_id="+userID));

      try{

        final response = await client.get(Uri.parse(fetchQuizRoomApiUrl + "?user_id="+userID));

        if(response.statusCode == 200){

          if(jsonDecode(response.body)['status']){

            thisResponse = fetchQuizRoomModelFromJson(response.body);

          }else{
            print("Data not available");
            thisResponse = FetchQuizRoomModel(status: false);
          }

          return thisResponse;

        }else{

         print("Wrong Status Code ${response.statusCode}");

        }

        return thisResponse;

      }catch(e){
        print("Exception in fetch quiz room");
        print("user id = $userID");
        print(e);
      }finally{
        client.close();
      }
      return thisResponse;
  }
  
  Future<UpdateQuizModel> updateQuiz(quizID, quizData) async {
      UpdateQuizModel thisResponse;
      
      try{
        
        final response = await client.post(Uri.parse(updateQuizDataApiUrl) , body: {
          "quiz_room_id" : quizID,
          "quiz_data" : quizData
        });

        if(response.statusCode == 200){
          print(jsonDecode(response.body));
          thisResponse = updateQuizModelFromJson(response.body);

          return thisResponse;

        }else{
          print("Wrong Status Code ${response.statusCode}");
        }
        
      }catch(e){
        print("Exception while updating quiz data");
      }finally{
        client.close();
      }

      return thisResponse;
      
  }

  Future<StartQuizModel> startQuiz(quizRoomID) async {
     StartQuizModel thisResponse;

     try{

       final response = await client.get(Uri.parse(startQuizDataApiUrl + "?quiz_room_id="+quizRoomID));

       if(response.statusCode == 200){
          thisResponse = startQuizModelFromJson(response.body);

          return thisResponse;
       }else{
         print("Wrong Status Code in starting quiz ${response.statusCode} ");
       }

     }catch(e){
        print("Exception when starting quiz");
        print(e);
     }finally{
       client.close();
     }

     return thisResponse;

  }

  Future<FetchQuizDataModel> fetchQuizData(roomID) async {

    FetchQuizDataModel thisResponse;

    try{

      final response = await client.get(Uri.parse(getQuizDataApiUrl+"?room_id="+roomID));

      if(response.statusCode == 200){

        thisResponse = fetchQuizDataModelFromJson(response.body);

        return thisResponse;

      }

    }catch(e){
      print("Expection in $getQuizDataApiUrl");
      print(e);
    }finally{
      client.close();
    }

    return thisResponse;

  }

  Future<GlobalStatusModel> createQuiz(quizData) async {
    GlobalStatusModel thisResponse;

    try{

      final response = await client.post(Uri.parse(createQuestionnaireApiUrl) , body: {
        "quiz_data" : quizData
      });

      if(response.statusCode == 200){

        if(jsonDecode(response.body)['status']){
          thisResponse = globalStatusModelFromJson(response.body);

          return thisResponse;
        }else{
          thisResponse = GlobalStatusModel(
            status: false,
            data: false,
          );
        }

      }else{
        print("Wrong Status Code in creating quiz : ${response.body}");
      }

    }catch(e){
      print(e);
    }finally{
      client.close();
    }

    return thisResponse;
  }

  Future<EmployerQuizRoomModel> employerQuizRoom(employerID) async {
    EmployerQuizRoomModel thisResponse = EmployerQuizRoomModel();

    try{

      final response = await client.get(Uri.parse(employerQuizRoomApiUrl+"?employer_id="+employerID));

      if(response.statusCode == 200){

        if(jsonDecode(response.body)['status']){

          thisResponse = employerQuizRoomModelFromJson(response.body);

        }else{
          thisResponse = EmployerQuizRoomModel(
            status: false,
            data: []
          );
        }

        return thisResponse;

      }else{
        print("Wrong Status Code in employer quiz room : ${response.statusCode}");
      }

    }catch(e){
      print(e);
    }finally{
      client.close();
    }

    return thisResponse;
  }

  Future<QuizEmployeesRoomModel> fetchQuizEmployeeRoom(quizID) async {

    QuizEmployeesRoomModel thisResponse = QuizEmployeesRoomModel();

    try{

      final response = await client.get(Uri.parse(quizEmployeesRoomApiUrl+"?quiz_id="+quizID));

      if(response.statusCode == 200){

        if(jsonDecode(response.body)['status']){
          thisResponse = quizEmployeesRoomModelFromJson(response.body);
        }else{
          thisResponse = QuizEmployeesRoomModel(
            status: false,
            data: []
          );
        }

        return thisResponse;

      }else{
        print("Wrong status code in quiz employees room : ${response.statusCode} ");
      }

    }catch(e){
      print(e);
    }finally{
      client.close();
    }

    return thisResponse;

  }

  Future<GlobalStatusModel> sendQuiz(quizData) async {
    GlobalStatusModel thisResponse;

    try{

      final response = await client.post(Uri.parse(sendQuizApiUrl) , body: {
        'quizData' : quizData.toString()
      });

      if(response.statusCode == 200){

        thisResponse = globalStatusModelFromJson(response.body);

        return thisResponse;

      }

    }catch(e){
      print(e);
    }finally{
      client.close();
    }

    return thisResponse;
  }

  Future<GlobalStatusModel> updateEmpQuiz(quizData) async {
    GlobalStatusModel thisResponse = GlobalStatusModel();

    try{

      final response = await client.post(Uri.parse(updateEmpQuizDataApiUrl) , body: {
        "quiz_data" : quizData
      });

      if(response.statusCode == 200){
        print(jsonDecode(response.body));
        thisResponse = globalStatusModelFromJson(response.body);

        return thisResponse;

      }else{
        print("Wrong Status Code ${response.statusCode}");
      }

    }catch(e){
      print("Exception while updating quiz data");
    }finally{
      client.close();
    }

    return thisResponse;



  }

}