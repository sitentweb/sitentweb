import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/global/global_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remark_app/model/jobs/job_list_model.dart';

class PostJobApi {
  final client = http.Client();
  final storage = GetStorage();

  Future<GlobalModel> postJob(jobData) async {
    GlobalModel thisResponse = GlobalModel(status: false);
    log(jobData.toString(), name: "JOB DATA");
    try {
      final response = await client.post(Uri.parse(apiUrl['post-job']),
          body: {"job_data": jobData},
          headers: {"Authorization": storage.read("jwtToken")});

      if (response.statusCode == 200) {
        log(response.body, name: 'JOB POSTING RESPONSE');
        thisResponse = globalModelFromJson(response.body);

        return thisResponse;
      } else {
        thisResponse.message = "Something went wrong";
        return thisResponse;
      }
    } catch (e) {
      print(e);
      thisResponse.message = "Something went wrong";
      return thisResponse;
    } finally {
      client.close();
    }
  }

  Future<GlobalModel> updateJob(jobId, jobData) async {
    GlobalModel thisResponse = GlobalModel(status: false);
    log(jobData.toString(), name: "JOB DATA");
    try {
      final response = await client.post(Uri.parse(apiUrl['update-job']),
          body: {"job_id": jobId, "job_data": jobData},
          headers: {"Authorization": storage.read("jwtToken")});

      if (response.statusCode == 200) {
        thisResponse = globalModelFromJson(response.body);

        return thisResponse;
      } else {
        thisResponse.message = "Something went wrong";
        return thisResponse;
      }
    } catch (e) {
      print(e);
      thisResponse.message = "Something went wrong";
      return thisResponse;
    } finally {
      client.close();
    }
  }

  Future<JobListModel> fetchPostedJobs() async {
    JobListModel thisResponse =
        JobListModel(status: false, showRegister: false, jobs: []);

    try {
      final res = await client.get(Uri.parse(apiUrl['fetch-posted-jobs']),
          headers: {"Authorization": storage.read('jwtToken')});

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['status']) {
          thisResponse = jobListModelFromJson(res.body);
        } else {
          thisResponse.message = data['message'];
        }
        return thisResponse;
      } else {
        thisResponse.message = "Invalid Response: ${res.statusCode}";
      }

      return thisResponse;
    } catch (e) {
      print(e.toString());
      thisResponse.message = "Something went wrong";
      return thisResponse;
    }
  }
}
