import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/jobs/job_apply_status_model.dart';

class JobApplyStatusApi {
  final client = http.Client();

  Future<JobApplyStatusModel> jobApplyStatus(jobID, userID, employerID) async {
    print({"job_id": jobID, "user_id": userID, "employerID": employerID});
    JobApplyStatusModel thisResponse =
        JobApplyStatusModel(status: false, data: 0);

    try {
      final response = await client.post(Uri.parse(applyToJobsApiUrl), body: {
        "job_id": jobID,
        "user_id": userID,
        "employer_id": employerID
      });

      if (response.statusCode == 200) {
        thisResponse = jobApplyStatusModelFromJson(response.body);
      } else {
        thisResponse.data = 0;
      }

      return thisResponse;
    } catch (e) {
      print("Exception in user apply for job");
      print(e);
      thisResponse.data = 0;
      return thisResponse;
    } finally {
      client.close();
    }
  }
}
