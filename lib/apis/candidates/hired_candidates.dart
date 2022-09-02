import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/candidates/fetch_hired_candidates.dart';

class HiredCandidatesApi {
  final client = http.Client();

  Future<FetchHiredCandidatesModel> fetchHiredCandidates(employerID) async {
    print("Trying to get employerID $employerID");

    FetchHiredCandidatesModel thisResponse;

    try {
      final response = await client
          .get(Uri.parse(hiredCandidatesApiUrl + "?employer_id=" + employerID));

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status']) {
          thisResponse = fetchHiredCandidatesModelFromJson(response.body);
        } else {
          thisResponse = FetchHiredCandidatesModel(status: false, data: []);
        }
      } else {
        print("Wrong Status Code : ${response.statusCode}");
      }
    } catch (e) {
      print("Exception in fetching hired candidates");
      print(e);
    } finally {
      client.close();
    }

    return thisResponse;
  }
}
