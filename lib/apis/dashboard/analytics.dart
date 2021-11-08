import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/dashboard/dashboard_data_model.dart';

class AnalyticsData {

  Future<DashboardDataModel> fetchChartData(String userID) async {
      var client = http.Client();
      DashboardDataModel thisResponse;

      try{

        final response = await client.post(Uri.parse(getDashboardDataApiUrl) , body: {
          'user_id' : userID
        });

        if(response.statusCode == 200){

          thisResponse = dashboardDataModelFromJson(response.body);

          if(thisResponse.status){
            return thisResponse;
          }else{
            print('data not found');
          }

        }else{
          print('Wrong status code');
        }

      }catch(e){
        print("Exception in dashboard");
        print(Uri.parse(getDashboardDataApiUrl));
        print(e);
      }finally{
        client.close();
      }
  }

}