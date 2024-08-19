// To parse this JSON data, do
//
//     final calendarService = calendarServiceFromJson(jsonString);

import 'dart:convert';

CalendarService calendarServiceFromJson(String str) =>
CalendarService.fromJson(json.decode(str));

String calendarServiceToJson(CalendarService data) => json.encode(data.toJson());

class CalendarService {
  bool status;
  List<CalendarData> data;
  String message;

  CalendarService({
    required this.status,
    required this.data,
    required this.message,
  });

  factory CalendarService.fromJson(Map<String, dynamic> json) => CalendarService(
    status: json["status"],
    data: List<CalendarData>.from(json["data"].map((x) => CalendarData.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class CalendarData {
  int id;
  int userId;
  int requestId;
  int providerId;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  Request request;
  Provider provider;

  CalendarData({
    required this.id,
    required this.userId,
    required this.requestId,
    required this.providerId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.request,
    required this.provider,
  });

  factory CalendarData.fromJson(Map<String, dynamic> json) => CalendarData(
    id: json["id"],
    userId: json["user_id"],
    requestId: json["request_id"] ?? "",
    providerId: json["provider_id"] ?? "",
    status: json["status"] ?? "",
    createdAt: DateTime.parse(json["created_at"] ?? ""),
    updatedAt: DateTime.parse(json["updated_at"] ?? ""),
    request: Request.fromJson(json["request"]),
    provider: Provider.fromJson(json["provider"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "request_id": requestId,
    "provider_id": providerId,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "request": request.toJson(),
    "provider": provider.toJson(),
  };
}

class Provider {
  int id;
  String fullname;
  String email;
  String phoneNumber;
  int roleId;
  String profileimage;
  DateTime createdAt;
  DateTime updatedAt;

  Provider({
    required this.id,
    required this.fullname,
    required this.email,
    required this.phoneNumber,
    required this.roleId,
    required this.profileimage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Provider.fromJson(Map<String, dynamic> json) => Provider(
    id: json["id"],
    fullname: json["fullname"],
    email: json["email"],
    phoneNumber: json["phone_number"] ?? "",
    roleId: json["role_id"],
    profileimage: json["profileimage"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullname": fullname,
    "email": email,
    "phone_number": phoneNumber,
    "role_id": roleId,
    "profileimage": profileimage,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
class Request {
  int id;
  int userId;
  int serviceproviderId;
  int serviceId;
  String address;
  String lat;
  String long;
  int propertyType;
  String price;
  String date;
  String time;
  String description;
  String additionalInfo;
  int approved;
  int decline;
  DateTime createdAt;
  DateTime updatedAt;
  Service? service;

  Request({
    required this.id,
    required this.userId,
    required this.serviceproviderId,
    required this.serviceId,
    required this.address,
    required this.lat,
    required this.long,
    required this.propertyType,
    required this.price,
    required this.date,
    required this.time,
    required this.description,
    required this.additionalInfo,
    required this.approved,
    required this.decline,
    required this.createdAt,
    required this.updatedAt,
    required this.service,
  });

  factory Request.fromJson(Map<String, dynamic> json) => Request(
    id: json["id"],
    userId: json["user_id"],
    serviceproviderId: json["serviceprovider_id"],
    serviceId: json["service_id"],
    address: json["address"],
    lat: json["lat"],
    long: json["long"],
    propertyType: json["property_type"],
    price: json["price"],
    date: json["date"],
    time: json["time"],
    description: json["description"],
    additionalInfo: json["additional_info"] ?? "",
    approved: json["approved"],
    decline: json["decline"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    service: json["service"] == null  ? null : Service.fromJson(json["service"] as Map<String, dynamic>),

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "serviceprovider_id": serviceproviderId,
    "service_id": serviceId,
    "address": address,
    "lat": lat,
    "long": long,
    "property_type": propertyType,
    "price": price,
    "date": date,
    "time": time,
    "description": description,
    "additional_info": additionalInfo,
    "approved": approved,
    "decline": decline,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "service": service,
  };
}

class Service {
  int id;
  int userId;
  String serviceName;
  String description;
  dynamic categoryId;
  String pricing;
  dynamic durationId;
  String startTime;
  String endTime;
  String location;
  String lat;
  String long;
  String media;
  String additionalInformation;
  String country;
  String city;
  DateTime createdAt;
  DateTime updatedAt;

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
    required this.country,
    required this.city,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json["id"],
    userId: json["user_id"],
    serviceName: json["service_name"],
    description: json["description"],
    categoryId: json["category_id"],
    pricing: json["pricing"],
    durationId: json["duration_id"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    location: json["location"],
    lat: json["lat"],
    long: json["long"],
    media: json["media"],
    additionalInformation: json["additional_information"] ?? "",
    country: json["country"],
    city: json["city"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
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
    "country": country,
    "city": city,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
