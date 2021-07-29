import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/global/global_status_model.dart';

class PostJobApi {
  
  final client = http.Client();
  
  Future<GlobalStatusModel> postJob(jobData) async {
    GlobalStatusModel thisResponse = GlobalStatusModel();
    
    try{
      
      final response = await client.post(Uri.parse(createJobApiUrl) , body: {
        "job_data" : jobData
      });

      if(response.statusCode == 200){

        if(jsonDecode(response.body)['status']){

          thisResponse = globalStatusModelFromJson(response.body);

        }else{
          thisResponse = GlobalStatusModel(
            status: false,
            data: null
          );
        }

        return thisResponse;

      }else{
        print("Wrong Status Code : ${response.statusCode}");
      }
      
    }catch(e){
      print(e);
    }finally{
      client.close();
    }
    
    return thisResponse;
  }
  
}