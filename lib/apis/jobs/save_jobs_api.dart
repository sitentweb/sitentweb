import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/jobs/save_jobs_list_model.dart';
import 'package:remark_app/model/jobs/save_jobs_model.dart';

class SaveJobsApi {
  final client = http.Client();

  Future<SaveJobsModel> saveJobs(userID, jobID) async {
    SaveJobsModel thisResponse;

    try {
      final response = await client.post(Uri.parse(saveJobsApiUrl),
          body: {"user_id": userID, "job_id": jobID});

      if (response.statusCode == 200) {
        thisResponse = saveJobsModelFromJson(response.body);

        return thisResponse;
      } else {
        print("Wrong Status Code : ${response.statusCode}");
      }
    } catch (e) {
      print("Exception in saving jobs");
      print(e);
    } finally {
      client.close();
    }

    return thisResponse;
  }
  
  Future<SaveJobsListModel> saveJobsList(userID) async {
    SaveJobsListModel thisResponse;
    
    try{
      
      final response = await client.get(Uri.parse(fetchSaveJobsListApiUrl + "?user_id="+userID));

      if(response.statusCode == 200){

        thisResponse = saveJobsListModelFromJson(response.body);

        return thisResponse;

      }else{
        print("Wrong status code in save jobs list ${response.statusCode} ");
      }

    }catch(e){
      print("Exception in save jobs list");
      print(e);
    }finally{
      client.close();
    }

    return thisResponse;
  }
}
