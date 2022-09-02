// To parse this JSON data, do
//
//     final changeRoomStatusModel = changeRoomStatusModelFromJson(jsonString);

import 'dart:convert';

ChangeRoomStatusModel changeRoomStatusModelFromJson(String str) => ChangeRoomStatusModel.fromJson(json.decode(str));

String changeRoomStatusModelToJson(ChangeRoomStatusModel data) => json.encode(data.toJson());

class ChangeRoomStatusModel {
  ChangeRoomStatusModel({
    this.status,
    this.roomStatus,
  });

  bool status;
  String roomStatus;

  factory ChangeRoomStatusModel.fromJson(Map<String, dynamic> json) => ChangeRoomStatusModel(
    status: json["status"],
    roomStatus: json["room_status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "room_status": roomStatus,
  };
}
