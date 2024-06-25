// To parse this JSON data, do
//
//     final getServices = getServicesFromJson(jsonString);

import 'dart:convert';

GetServices getServicesFromJson(String str) => GetServices.fromJson(json.decode(str));

String getServicesToJson(GetServices data) => json.encode(data.toJson());

class GetServices {
  bool status;
  String message;
  List<Services> data;

  GetServices({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetServices.fromJson(Map<String, dynamic> json) => GetServices(
    status: json["status"],
    message: json["message"],
    data: List<Services>.from(json["data"].map((x) => Services.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Services {
  int id;
  int userId;
  String serviceName;
  String description;
  String pricing;
  String startTime;
  String endTime;
  String location;
  String lat;
  String long;
  String media;
  String? additionalInformation;
  DateTime createdAt;
  DateTime updatedAt;

  Services({
    required this.id,
    required this.userId,
    required this.serviceName,
    required this.description,
    required this.pricing,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.lat,
    required this.long,
    required this.media,
    required this.additionalInformation,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Services.fromJson(Map<String, dynamic> json) => Services(
    id: json["id"],
    userId: json["user_id"],
    serviceName: json["service_name"],
    description: json["description"],
    pricing: json["pricing"],

    startTime: json["start_time"],
    endTime: json["end_time"],
    location: json["location"],
    lat: json["lat"],
    long: json["long"],
    media: json["media"],
    additionalInformation: json["additional_information"] ?? "",
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "service_name": serviceName,
    "description": description,
    "pricing": pricing,
    "start_time": startTime,
    "end_time": endTime,
    "location": location,
    "lat": lat,
    "long": long,
    "media": media,
    "additional_information": additionalInformation,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
