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
  final String duration;
  final String startTime;
  final String endTime;
  final String location;
  final String? country;
  final dynamic yearExperience;

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
    this.country,
    required this.yearExperience,
  });

  factory ServiceData.fromJson(Map<String, dynamic> json) => ServiceData(
    id: json["id"],
    userId: json["user_id"],
    serviceName: json["service_name"],
    description: json["description"],
    pricing: json["pricing"],
    duration: json["duration"].toString(),
    startTime: json["start_time"],
    endTime: json["end_time"],
    location: json["location"],
    country: json["country"],
    yearExperience: json["year_experience"],
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
  String userName;
  String phoneNumber;
  String role;
  String? emailVerifiedAt;
  String? address;
  String? postalCode;
  String profileimage;
  String platform;
  String deviceToken;
  int approvedAt;
  String verificationToken;
  int isVerified;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.fullname,
    required this.email,
    required this.userName,
    required this.phoneNumber,
    required this.role,
    this.emailVerifiedAt,
    this.address,
    this.postalCode,
    required this.profileimage,
    required this.platform,
    required this.deviceToken,
    required this.approvedAt,
    required this.verificationToken,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    fullname: json["full_name"] ?? "",
    email: json["email"] ?? "",
    userName: json["user_name"] ?? "",
    phoneNumber: json["phone_number"] ?? "",
    role: json["role"] ?? "",
    emailVerifiedAt: json["email_verified_at"],
    address: json["address"],
    postalCode: json["postal_code"],
    profileimage: json["profile_image"] ?? "",
    platform: json["platform"] ?? "",
    deviceToken: json["device_token"] ?? "",
    approvedAt: json["approved_at"] ?? 0,
    verificationToken: json["verification_token"] ?? "",
    isVerified: json["is_verified"] ?? 0,
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullname,
    "email": email,
    "user_name": userName,
    "phone_number": phoneNumber,
    "role": role,
    "email_verified_at": emailVerifiedAt,
    "address": address,
    "postal_code": postalCode,
    "profile_image": profileimage,
    "platform": platform,
    "device_token": deviceToken,
    "approved_at": approvedAt,
    "verification_token": verificationToken,
    "is_verified": isVerified,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
