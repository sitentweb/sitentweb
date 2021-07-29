// To parse this JSON data, do
//
//     final locationSearchModel = locationSearchModelFromJson(jsonString);

import 'dart:convert';

List<LocationSearchModel> locationSearchModelFromJson(String str) => List<LocationSearchModel>.from(json.decode(str).map((x) => LocationSearchModel.fromJson(x)));

String locationSearchModelToJson(List<LocationSearchModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LocationSearchModel {
  LocationSearchModel({
    this.placeId,
    this.licence,
    this.osmType,
    this.osmId,
    this.boundingbox,
    this.lat,
    this.lon,
    this.displayName,
    this.placeRank,
    this.category,
    this.type,
    this.importance,
    this.icon,
    this.address,
    this.namedetails,
  });

  int placeId;
  String licence;
  String osmType;
  int osmId;
  List<String> boundingbox;
  String lat;
  String lon;
  String displayName;
  int placeRank;
  String category;
  String type;
  double importance;
  String icon;
  Address address;
  Namedetails namedetails;

  factory LocationSearchModel.fromJson(Map<String, dynamic> json) => LocationSearchModel(
    placeId: json["place_id"],
    licence: json["licence"],
    osmType: json["osm_type"],
    osmId: json["osm_id"],
    boundingbox: List<String>.from(json["boundingbox"].map((x) => x)),
    lat: json["lat"],
    lon: json["lon"],
    displayName: json["display_name"],
    placeRank: json["place_rank"],
    category: json["category"],
    type: json["type"],
    importance: json["importance"].toDouble(),
    icon: json["icon"] == null ? null : json["icon"],
    address: Address.fromJson(json["address"]),
    namedetails: Namedetails.fromJson(json["namedetails"]),
  );

  Map<String, dynamic> toJson() => {
    "place_id": placeId,
    "licence": licence,
    "osm_type": osmType,
    "osm_id": osmId,
    "boundingbox": List<dynamic>.from(boundingbox.map((x) => x)),
    "lat": lat,
    "lon": lon,
    "display_name": displayName,
    "place_rank": placeRank,
    "category": category,
    "type": type,
    "importance": importance,
    "icon": icon == null ? null : icon,
    "address": address.toJson(),
    "namedetails": namedetails.toJson(),
  };
}

class Address {
  Address({
    this.city,
    this.county,
    this.stateDistrict,
    this.state,
    this.postcode,
    this.country,
    this.countryCode,
  });

  String city;
  String county;
  String stateDistrict;
  String state;
  String postcode;
  String country;
  String countryCode;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    city: json["city"] == null ? null : json["city"],
    county: json["county"] == null ? null : json["county"],
    stateDistrict: json["state_district"],
    state: json["state"],
    postcode: json["postcode"] == null ? null : json["postcode"],
    country: json["country"],
    countryCode: json["country_code"],
  );

  Map<String, dynamic> toJson() => {
    "city": city == null ? null : city,
    "county": county == null ? null : county,
    "state_district": stateDistrict,
    "state": state,
    "postcode": postcode == null ? null : postcode,
    "country": country,
    "country_code": countryCode,
  };
}

class Namedetails {
  Namedetails({
    this.name,
    this.nameAr,
    this.nameEn,
    this.nameGu,
    this.nameHe,
    this.nameHi,
    this.nameJa,
    this.nameKn,
    this.nameMl,
    this.nameMr,
    this.nameMs,
    this.namePa,
    this.nameRu,
    this.nameUk,
    this.nameZh,
    this.altName,
    this.nameTa,
  });

  String name;
  String nameAr;
  String nameEn;
  String nameGu;
  String nameHe;
  String nameHi;
  String nameJa;
  String nameKn;
  String nameMl;
  String nameMr;
  String nameMs;
  String namePa;
  String nameRu;
  String nameUk;
  String nameZh;
  String altName;
  String nameTa;

  factory Namedetails.fromJson(Map<String, dynamic> json) => Namedetails(
    name: json["name"],
    nameAr: json["name:ar"],
    nameEn: json["name:en"],
    nameGu: json["name:gu"] == null ? null : json["name:gu"],
    nameHe: json["name:he"] == null ? null : json["name:he"],
    nameHi: json["name:hi"],
    nameJa: json["name:ja"],
    nameKn: json["name:kn"] == null ? null : json["name:kn"],
    nameMl: json["name:ml"] == null ? null : json["name:ml"],
    nameMr: json["name:mr"] == null ? null : json["name:mr"],
    nameMs: json["name:ms"] == null ? null : json["name:ms"],
    namePa: json["name:pa"],
    nameRu: json["name:ru"] == null ? null : json["name:ru"],
    nameUk: json["name:uk"] == null ? null : json["name:uk"],
    nameZh: json["name:zh"] == null ? null : json["name:zh"],
    altName: json["alt_name"],
    nameTa: json["name:ta"] == null ? null : json["name:ta"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "name:ar": nameAr,
    "name:en": nameEn,
    "name:gu": nameGu == null ? null : nameGu,
    "name:he": nameHe == null ? null : nameHe,
    "name:hi": nameHi,
    "name:ja": nameJa,
    "name:kn": nameKn == null ? null : nameKn,
    "name:ml": nameMl == null ? null : nameMl,
    "name:mr": nameMr == null ? null : nameMr,
    "name:ms": nameMs == null ? null : nameMs,
    "name:pa": namePa,
    "name:ru": nameRu == null ? null : nameRu,
    "name:uk": nameUk == null ? null : nameUk,
    "name:zh": nameZh == null ? null : nameZh,
    "alt_name": altName,
    "name:ta": nameTa == null ? null : nameTa,
  };
}
