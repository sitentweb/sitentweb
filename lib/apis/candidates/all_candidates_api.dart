import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/candidates/all_candidates.dart';
import 'package:remark_app/model/candidates/save_candidate_model.dart';

class AllCandidates {
  Future<AllCandidatesModel> fetchCandidates(userID, countLimit) async {
    var client = http.Client();
    AllCandidatesModel thisResponse;

    try {
      final response = await client.get(Uri.parse(fetchCandidatesApiUrl +
          "?count_limit=" +
          countLimit +
          "&employer_id=" +
          userID));

      if (response.statusCode == 200) {
        thisResponse = allCandidatesModelFromJson(response.body);

        return thisResponse;
      }
    } catch (e) {
      print("Exception in fetching candidates list");
      print(e);
    } finally {
      client.close();
    }

    return thisResponse;
  }

  Future<AllCandidatesModel> searchCandidates(userName , userSkills, userEducation, userLocation , employerID) async {
    var client = http.Client();
    AllCandidatesModel thisResponse = AllCandidatesModel();

    final data = {
      "name" : userName.toString(),
      "skills" : userSkills.toString(),
      "location" : userLocation.toString(),
      "education" : userEducation.toString(),
      "employer_id" : employerID.toString()
    };

    print(data);

    try{
      final response = await client.post(Uri.parse(searchCandidateApiUrl) , body: data);

      if(response.statusCode == 200){

        if(jsonDecode(response.body)['status']){

          thisResponse = allCandidatesModelFromJson(response.body);

        }else{
          thisResponse.status = false;
          thisResponse.data = Data(
            status: false,
            userList: []
          );
        }

        return thisResponse;

      }else{
        print("Wrong Status code in searching candidate : ${response.statusCode}");
        print(response.body);
      }

    }catch(e){
      print(e);
    }finally{
      client.close();
    }


  }

  Future<SaveCandidateModel> saveCandidate(userID, employeeID) async {
    final client = http.Client();
    SaveCandidateModel thisResponse;
    try {
      final response = await client.get(Uri.parse(saveCandidateApiUrl +
          "?employer_id=" +
          userID +
          "&employee_id=" +
          employeeID));

      if (response.statusCode == 200) {
        thisResponse = saveCandidateModelFromJson(response.body);

        return thisResponse;
      } else {
        print("Wrong status code in saving candidate : ${response.statusCode}");
      }
    } catch (e) {
      print("Exception in saving candidate");
      print(e);
    } finally {
      client.close();
    }

    return thisResponse;
  }

  Future<AllCandidatesModel> getCandidatesForList(employerID) async {
    final client = http.Client();
    AllCandidatesModel thisResponse = AllCandidatesModel();

    try{

      final response = await client.get(Uri.parse(candidatesForListApiUrl+"?employer_id="+employerID));

      if(response.statusCode == 200){
        thisResponse = allCandidatesModelFromJson(response.body);

        return thisResponse;

      }else{
        print('wrong status code ${response.statusCode}');
      }

    }catch(e){
      print(e);
    }finally{
      client.close();
    }

    return thisResponse;
  }
}
