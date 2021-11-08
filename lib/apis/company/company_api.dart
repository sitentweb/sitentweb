import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/company/fetch_company_model.dart';
import 'package:remark_app/model/company/fetch_user_company_model.dart';
import 'package:remark_app/model/global/global_status_model.dart';

class CompanyApi {

  final client = http.Client();

  Future<FetchCompanyModel> fetchCompanyByID(companyID) async {
    FetchCompanyModel thisResponse = FetchCompanyModel();

    try{

      final response = await client.get(Uri.parse(getCompanyByIDApiUrl + "?company_id="+companyID));

      if(response.statusCode == 200){

        if(jsonDecode(response.body)['status']){

          thisResponse = fetchCompanyModelFromJson(response.body);

        }else{
            thisResponse = FetchCompanyModel(
              status: false,
              data: Data()
            );
        }

        return thisResponse;

      }else{
        print("Wrong Status Code : ${response.statusCode}");
      }

    }catch(e){
      print(e);
    }finally{
      client.close();
    }

    return thisResponse;

  }

  Future<FetchUsersCompaniesModel> fetchUserCompanies(userID) async {
    FetchUsersCompaniesModel thisResponse = FetchUsersCompaniesModel();

    try{

      final response = await client.get(Uri.parse(fetchUserCompaniesApiUrl + "?user_id="+userID));

      if(response.statusCode == 200){

        if(jsonDecode(response.body)['status']){
          thisResponse = fetchUsersCompaniesModelFromJson(response.body);

        }else{
          thisResponse = FetchUsersCompaniesModel(
            status: false,
            data: []
          );
        }

        return thisResponse;

      }else{
        print("Wrong Status Code");
      }

    }catch(e){
      print(e);
    }finally{
      client.close();
    }

    return thisResponse;

  }

  Future<GlobalStatusModel> createCompany(logo, companyData , userID) async {
    GlobalStatusModel thisResponse = GlobalStatusModel();

    try{

      final responses = http.MultipartRequest("POST" , Uri.parse(createCompanyApiUrl));
      responses.fields['company_data'] = companyData;
      responses.fields['user_id'] = userID;
      responses.files.add(await http.MultipartFile.fromPath('company_logo', logo));

      await responses.send().then((response) async {
          if(response.statusCode == 200){
            await http.Response.fromStream(response).then((res) {
              print(jsonDecode(res.body));
              thisResponse = globalStatusModelFromJson(res.body);
            });
          }else{
            print('Wrong Status Code : ${response.statusCode}');
          }
      });
    }catch(e){
      print(e);
    }

    return thisResponse;

  }

}