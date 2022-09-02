import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/global/global_status_model.dart';
import 'package:remark_app/model/response/interview/get_all_interviews_model.dart';

class GetAllInterviewsApi {
  Future<GetAllInterviewModel> getAllInterviews(userID, userType) async {
    var client = http.Client();

    GetAllInterviewModel thisResponse;

    try {
      final response = await client.get(Uri.parse(getAllScheduleInterview +
          "?user_id=" +
          userID +
          "&user_type=" +
          userType));

      if (response.statusCode == 200) {
        thisResponse = getAllInterviewModelFromJson(response.body);

        return thisResponse;
      }
    } catch (e) {
      print("Exception in GetAllInterviewModel");
      print(e);
    } finally {
      client.close();
    }

    return thisResponse;
  }

  // SEND EMPLOYEE SESSION TO DATABASE

  Future sendInterviewSession(interviewID, sessionData, userType) async {
    final client = http.Client();

    try {
      final response = await client
          .post(Uri.parse(base_url + '/sendInterviewSession'), body: {
        "interview_id": interviewID,
        "session_data": sessionData,
        "user_type": userType
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Wrong status code when sending employee data");
      }
    } catch (e) {
      print("Exception while sending employee session data");
      print(e);
    } finally {
      client.close();
    }
  }

  Future getInterviewSession(interviewID) async {
    final client = http.Client();

    try {
      final response = await client.get(Uri.parse(
          base_url + "/getInterviewSession?interview_id=" + interviewID));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Wrong status code while getting interview session");
        print(response.statusCode);
      }
    } catch (e) {
      print("exception while getting interview session");
      print(e);
    } finally {
      client.close();
    }
  }

  Future<GlobalStatusModel> createInterview(employeeID, employerID,
      interviewTitle, interviewTime, interviewType) async {
    GlobalStatusModel thisResponse = GlobalStatusModel();
    var client = http.Client();

    try {
      final response =
          await client.post(Uri.parse(createInterviewApiUrl), body: {
        "employee_id": employeeID,
        "employer_id": employerID,
        "interview_title": interviewTitle,
        "interview_time": interviewTime,
        "interview_type": interviewType
      });

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status']) {
          thisResponse = globalStatusModelFromJson(response.body);
        } else {
          thisResponse = GlobalStatusModel(status: false, data: false);
        }

        return thisResponse;
      } else {
        print("Wrong Status Code : ${response.statusCode} ");
      }
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }

    return thisResponse;
  }

  Future<GlobalStatusModel> interviewResponse(
      interviewID, interviewStatus) async {
    GlobalStatusModel thisResponse = GlobalStatusModel();

    final client = http.Client();

    try {
      final response = await Dio().get(interviewResponseApiUrl,
          queryParameters: {
            "interview_id": interviewID,
            "interview_update_key": interviewStatus
          });

      if (response.statusCode == 200) {
        if (jsonDecode(response.data)['status']) {
          thisResponse = globalStatusModelFromJson(response.data);
        } else {
          thisResponse = GlobalStatusModel(status: false, data: false);
        }

        return thisResponse;
      } else {
        print("Wrong Status Code : ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }

    return thisResponse;
  }

  Future<GlobalStatusModel> rescheduleInterview(
      interviewID, interviewTime, interviewReason, userID) async {
    GlobalStatusModel thisResponse = GlobalStatusModel(status: false);
    final client = http.Client();

    try {
      final response =
          await client.post(Uri.parse(rescheduleInterviewApiUrl), body: {
        "interview_id": interviewID,
        "interview_time": interviewTime,
        "interview_reason": interviewReason,
        "user_id": userID
      });

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status']) {
          thisResponse = globalStatusModelFromJson(response.body);
        } else {
          thisResponse = GlobalStatusModel(status: false);
        }
      } else {
        print(response.statusCode);
      }

      return thisResponse;
    } catch (e) {
      print("Exception in rescheduling interview");
      print(e);
    } finally {
      client.close();
    }

    return thisResponse;
  }

  Future<GlobalStatusModel> deleteInterview(String interviewID) async {
    GlobalStatusModel thisResponse = GlobalStatusModel(status: false);
    final client = http.Client();

    try {
      final response = await client.post(Uri.parse(deleteInterviewApiUrl),
          body: {"interview_id": interviewID});

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status']) {
          thisResponse = globalStatusModelFromJson(response.body);
        } else {
          thisResponse = GlobalStatusModel(status: false);
        }
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print("Exception in deleting interview");
      print(e);
    } finally {
      client.close();
    }
    return thisResponse;
  }
}
