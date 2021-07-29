import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/location/city_state_model.dart';
import 'package:remark_app/model/location/location.dart';

class Location {

  final client = http.Client();

  Future<List<LocationSearchModel>> fetchSearchedLocation(search) async {

    List<LocationSearchModel> thisResponse;


      try{

        final response = await client.get(Uri.parse("https://nominatim.openstreetmap.org/search/"+search+"?format=jsonv2&addressdetails=1&countrycodes=in&namedetails=1"));

        if(response.statusCode == 200){

          thisResponse = locationSearchModelFromJson(response.body);

          return thisResponse;

        }else{
          print("Wrong Status code in location search : ${response.statusCode}");
        }

      }catch(e){
        print("Exception is search location");
        print(e);
      }finally{
        client.close();
      }

      return thisResponse;

  }

  Future<CityStateModel> cityState() async {
    CityStateModel thisResponse = CityStateModel();

    try{

      final response = await client.get(Uri.parse(fetchCityStateApiUrl));

      if(response.statusCode == 200){

        if(jsonDecode(response.body)['status']){

          thisResponse = cityStateModelFromJson(response.body);

        }else{
          thisResponse = CityStateModel(
            status: false,
            data: <Datum>[]
          );
        }

        return thisResponse;

      }else{
        print(" Wrong Exception in City State : ${response.statusCode}");
      }

    }catch(e){
      print("Excepiton in city state api");
      print(e);
    }finally{
      client.close();
    }

    return thisResponse;

  }

}