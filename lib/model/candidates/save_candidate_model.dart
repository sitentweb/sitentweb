// To parse this JSON data, do
//
//     final saveCandidateModel = saveCandidateModelFromJson(jsonString);

import 'dart:convert';

SaveCandidateModel saveCandidateModelFromJson(String str) =>
    SaveCandidateModel.fromJson(json.decode(str));

String saveCandidateModelToJson(SaveCandidateModel data) =>
    json.encode(data.toJson());

class SaveCandidateModel {
  SaveCandidateModel({
    this.status,
    this.saved,
  });

  bool status;
  String saved;

  factory SaveCandidateModel.fromJson(Map<String, dynamic> json) =>
      SaveCandidateModel(
        status: json["status"],
        saved: json["saved"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "saved": saved,
      };
}
