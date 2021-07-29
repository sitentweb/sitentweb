// To parse this JSON data, do
//
//     final notificationListModel = notificationListModelFromJson(jsonString);

import 'dart:convert';

NotificationListModel notificationListModelFromJson(String str) => NotificationListModel.fromJson(json.decode(str));

String notificationListModelToJson(NotificationListModel data) => json.encode(data.toJson());

class NotificationListModel {
  NotificationListModel({
    this.status,
    this.data,
  });

  bool status;
  List<Datum> data;

  factory NotificationListModel.fromJson(Map<String, dynamic> json) => NotificationListModel(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.notificationId,
    this.notificationUserId,
    this.notificationReceiverId,
    this.notificationJobId,
    this.notificationTitle,
    this.notificationSubTitle,
    this.notificationIcon,
    this.notificationType,
    this.notificationCreatedAt,
  });

  String notificationId;
  String notificationUserId;
  String notificationReceiverId;
  String notificationJobId;
  String notificationTitle;
  String notificationSubTitle;
  String notificationIcon;
  String notificationType;
  DateTime notificationCreatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    notificationId: json["notification_id"],
    notificationUserId: json["notification_user_id"],
    notificationReceiverId: json["notification_receiver_id"],
    notificationJobId: json["notification_job_id"],
    notificationTitle: json["notification_title"],
    notificationSubTitle: json["notification_sub_title"],
    notificationIcon: json["notification_icon"],
    notificationType: json["notification_type"],
    notificationCreatedAt: DateTime.parse(json["notification_created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "notification_id": notificationId,
    "notification_user_id": notificationUserId,
    "notification_receiver_id": notificationReceiverId,
    "notification_job_id": notificationJobId,
    "notification_title": notificationTitle,
    "notification_sub_title": notificationSubTitle,
    "notification_icon": notificationIcon,
    "notification_type": notificationType,
    "notification_created_at": notificationCreatedAt.toIso8601String(),
  };
}
