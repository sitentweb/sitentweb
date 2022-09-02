import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/jobs/similar_jobs_model.dart';

class SimilarJobsApi {

  final client = http.Client();

  Future<SimilarJobsModel> similarJobs(jobSkills , jobID , userID) async {
    SimilarJobsModel thisResponse = SimilarJobsModel();
    
    try{
      
      final response = await client.get(Uri.parse(getSimilarJobsApiUrl + '?skills='+jobSkills+'&job_id='+jobID+"&user_id="+userID));

      if(response.statusCode == 200){

        if(jsonDecode(response.body)['data'] != false){
          thisResponse = similarJobsModelFromJson(response.body);

        }else{
          thisResponse = SimilarJobsModel(
            status: false,
            data: []
          );
        }

        return thisResponse;


      }else{
        print("Wrong status code : ${response.statusCode}");
      }
      
    }catch(e){
      print("Exception in Fetching Similar Jobs");
      print(e);
    }finally{
      client.close();
    }
    
    return thisResponse;
  }

}