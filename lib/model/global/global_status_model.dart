// To parse this JSON data, do
//
//     final globalStatusModel = globalStatusModelFromJson(jsonString);

import 'dart:convert';

GlobalStatusModel globalStatusModelFromJson(String str) => GlobalStatusModel.fromJson(json.decode(str));

String globalStatusModelToJson(GlobalStatusModel data) => json.encode(data.toJson());

class GlobalStatusModel {
    GlobalStatusModel({
        this.status,
        this.data,
    });

    bool status;
    dynamic data;

    factory GlobalStatusModel.fromJson(Map<String, dynamic> json) => GlobalStatusModel(
        status: json["status"],
        data: json["data"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data,
    };
}
