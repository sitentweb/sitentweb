import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/jobs/job_apply_status_model.dart';

class JobApplyStatusApi {

  final client = http.Client();

  Future<JobApplyStatusModel> jobApplyStatus(jobID , userID , employerID) async {

    JobApplyStatusModel thisResponse = JobApplyStatusModel();

    try {
      final response = await client.post(Uri.parse(applyToJobsApiUrl) , body: {
        "job_id" : jobID,
        "user_id" : userID,
        "employer_id" : employerID
      });

      if(response.statusCode == 200){

        thisResponse = jobApplyStatusModelFromJson(response.body);

        return thisResponse;

      }

    }catch(e){
      print("Exception in user apply for job");
      print(e);
    }finally{
      client.close();
    }

  }

}