// To parse this JSON data, do
//
//     final userState = userStateFromJson(jsonString);

import 'dart:convert';

Favorite userStateFromJson(String str) => Favorite.fromJson(json.decode(str));

String userStateToJson(Favorite data) => json.encode(data.toJson());

class Favorite {
  bool status;
  List<FavoriteService> favoriteServices;
  List<FavoriteProperty> favoriteProperties;
  String message;

  Favorite({
    required this.status,
    required this.favoriteServices,
    required this.favoriteProperties,
    required this.message,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
    status: json["status"],
    favoriteServices: json["favorite_services"] != null
        ? List<FavoriteService>.from(json["favorite_services"]["data"].map((x) => FavoriteService.fromJson(x)))
        : [],
    favoriteProperties: json["favorite_properties"] != null
        ? List<FavoriteProperty>.from(json["favorite_properties"]["data"].map((x) => FavoriteProperty.fromJson(x)))
        : [],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "favorite_services": List<dynamic>.from(favoriteServices.map((x) => x.toJson())),
    "favorite_properties": List<dynamic>.from(favoriteProperties.map((x) => x.toJson())),
    "message": message,
  };
}

class FavoriteProperty {
  int id;
  int userId;
  int propertyId;
  int favFlag;
  DateTime createdAt;
  DateTime updatedAt;
  PropertData? property;

  FavoriteProperty({
    required this.id,
    required this.userId,
    required this.propertyId,
    required this.favFlag,
    required this.createdAt,
    required this.updatedAt,
    required this.property,
  });

  factory FavoriteProperty.fromJson(Map<String, dynamic> json) => FavoriteProperty(
    id: json["id"],
    userId: json["user_id"],
    propertyId: json["property_id"],
    favFlag: json["fav_flag"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    property: json["property"] == null ? null : PropertData.fromJson(json["property"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "property_id": propertyId,
    "fav_flag": favFlag,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "property": property,
  };
}

class FavoriteService {
  int id;
  String userId;
  String serviceId;
  String favFlag;
  DateTime createdAt;
  DateTime updatedAt;
  Service? service;

  FavoriteService({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.favFlag,
    required this.createdAt,
    required this.updatedAt,
    required this.service,
  });

  factory FavoriteService.fromJson(Map<String, dynamic> json) => FavoriteService(
    id: json["id"],
    userId: json["user_id"],
    serviceId: json["service_id"],
    favFlag: json["fav_flag"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    service: json["service"] == null ? null : Service.fromJson(json["service"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "service_id": serviceId,
    "fav_flag": favFlag,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "service": service?.toJson(),
  };
}

class Service {
  int id;
  String userId;
  String serviceName;
  String description;
  String categoryId;
  String pricing;
  String durationId;
  String startTime;
  String endTime;
  String location;
  String lat;
  String long;
  String media;
  String additionalInformation;
  DateTime createdAt;
  DateTime updatedAt;
  bool isFavorite;

  Service({
    required this.id,
    required this.userId,
    required this.serviceName,
    required this.description,
    required this.categoryId,
    required this.pricing,
    required this.durationId,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.lat,
    required this.long,
    required this.media,
    required this.additionalInformation,
    required this.createdAt,
    required this.updatedAt,
    required this.isFavorite
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json["id"],
    userId: json["user_id"],
    serviceName: json["service_name"] ?? "",
    description: json["description"] ?? "",
    categoryId: json["category_id"] ?? "",
    pricing: json["pricing"] ?? "",
    durationId: json["duration_id"] ?? "",
    startTime: json["start_time"] ?? "",
    endTime: json["end_time"] ?? "",
    location: json["location"] ?? "",
    lat: json["lat"],
    long: json["long"] ,
    media: json["media"] ?? "",
    additionalInformation: json["additional_information"]?? "",
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    isFavorite: json["is_favorite"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "service_name": serviceName,
    "description": description,
    "category_id": categoryId,
    "pricing": pricing,
    "duration_id": durationId,
    "start_time": startTime,
    "end_time": endTime,
    "location": location,
    "lat": lat,
    "long": long,
    "media": media,
    "additional_information": additionalInformation,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "is_favorite": isFavorite,
  };
}


class PropertData {
  int id;
  int userId;
  int type;
  String? images;
  String city;
  String amount;
  String address;
  String lat;
  String long;
  String areaRange;
  String bedroom;
  String bathroom;
  String? description;
  String? electricityBill;
  int propertyType;
  int propertySubType;
  DateTime createdAt;
  DateTime updatedAt;
  String noOfProperty;
  String availabilityStartTime;
  String availabilityEndTime;

  PropertData({
    required this.id,
    required this.userId,
    required this.type,
    required this.images,
    required this.city,
    required this.amount,
    required this.address,
    required this.lat,
    required this.long,
    required this.areaRange,
    required this.bedroom,
    required this.bathroom,
    required this.description,
    required this.electricityBill,
    required this.propertyType,
    required this.propertySubType,
    required this.createdAt,
    required this.updatedAt,
    required this.noOfProperty,
    required this.availabilityStartTime,
    required this.availabilityEndTime,
  });

  factory PropertData.fromJson(Map<String, dynamic> json) => PropertData(
    id: json["id"],
    userId: json["user_id"],
    type: json["type"],
    images: json["images"],
    city: json["city"],
    amount: json["amount"],
    address: json["address"],
    lat: json["lat"],
    long: json["long"],
    areaRange: json["area_range"],
    bedroom: json["bedroom"],
    bathroom: json["bathroom"],
    description: json["description"],
    electricityBill: json["electricity_bill"],
    propertyType: json["property_type"],
    propertySubType: json["property_sub_type"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    noOfProperty: json["no_of_property"] ?? "",
    availabilityStartTime: json["availability_start_time"] ?? "",
    availabilityEndTime: json["availability_end_time"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "type": type,
    "images": images,
    "city": city,
    "amount": amount,
    "address": address,
    "lat": lat,
    "long": long,
    "area_range": areaRange,
    "bedroom": bedroom,
    "bathroom": bathroom,
    "description": description,
    "electricity_bill": electricityBill,
    "property_type": propertyType,
    "property_sub_type": propertySubType,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "no_of_property": noOfProperty,
    "availability_start_time": availabilityStartTime,
    "availability_end_time": availabilityEndTime,
  };
}
