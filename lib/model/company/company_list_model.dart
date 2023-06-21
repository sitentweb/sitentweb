// To parse this JSON data, do
//
//     final companyListsModel = companyListsModelFromJson(jsonString);

import 'dart:convert';

CompanyListsModel companyListsModelFromJson(String str) =>
    CompanyListsModel.fromJson(json.decode(str));

String companyListsModelToJson(CompanyListsModel data) =>
    json.encode(data.toJson());

class CompanyListsModel {
  bool status;
  String message;
  List<Datum> data;

  CompanyListsModel({
    this.status,
    this.message,
    this.data,
  });

  factory CompanyListsModel.fromJson(Map<String, dynamic> json) =>
      CompanyListsModel(
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String companyId;
  String userId;
  String companyLogo;
  String companyName;
  String companySlug;
  String companyEmail;
  String companyWebsite;
  String companyAddress;
  String companyDes;
  String verifiedCompany;
  String companyStatus;
  DateTime createdOn;

  Datum({
    this.companyId,
    this.userId,
    this.companyLogo,
    this.companyName,
    this.companySlug,
    this.companyEmail,
    this.companyWebsite,
    this.companyAddress,
    this.companyDes,
    this.verifiedCompany,
    this.companyStatus,
    this.createdOn,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        companyId: json["company_id"],
        userId: json["user_id"],
        companyLogo: json["company_logo"],
        companyName: json["company_name"],
        companySlug: json["company_slug"],
        companyEmail: json["company_email"],
        companyWebsite: json["company_website"],
        companyAddress: json["company_address"],
        companyDes: json["company_des"],
        verifiedCompany: json["verified_company"],
        companyStatus: json["company_status"],
        createdOn: DateTime.parse(json["created_on"]),
      );

  Map<String, dynamic> toJson() => {
        "company_id": companyId,
        "user_id": userId,
        "company_logo": companyLogo,
        "company_name": companyName,
        "company_slug": companySlug,
        "company_email": companyEmail,
        "company_website": companyWebsite,
        "company_address": companyAddress,
        "company_des": companyDes,
        "verified_company": verifiedCompany,
        "company_status": companyStatus,
        "created_on": createdOn.toIso8601String(),
      };
}
