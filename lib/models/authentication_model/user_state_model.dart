// To parse this JSON data, do
//
//     final userState = userStateFromJson(jsonString);

import 'dart:convert';

UserState userStateFromJson(String str) => UserState.fromJson(json.decode(str));

String userStateToJson(UserState data) => json.encode(data.toJson());

class UserState {
  bool status;
  Provider data;
  String message;

  UserState({
    required this.status,
    required this.data,
    required this.message,
  });

  factory UserState.fromJson(Map<String, dynamic> json) => UserState(
    status: json["status"],
    data: Provider.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
    "message": message,
  };
}

class Provider {
  final User user;
  final List<ServiceData> services;
  int totalService;
  int totalJobs;
  int totalPrice;
  int rate;

  Provider({
    required this.user,
    required this.services,
    this.totalService = 0,
    this.totalJobs = 0,
    this.totalPrice = 0,
    this.rate = 0,
  });

  factory Provider.fromJson(Map<String, dynamic> json) => Provider(
    user: User.fromJson(json["user"]),
    services: (json["services"] as List<dynamic>)
        .map((x) => ServiceData.fromJson(x))
        .toList(),
    totalService: json["total_service"] ?? 0,
    totalJobs: json["total_jobs"] ?? 0,
    totalPrice: json["total_price"] ?? 0,
    rate: json["rate"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "services": services.map((e) => e.toJson()).toList(),
    "total_service": totalService,
    "total_jobs": totalJobs,
    "total_price": totalPrice,
    "rate": rate,
  };
}

class ServiceData {
  final int id;
  final int userId;
  final String serviceName;
  final String description;
  final String pricing;
  final int duration;
  final String startTime;
  final String endTime;
  final String location;
  final String country;
  final String yearExperience;

  ServiceData({
    required this.id,
    required this.userId,
    required this.serviceName,
    required this.description,
    required this.pricing,
    required this.duration,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.country,
    required this.yearExperience,
  });

  factory ServiceData.fromJson(Map<String, dynamic> json) => ServiceData(
    id: json["id"],
    userId: json["user_id"],
    serviceName: json["service_name"],
    description: json["description"],
    pricing: json["pricing"],
    duration: json["duration"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    location: json["location"],
    country: json["country"],
    yearExperience: json["year_experience"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "service_name": serviceName,
    "description": description,
    "pricing": pricing,
    "duration": duration,
    "start_time": startTime,
    "end_time": endTime,
    "location": location,
    "country": country,
    "year_experience": yearExperience,
  };
}

class User {
  int id;
  String fullname;
  String email;
  String phoneNumber;
  int roleId;
  String profileimage;
  String platform;
  String deviceToken;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.fullname,
    required this.email,
    required this.phoneNumber,
    required this.roleId,
    required this.profileimage,
    required this.platform,
    required this.deviceToken,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    fullname: json["full_name"] ?? json["fullname"] ?? "",
    email: json["email"] ?? "",
    phoneNumber: json["phone_number"] ?? "",
    roleId: json["role_id"] ?? 0,
    profileimage: json["profile_image"] ?? json["profileimage"] ?? "",
    platform: json["platform"] ?? "",
    deviceToken: json["device_token"] ?? "",
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
    "platform": platform,
    "device_token": deviceToken,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
