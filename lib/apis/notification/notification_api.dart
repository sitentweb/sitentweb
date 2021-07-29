import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/global/global_status_model.dart';
import 'package:remark_app/model/notification_list_model.dart';

class NotificationApi {
  final client = http.Client();

  Future<NotificationListModel> receiveNotification(userID) async {
    NotificationListModel thisResponse = NotificationListModel();

    try {
      final response = await client
          .get(Uri.parse(receiveNotificationApiUrl + "?user_id=" + userID));

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'] == false) {
          thisResponse.status = false;

          return thisResponse;
        } else {
          thisResponse = notificationListModelFromJson(response.body);

          return thisResponse;
        }
      } else {
        print("Wrong Status Code ${response.statusCode}");
      }
    } catch (e) {
      print("Exception in receiving notification");
      print(e);
    } finally {
      client.close();
    }

    return thisResponse;
  }

  Future<GlobalStatusModel> updateNotification(notificationID) async {
    GlobalStatusModel thisResponse = GlobalStatusModel();

    try {
      final response = await client.post(Uri.parse(updateNotificationApiUrl),
          body: {"notification_id": notificationID});

      if (response.statusCode == 200) {
        thisResponse = globalStatusModelFromJson(response.body);
        print(thisResponse);

        return thisResponse;
      } else {
        print(
            "Wrong Status code in update notification : ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }

    return thisResponse;
  }
}
