import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/jobs/applied_jobs_model.dart';
import 'package:remark_app/model/jobs/change_job_applied_status_model.dart';

class AppliedJobsApi {
  
  Future<AppliedJobsModel> fetchAppliedJobs(userID) async {
      var client = http.Client();
      AppliedJobsModel thisResponse;
      
      try {
        
        http.Response response = await client.get(Uri.parse(fetchAppliedJobsApiUrl+'?user_id='+userID));

        if(response.statusCode == 200){

          var result = response.body;

          if(jsonDecode(result)["status"] == true){

            thisResponse = appliedJobsModelFromJson(result);

            return thisResponse;

          }else{
            thisResponse = AppliedJobsModel(
              status: false,
              data: []
            );
            return thisResponse;
          }

        }
        
      } catch(e) {
        print("$userID $e");
      } finally {
        client.close();
      }

      return thisResponse;
      
  }

  Future<UpdateJobAppliedModel> updateJobApplied(userID , jobID, employerID , status) async {

    UpdateJobAppliedModel thisResponse = UpdateJobAppliedModel();

    var client = http.Client();

    try{

      final response = await client.post(Uri.parse(updateAppliedJobStatusApiUrl) , body: {
        "user_id" : userID,
        "job_id" : jobID,
        "employer_id" : employerID,
        "status" : status
      });

      if(response.statusCode == 200){
          thisResponse = updateJobAppliedModelFromJson(response.body);

          return thisResponse;
      }else{
        print("Wrong status code : ${response.statusCode} ");
      }

    }catch(e){
      print("Exception in update job applied status");
      print(e);
    }finally{
      client.close();
    }

    return thisResponse;

  }
  
}