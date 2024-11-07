// To parse this JSON data, do
//
//     final serviceRequest = serviceRequestFromJson(jsonString);

import 'dart:convert';

ServiceRequest serviceRequestFromJson(String str) =>
    ServiceRequest.fromJson(json.decode(str));

String serviceRequestToJson(ServiceRequest data) => json.encode(data.toJson());

// To parse this JSON data, do
// final serviceRequest = serviceRequestFromJson(jsonString);

class ServiceRequest {
  bool status;
  List<ServiceRequestProvider> data;
  String message;

  ServiceRequest({
    required this.status,
    required this.data,
    required this.message,
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) => ServiceRequest(
        status: json["status"],
        data: List<ServiceRequestProvider>.from(
            json["data"].map((x) => ServiceRequestProvider.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class ServiceRequestProvider {
  int id;
  int userId;
  int serviceproviderId;
  int serviceId;
  String address;
  String? postalCode;
  String lat;
  String long;
  String price;
  PropertyType? propertyType;
  String date;
  String time;
  String description;
  String additionalInfo;
  int approved;
  int decline;
  DateTime createdAt;
  DateTime updatedAt;
  User user;
  Service? service;
  Provider? provider;

  ServiceRequestProvider(
      {required this.id,
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
      required this.user,
      required this.service,
      required this.provider,
      this.postalCode});

  factory ServiceRequestProvider.fromJson(Map<String, dynamic> json) =>
      ServiceRequestProvider(
        id: json["id"],
        userId: json["user_id"],
        serviceproviderId: json["serviceprovider_id"],
        serviceId: json["service_id"],
        address: json["address"],
        postalCode: json["postal_code"],
        lat: json["lat"],
        long: json["long"],
        price: json["price"],
        propertyType: json["property_type"] == null
            ? null
            : PropertyType.fromJson(
                json["property_type"] as Map<String, dynamic>),
        date: json["date"],
        time: json["time"],
        description: json["description"],
        additionalInfo: json["additional_info"] ?? "",
        approved: json["approved"],
        decline: json["decline"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: User.fromJson(json["user"] as Map<String, dynamic>? ?? {}),
        service:
            json["service"] == null ? null : Service.fromJson(json["service"]),
        provider: json["provider"] == null
            ? null
            : Provider.fromJson(json["provider"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "serviceprovider_id": serviceproviderId,
        "service_id": serviceId,
        "address": address,
        "postal_code": postalCode,
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
        "user": user.toJson(),
        "service": service?.toJson(),
      };
}

class PropertyType {
  int id;
  String name;
  dynamic createdBy;
  dynamic createdAt;
  dynamic updatedAt;

  PropertyType({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PropertyType.fromJson(Map<String, dynamic> json) => PropertyType(
        id: json["id"],
        name: json["name"],
        createdBy: json["created_by"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_by": createdBy,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Service {
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
  String additionalInformation;
  DateTime createdAt;
  DateTime updatedAt;

  Service({
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

  factory Service.fromJson(Map<String, dynamic> json) => Service(
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

class User {
  int id;
  String fullname;
  String email;
  String phoneNumber;
  int roleId;
  String profileimage;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.fullname,
    required this.email,
    required this.phoneNumber,
    required this.roleId,
    required this.profileimage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] as int? ?? 0, // Default to 0 if null
        fullname: json["fullname"] as String? ??
            '', // Default to empty string if null
        email:
            json["email"] as String? ?? '', // Default to empty string if null
        phoneNumber: json["phone_number"] as String? ??
            '', // Default to empty string if null
        roleId: json["role_id"] ?? 0, // Default to 0 if null
        profileimage: json["profileimage"] as String? ??
            '', // Default to empty string if null
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : DateTime(1970), // Default to Unix epoch if null
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : DateTime(1970), // Default to Unix epoch if null
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

class ServiceRequestUser {
  int id;
  int userId;
  int serviceproviderId;
  String address;
  String lat;
  String long;
  String price;
  PropertyType? propertyType;
  String date;
  String time;
  String description;
  String additionalInfo;
  int approved;
  int decline;
  DateTime createdAt;
  DateTime updatedAt;
  User user;
  Service? service;

  ServiceRequestUser({
    required this.id,
    required this.userId,
    required this.serviceproviderId,
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
    required this.user,
    required this.service,
  });

  factory ServiceRequestUser.fromJson(Map<String, dynamic> json) =>
      ServiceRequestUser(
        id: json["id"],
        userId: json["user_id"],
        serviceproviderId: json["serviceprovider_id"],
        address: json["address"],
        lat: json["lat"],
        long: json["long"],
        price: json["price"],
        propertyType: json["property_type"] != null
            ? PropertyType.fromJson(json["property_type"])
            : null,
        date: json["date"],
        time: json["time"],
        description: json["description"],
        additionalInfo: json["additional_info"] ?? "",
        approved: json["approved"],
        decline: json["decline"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: User.fromJson(json["provider"]),
        service:
            json["service"] == null ? null : Service.fromJson(json["service"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "serviceprovider_id": serviceproviderId,
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
        "user": user.toJson(),
      };
}

class PropertyTypeUser {
  int id;
  String name;
  dynamic createdBy;
  dynamic createdAt;
  dynamic updatedAt;

  PropertyTypeUser({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PropertyTypeUser.fromJson(Map<String, dynamic> json) =>
      PropertyTypeUser(
        id: json["id"],
        name: json["name"],
        createdBy: json["created_by"] ?? "",
        createdAt: json["created_at"] ?? "",
        updatedAt: json["updated_at"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_by": createdBy,
        "created_at": createdAt,
        "updated_at": updatedAt,
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
