import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/company/fetch_company_model.dart';
import 'package:remark_app/model/company/fetch_user_company_model.dart';
import 'package:remark_app/model/global/global_status_model.dart';
import 'package:remark_app/model/company/company_list_model.dart';

class CompanyApi {
  final client = http.Client();

  Future<FetchCompanyModel> fetchCompanyByID(companyID) async {
    FetchCompanyModel thisResponse = FetchCompanyModel();

    try {
      final response = await client
          .get(Uri.parse(getCompanyByIDApiUrl + "?company_id=" + companyID));

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status']) {
          thisResponse = fetchCompanyModelFromJson(response.body);
        } else {
          thisResponse = FetchCompanyModel(status: false, data: Data());
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

  Future<FetchUsersCompaniesModel> fetchUserCompanies(userID) async {
    FetchUsersCompaniesModel thisResponse = FetchUsersCompaniesModel();

    try {
      final response = await client
          .get(Uri.parse(fetchUserCompaniesApiUrl + "?user_id=" + userID));

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status']) {
          thisResponse = fetchUsersCompaniesModelFromJson(response.body);
        } else {
          thisResponse = FetchUsersCompaniesModel(status: false, data: []);
        }

        return thisResponse;
      } else {
        print("Wrong Status Code");
      }
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }

    return thisResponse;
  }

  Future<GlobalStatusModel> createCompany(
      String logo, companyData, userID) async {
    GlobalStatusModel thisResponse = GlobalStatusModel();

    try {
      final responses =
          http.MultipartRequest("POST", Uri.parse(createCompanyApiUrl));
      responses.fields['company_data'] = companyData;
      responses.fields['user_id'] = userID;

      if (logo != "") {
        responses.files
            .add(await http.MultipartFile.fromPath('company_logo', logo));
      }

      await responses.send().then((response) async {
        if (response.statusCode == 200) {
          await http.Response.fromStream(response).then((res) {
            print(jsonDecode(res.body));
            thisResponse = globalStatusModelFromJson(res.body);
          });
        } else {
          print('Wrong Status Code : ${response.statusCode}');
        }
      });
    } catch (e) {
      print(e);
    }

    return thisResponse;
  }

  Future<GlobalStatusModel> deleteCompany(userId, companyId) async {
    GlobalStatusModel thisResponse = GlobalStatusModel(status: false);

    try {
      final response = await client.post(Uri.parse(deleteCompanyApiUrl));

      if (response.statusCode == 200) {
        thisResponse = globalStatusModelFromJson(response.body);
      } else {
        thisResponse.data = "Invalid Response";
      }

      return thisResponse;
    } catch (e) {
      thisResponse.data = e.toString();

      return thisResponse;
    }
  }

  Future<CompanyListsModel> fetchCompaniesList() async {
    CompanyListsModel thisResponse = CompanyListsModel(status: false);

    try {
      final response = await client.get(Uri.parse("${fetchCompanyListApiUrl}"));

      if (response.statusCode == 200) {
        thisResponse = companyListsModelFromJson(response.body);
      } else {
        thisResponse.message = "Response Error";
      }

      return thisResponse;
    } catch (e) {
      print(e.toString());
      thisResponse.message = 'Something went wrong';
      return thisResponse;
    }
  }
}
