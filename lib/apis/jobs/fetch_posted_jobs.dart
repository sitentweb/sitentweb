import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/jobs/posted_jobs_model.dart';

class FetchPostedJobs {

  Future<PostedJobsModel> fetchPostedJobs(userID) async {
      var client = http.Client();
      PostedJobsModel thisResponse;

      try {

        final response = await client.get(Uri.parse(fetchPostedJobsApiUrl+"?user_id="+userID));

        if(response.statusCode == 200){
          thisResponse = postedJobsModelFromJson(response.body);

          return thisResponse;
        }else{
          print(fetchPostedJobsApiUrl+"?user_id="+userID);
          print(response.statusCode);
        }

      }catch (e) {
        print(e);
      }finally{
        client.close();
      }

  }

}