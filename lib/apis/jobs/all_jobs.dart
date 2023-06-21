import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/jobs/all_jobs_model.dart';
import 'package:remark_app/model/jobs/job_list_model.dart';

class AllJobs {
  Future<AllJobsModel> fetchAllJobs(userID, countLimit) async {
    var client = http.Client();
    AllJobsModel thisResponse;

    try {
      final response = await client.get(Uri.parse(fetchAllJobsApiUrl +
          "?user_id=" +
          userID +
          "&count_limit=" +
          countLimit));

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'] == true) {
          thisResponse = allJobsModelFromJson(response.body);

          return thisResponse;
        } else {
          thisResponse = AllJobsModel(status: false, data: Data(jobList: []));
        }
      } else {
        print(fetchAllJobsApiUrl +
            "?user_id=" +
            userID +
            "&count_limit=" +
            countLimit);
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }

    return thisResponse;
  }

  Future<JobListModel> getSearchJobs(token, title, skills, location) async {
    var client = http.Client();
    JobListModel thisResponse = JobListModel(status: false);

    try {
      final response = await client.post(Uri.parse(apiUrl['search-jobs']),
          headers: {"Authorization": token},
          body: {"title": title, "skills": skills, "location": location});

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'] == true) {
          thisResponse = jobListModelFromJson(response.body);

          return thisResponse;
        }
      } else {
        print(jsonDecode(response.body));
        print(response.statusCode);
        thisResponse.message = "Response Error ${response.statusCode}";
      }
      return thisResponse;
    } catch (e) {
      print(e);
      thisResponse.message = e.toString();
      return thisResponse;
    } finally {
      client.close();
    }
  }

  Future<JobListModel> fetchLimitJobs(offset, {String token}) async {
    final client = http.Client();

    JobListModel thisResponse = JobListModel(status: false, jobs: []);

    try {
      final response = await client.get(
          Uri.parse("${apiUrl['fetch-limit-jobs']}?offset=$offset"),
          headers: {"Authorization": token});
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        if (result['status']) {
          thisResponse = jobListModelFromJson(response.body);
        } else {
          thisResponse.message = result['message'];
        }
      } else {
        thisResponse.message = response.body;
      }

      return thisResponse;
    } catch (e) {
      thisResponse.message = "Network Error!";
      return thisResponse;
    }
  }
}
