import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/candidates/fetch_candidate.dart';
import 'package:remark_app/model/candidates/saved_candidates_model.dart';

class FetchCandidate {
  Future<FetchCandidateModel> fetchCandidate(jobID, userName) async {
    var client = http.Client();
    FetchCandidateModel thisResponse;

    try {
      final response = await client.get(Uri.parse(fetchCandidateApiUrl +
          "?job_id=" +
          jobID +
          "&user_name=" +
          userName));

      if (response.statusCode == 200) {
        thisResponse = fetchCandidateModelFromJson(response.body);
        return thisResponse;
      }
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }

    return thisResponse;
  }

  Future<SavedCandidatesModel> fetchSavedCandidates(employerID) async {
    final client = http.Client();
    SavedCandidatesModel thisResponse = SavedCandidatesModel();

    try {
      final response = await client.get(
          Uri.parse(fetchSavedCandidatesApiUrl + "?employer_id=" + employerID));

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status']) {
          thisResponse = savedCandidatesModelFromJson(response.body);
        } else {
          thisResponse = SavedCandidatesModel(status: false);
        }

        return thisResponse;
      } else {
        print(response.statusCode);
        thisResponse = SavedCandidatesModel(status: false);
      }
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }

    return thisResponse;
  }
}
