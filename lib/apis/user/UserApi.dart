import 'dart:convert';
import 'dart:developer';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/auth/userDataModel.dart';
import 'package:remark_app/model/global/global_model.dart';
import 'package:remark_app/model/global/global_status_model.dart';
import 'package:remark_app/model/user/fetch_user_data.dart';
import 'package:remark_app/model/user/update_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserApi {
  final storage = GetStorage();

  Future<UserDataModel> getUserByMobileNumber(
      String mobileNumber, String userToken) async {
    var client = http.Client();
    UserDataModel thisResponse;

    try {
      final response = await client.post(Uri.parse(getUserByMobileNumberApiUrl),
          body: {"user_mobile": mobileNumber, "user_token": userToken});

      if (response.statusCode == 200) {
        thisResponse = userDataModelFromJson(response.body);

        if (thisResponse.status) {
          return thisResponse;
        } else {
          thisResponse = UserDataModel(status: false, data: null);
        }
      } else {
        print('wrong status code');
      }
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
  }

  Future updateUser(String userID) async {
    var client = http.Client();

    UpdateUserModel thisResponse;

    try {
      final response = await client
          .post(Uri.parse(removeUserTokenApiUrl), body: {'user_id': userID});

      if (response.statusCode == 200) {
        thisResponse = updateUserModelFromJson(response.body);

        return thisResponse;
      }
    } catch (e) {
      print("Exception in update user");
      print(e);
    } finally {
      client.close();
    }

    return thisResponse;
  }

  Future<FetchUserDataModel> fetchUserData(String userID) async {
    final client = http.Client();
    FetchUserDataModel thisResponse;

    try {
      final response = await client
          .get(Uri.parse(fetchUserDataApiUrl + '?userID=' + userID));

      if (response.statusCode == 200) {
        thisResponse = fetchUserDataModelFromJson(response.body);
      } else {
        print(
            "Wrong status code in Fetching user data : ${response.statusCode} ");
      }
    } catch (e) {
      print("Exception in fetching user data");
      print(e);
    } finally {
      client.close();
    }

    return thisResponse;
  }

  Future<GlobalModel> startVerifyMobileNumber(String userMobile) async {
    GlobalModel thisResponse = GlobalModel(status: false, message: '');

    try {
      final response = await http
          .post(Uri.parse(apiUrl['start-verify-mobile-number']), body: {
        "mobile_number": userMobile,
      }, headers: {
        "Authorization": storage.read('jwtToken')
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status']) {
          thisResponse = globalModelFromJson(response.body);
        } else {
          thisResponse =
              GlobalModel(status: false, message: data['message'], data: null);
        }
      } else {
        thisResponse.message = 'Invalid Response : ${response.statusCode}';
      }

      return thisResponse;
    } catch (e) {
      print(e);
      thisResponse.message = 'Something went wrong';
      return thisResponse;
    }
  }

  Future<GlobalModel> updateVerifiedMobileNumber(String userMobile) async {
    GlobalModel thisResponse = GlobalModel(status: false, message: '');

    try {
      final response = await http
          .post(Uri.parse(apiUrl['update-verified-mobile-number']), body: {
        "mobile_number": userMobile,
      }, headers: {
        "Authorization": storage.read('jwtToken')
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status']) {
          thisResponse = globalModelFromJson(response.body);
        } else {
          thisResponse =
              GlobalModel(status: false, message: data['message'], data: null);
        }
      } else {
        thisResponse.message = 'Invalid Response : ${response.statusCode}';
      }

      return thisResponse;
    } catch (e) {
      print(e);
      thisResponse.message = 'Something went wrong';
      return thisResponse;
    }
  }

  Future<GlobalStatusModel> updateUserDetails(String userID, String userData,
      String userPhoto, String resumePath) async {
    GlobalStatusModel thisResponse = GlobalStatusModel(status: false);

    try {
      final responses =
          http.MultipartRequest("POST", Uri.parse(updateUserDetailsApiUrl));
      responses.fields['user_data'] = userData;
      responses.fields['user_id'] = userID;

      if (userPhoto != "") {
        responses.files
            .add(await http.MultipartFile.fromPath('user_photo', userPhoto));
      }

      if (resumePath != "") {
        responses.files
            .add(await http.MultipartFile.fromPath('user_resume', resumePath));
      }

      await responses.send().then((streamResponse) async {
        if (streamResponse.statusCode == 200) {
          await http.Response.fromStream(streamResponse).then((response) {
            var result = jsonDecode(response.body);
            if (result['status']) {
              thisResponse = globalStatusModelFromJson(response.body);
            } else {
              thisResponse =
                  GlobalStatusModel(status: false, data: result['data']);
            }

            log(response.body);
            return thisResponse;
          });
        } else {
          print("Wrong Status Code : ${streamResponse.statusCode} ");
          thisResponse.data = "Something went wrong";
        }
      });

      return thisResponse;
    } catch (e) {
      print(e);
      thisResponse.data = "Something went wrong";
    }

    return thisResponse;
  }

  static user(String userKey) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.get(userKey) != null) {
      return pref.get(userKey);
    } else {
      return null;
    }
  }

  Future<GlobalStatusModel> deleteUser(String userID) async {
    GlobalStatusModel thisResponse = GlobalStatusModel(status: false);

    try {
      final response = await http
          .post(Uri.parse(deleteUserApiUrl), body: {"user_id": userID});

      if (response.statusCode == 200) {
        thisResponse = globalStatusModelFromJson(response.body);
      } else {
        thisResponse.data = "Invalid Response";
      }

      return thisResponse;
    } catch (e) {
      thisResponse.data = "Something went wrong";
      return thisResponse;
    }
  }
}
