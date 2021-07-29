import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/education/fetch_education.dart';

class EducationApi {

  final client = http.Client();

  Future<FetchEducationModel> fetchEducation() async {

    FetchEducationModel thisResponse = FetchEducationModel();

    try {

      final response = await client.get(Uri.parse(getEducationApiUrl));

      if(response.statusCode == 200) {

        thisResponse = fetchEducationModelFromJson(response.body);

        return thisResponse;

      }else{
        print("Wrong status code : ${response.statusCode}");
      }

    }catch(e) {
      print('Exception in fetching education');
      print(e);
    }finally{
      client.close();
    }

    return thisResponse;

  }

}