import 'dart:convert';
import 'dart:developer';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/jobs/posted_jobs_model.dart';
import 'package:remark_app/model/jobs/single_posted_job_model.dart';

class FetchPostedJobs {
  var client = http.Client();
  final storage = GetStorage();

  Future<PostedJobsModel> fetchPostedJobs(userID) async {
    var client = http.Client();
    PostedJobsModel thisResponse;

    try {
      final response = await client
          .get(Uri.parse(fetchPostedJobsApiUrl + "?user_id=" + userID));

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status']) {
          thisResponse = postedJobsModelFromJson(response.body);
        } else {
          thisResponse = PostedJobsModel(status: false);
        }

        return thisResponse;
      } else {
        print(fetchPostedJobsApiUrl + "?user_id=" + userID);
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
  }

  Future<SinglePostedJobModel> fetchSinglePostedJob({jobId}) async {
    SinglePostedJobModel thisResponse = SinglePostedJobModel(status: false);

    try {
      final response = await client.get(
          Uri.parse(apiUrl['fetch-single-posted-job'] + "?job_id=" + jobId),
          headers: {"Authorization": storage.read('jwtToken')});

      if (response.statusCode == 200) {
        thisResponse = singlePostedJobModelFromJson(response.body);
      } else {
        thisResponse.message = "Invalid Response: ${response.statusCode}";
      }

      return thisResponse;
    } catch (e) {
      thisResponse.message = "Something went wrong";
      return thisResponse;
    }
  }
}
