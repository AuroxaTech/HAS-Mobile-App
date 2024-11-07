// To parse this JSON data, do
//
//     final providerJob = providerJobFromJson(jsonString);

import 'dart:convert';

ProviderJob providerJobFromJson(String str) =>
    ProviderJob.fromJson(json.decode(str));

String providerJobToJson(ProviderJob data) => json.encode(data.toJson());

class ProviderJob {
  bool status;
  List<ProviderJobData> data;
  String message;

  ProviderJob({
    required this.status,
    required this.data,
    required this.message,
  });

  factory ProviderJob.fromJson(Map<String, dynamic> json) => ProviderJob(
        status: json["status"],
        data: List<ProviderJobData>.from(
            json["data"].map((x) => ProviderJobData.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class ProviderJobData {
  int id;
  int userId;
  int requestId;
  int providerId;
  int status;
  DateTime? createdAt;
  DateTime? updatedAt;
  Request request;
  Provider provider;

  ProviderJobData({
    required this.id,
    required this.userId,
    required this.requestId,
    required this.providerId,
    required this.status,
    this.createdAt,
    this.updatedAt,
    required this.request,
    required this.provider,
  });

  factory ProviderJobData.fromJson(Map<String, dynamic> json) =>
      ProviderJobData(
        id: json["id"],
        userId: json["user_id"],
        requestId: json["request_id"],
        providerId: json["provider_id"],
        status: json["status"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
        request: Request.fromJson(json["request"]),
        provider: Provider.fromJson(json["provider"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "request_id": requestId,
        "provider_id": providerId,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
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
        phoneNumber: json["phone_number"],
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
  String price;
  int propertyType;
  String date;
  String time;
  String description;
  String additionalInfo;
  int approved;
  int decline;
  DateTime createdAt;
  DateTime updatedAt;

  Request({
    required this.id,
    required this.userId,
    required this.serviceproviderId,
    required this.serviceId,
    required this.address,
    required this.lat,
    required this.long,
    required this.price,
    required this.propertyType,
    required this.date,
    required this.time,
    required this.description,
    required this.additionalInfo,
    required this.approved,
    required this.decline,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Request.fromJson(Map<String, dynamic> json) => Request(
        id: json["id"],
        userId: json["user_id"],
        serviceproviderId: json["serviceprovider_id"],
        serviceId: json["service_id"],
        address: json["address"],
        lat: json["lat"],
        long: json["long"],
        price: json["price"],
        propertyType: json["property_type"],
        date: json["date"],
        time: json["time"],
        description: json["description"],
        additionalInfo: json["additional_info"] ?? "",
        approved: json["approved"],
        decline: json["decline"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "serviceprovider_id": serviceproviderId,
        "service_id": serviceId,
        "address": address,
        "lat": lat,
        "long": long,
        "price": price,
        "property_type": propertyType,
        "date": date,
        "time": time,
        "description": description,
        "additional_info": additionalInfo,
        "approved": approved,
        "decline": decline,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
