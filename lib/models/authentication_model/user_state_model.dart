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
  Serviceprovider serviceprovider;
  int totalService;
  int totalJobs;
  int totalPrice;
  int rate;

  Provider({
    required this.serviceprovider,
    required this.totalService,
    required this.totalJobs,
    required this.totalPrice,
    required this.rate,
  });

  factory Provider.fromJson(Map<String, dynamic> json) => Provider(
    serviceprovider: Serviceprovider.fromJson(json["serviceprovider"]),
    totalService: json["total_service"],
    totalJobs: json["total_jobs"],
    totalPrice: json["total_price"],
    rate: json["rate"],
  );

  Map<String, dynamic> toJson() => {
    "serviceprovider": serviceprovider.toJson(),
    "total_service": totalService,
    "total_jobs": totalJobs,
    "total_price": totalPrice,
    "rate": rate,
  };
}

class Serviceprovider {
  int id;
  int userId;
  String services;
  String yearExperience;
  String availabilityStartTime;
  String availabilityEndTime;
  String cnicFront;
  dynamic cnicEnd;
  String certification;
  dynamic file;
  DateTime createdAt;
  DateTime updatedAt;
  User user;
  ProviderService? providerService;

  Serviceprovider({
    required this.id,
    required this.userId,
    required this.services,
    required this.yearExperience,
    required this.availabilityStartTime,
    required this.availabilityEndTime,
    required this.cnicFront,
    required this.cnicEnd,
    required this.certification,
    required this.file,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.providerService,
  });

  factory Serviceprovider.fromJson(Map<String, dynamic> json) => Serviceprovider(
    id: json["id"],
    userId: json["user_id"],
    services: json["services"],
    yearExperience: json["year_experience"],
    availabilityStartTime: json["availability_start_time"],
    availabilityEndTime: json["availability_end_time"],
    cnicFront: json["cnic_front"],
    cnicEnd: json["cnic_end"],
    certification: json["certification"],
    file: json["file"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    user: User.fromJson(json["user"]),

    providerService: json["provider_service"] == null ? null  : ProviderService.fromJson(json["provider_service"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "services": services,
    "year_experience": yearExperience,
    "availability_start_time": availabilityStartTime,
    "availability_end_time": availabilityEndTime,
    "cnic_front": cnicFront,
    "cnic_end": cnicEnd,
    "certification": certification,
    "file": file,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "user": user.toJson(),
    "provider_service": providerService,
  };
}

class ProviderService {
  int id;
  String name;
  dynamic createdAt;
  dynamic updatedAt;

  ProviderService({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProviderService.fromJson(Map<String, dynamic> json) => ProviderService(
    id: json["id"],
    name: json["name"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt,
    "updated_at": updatedAt,
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
    fullname: json["fullname"],
    email: json["email"],
    phoneNumber: json["phone_number"],
    roleId: json["role_id"],
    profileimage: json["profileimage"],
    platform: json["platform"]?? "",
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
