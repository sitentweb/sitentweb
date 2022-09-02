import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/company/get_employer_companies_model.dart';

class EmployerCompany{

    Future<EmployerCompanyModel> fetchEmployerCompanies(String employerID) async {
      EmployerCompanyModel thisResponse;
      final client = http.Client();

      try{

        final response = await client.post(Uri.parse(employerCompanyApiUrl) , body: {
          "employer_id" : employerID
        });
        
        if(response.statusCode == 200){

          if(jsonDecode(response.body)['status']){

            thisResponse = employerCompanyModelFromJson(response.body);

          }else{
            thisResponse = EmployerCompanyModel(
              status: false,
              data: []
            );
          }

          print(thisResponse.data.toList());
          return thisResponse;

        }else{
          print(response.statusCode);
        }

      }catch(e){
        print(e);
      }finally{
        client.close();
      }

      return thisResponse;
    }

}