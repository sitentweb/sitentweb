import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/jobs/all_jobs_model.dart';

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

  Future<AllJobsModel> getSearchJobs(
      userID, title, skills, range, location) async {
    var client = http.Client();
    AllJobsModel thisResponse;

    try {
      final response =
          await client.post(Uri.parse(fetchSearchJobsApiUrl), body: {
        "user_id": userID,
        "search_string": title,
        "search_skills": skills,
        "search_salary_range": range,
        "search_location": location
      });

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'] == true) {
          thisResponse = allJobsModelFromJson(response.body);

          return thisResponse;
        } else {
          print(jsonDecode(response.body));
          thisResponse = AllJobsModel(status: false, data: Data(jobList: []));
          return thisResponse;
        }
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }

    return thisResponse;
  }
}
