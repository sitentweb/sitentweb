// To parse this JSON data, do
//
//     final cityStateModel = cityStateModelFromJson(jsonString);

import 'dart:convert';

CityStateModel cityStateModelFromJson(String str) => CityStateModel.fromJson(json.decode(str));

String cityStateModelToJson(CityStateModel data) => json.encode(data.toJson());

class CityStateModel {
  CityStateModel({
    this.status,
    this.data,
  });

  bool status;
  List<Datum> data;

  factory CityStateModel.fromJson(Map<String, dynamic> json) => CityStateModel(
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
    this.place,
    this.city,
    this.state,
  });

  String place;
  String city;
  State state;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    place: json["place"],
    city: json["city"],
    state: stateValues.map[json["state"]],
  );

  Map<String, dynamic> toJson() => {
    "place": place,
    "city": city,
    "state": stateValues.reverse[state],
  };
}

enum State { WEST_BENGAL, ASSAM, TAMIL_NADU, PUNJAB, GUJARAT, RAJASTHAN, JAMMU_AND_KASHMIR, MAHARASHTRA, TELANGANA, UTTAR_PRADESH, ANDHRA_PRADESH, KERALA, KARNATAKA, JHARKHAND, MADHYA_PRADESH, TRIPURA, LAKSHADWEEP, CHHATTISGARH, MIZORAM, GOA, UTTARAKHAND, ARUNACHAL_PRADESH, BIHAR, HARYANA, DADRA_AND_NAGAR_HAVELI, ODISHA, MANIPUR, PONDICHERRY, HIMACHAL_PRADESH, MEGHALAYA, ANDAMAN_AND_NICOBAR_ISLANDS, CHANDIGARH, NAGALAND, DAMAN_AND_DIU, DELHI, SIKKIM }

final stateValues = EnumValues({
  "Andaman and Nicobar Islands": State.ANDAMAN_AND_NICOBAR_ISLANDS,
  "Andhra Pradesh": State.ANDHRA_PRADESH,
  "Arunachal Pradesh": State.ARUNACHAL_PRADESH,
  "Assam": State.ASSAM,
  "Bihar": State.BIHAR,
  "Chandigarh": State.CHANDIGARH,
  "Chhattisgarh": State.CHHATTISGARH,
  "Dadra and Nagar Haveli": State.DADRA_AND_NAGAR_HAVELI,
  "Daman and Diu": State.DAMAN_AND_DIU,
  "Delhi": State.DELHI,
  "Goa": State.GOA,
  "Gujarat": State.GUJARAT,
  "Haryana": State.HARYANA,
  "Himachal Pradesh": State.HIMACHAL_PRADESH,
  "Jammu and Kashmir": State.JAMMU_AND_KASHMIR,
  "Jharkhand": State.JHARKHAND,
  "Karnataka": State.KARNATAKA,
  "Kerala": State.KERALA,
  "Lakshadweep": State.LAKSHADWEEP,
  "Madhya Pradesh": State.MADHYA_PRADESH,
  "Maharashtra": State.MAHARASHTRA,
  "Manipur": State.MANIPUR,
  "Meghalaya": State.MEGHALAYA,
  "Mizoram": State.MIZORAM,
  "Nagaland": State.NAGALAND,
  "Odisha": State.ODISHA,
  "Pondicherry": State.PONDICHERRY,
  "Punjab": State.PUNJAB,
  "Rajasthan": State.RAJASTHAN,
  "Sikkim": State.SIKKIM,
  "Tamil Nadu": State.TAMIL_NADU,
  "Telangana": State.TELANGANA,
  "Tripura": State.TRIPURA,
  "Uttarakhand": State.UTTARAKHAND,
  "Uttar Pradesh": State.UTTAR_PRADESH,
  "West Bengal": State.WEST_BENGAL
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
