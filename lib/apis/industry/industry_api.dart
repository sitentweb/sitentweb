import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/industry/fetch_industry_model.dart';

class IndustryApi {

  final client = http.Client();

  Future<FetchIndustryModel> fetchIndustries() async {
    FetchIndustryModel thisResponse = FetchIndustryModel();

    try{

      final response = await client.get(Uri.parse(fetchIndustryApiUrl));

      if(response.statusCode == 200){

          thisResponse = fetchIndustryModelFromJson(response.body);

          return thisResponse;

      }else{
        print(response.statusCode);
      }

    }catch(e){

      print("Exception in fetching industry");
      print(e);
    }finally{
      client.close();
    }

    return thisResponse;

  }

}