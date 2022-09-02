import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/jobs/view_job_model.dart';

class ViewJobApi {
  
  Future<ViewJobModel> getJob(userID, jobID) async {
    
    var client = http.Client();
    ViewJobModel thisResponse;
    
    try {
      final response = await client.get(Uri.parse(getJobApiUrl+"?user_id="+userID+"&job_id="+jobID));

      if(response.statusCode == 200){
        thisResponse = viewJobModelFromJson(response.body);

        return thisResponse;
      }

    }catch(e){
      print(e);
    }finally{
      client.close();
    }

    return thisResponse;
    
  }
  
}