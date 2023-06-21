import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/candidates/fetch_hired_candidates.dart';

class HiredCandidatesApi {
  final client = http.Client();

  Future<FetchHiredCandidatesModel> fetchHiredCandidates(employerID) async {
    print("Trying to get employerID $employerID");

    FetchHiredCandidatesModel thisResponse =
        FetchHiredCandidatesModel(status: false);

    try {
      final response = await client
          .get(Uri.parse(hiredCandidatesApiUrl + "?employer_id=" + employerID));
      print(response.body);
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status']) {
          thisResponse = fetchHiredCandidatesModelFromJson(response.body);
        } else {
          thisResponse = FetchHiredCandidatesModel(status: false, data: []);
        }

        return thisResponse;
      } else {
        print("Wrong Status Code : ${response.statusCode}");
        thisResponse.status = false;
        thisResponse.data = [];
      }

      return thisResponse;
    } catch (e) {
      print("Exception in fetching hired candidates");
      print(e);
      thisResponse.status = false;
      thisResponse.data = [];
      return thisResponse;
    } finally {
      client.close();
    }

    return thisResponse;
  }
}
