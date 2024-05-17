// To parse this JSON data, do
//
//     final landordStat = landordStatFromJson(jsonString);

import 'dart:convert';

LandordStat landordStatFromJson(String str) => LandordStat.fromJson(json.decode(str));

String landordStatToJson(LandordStat data) => json.encode(data.toJson());

class LandordStat {
  bool status;
  LandLordData data;
  String message;

  LandordStat({
    required this.status,
    required this.data,
    required this.message,
  });

  factory LandordStat.fromJson(Map<String, dynamic> json) => LandordStat(
    status: json["status"],
    data: LandLordData.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
    "message": message,
  };
}

class LandLordData {
  Landlord landlord;
  int pendingContract;
  int totalProperties;
  String totalSpend;

  LandLordData({
    required this.landlord,
    required this.pendingContract,
    required this.totalProperties,
    required this.totalSpend,
  });

  factory LandLordData.fromJson(Map<String, dynamic> json) => LandLordData(
    landlord: Landlord.fromJson(json["landlord"]),
    pendingContract: json["pending_contract"],
    totalProperties: json["total_properties"],
    totalSpend: json["total_spend"],
  );

  Map<String, dynamic> toJson() => {
    "landlord": landlord.toJson(),
    "pending_contract": pendingContract,
    "total_properties": totalProperties,
    "total_spend": totalSpend,
  };
}

class Landlord {
  int id;
  String userId;
  String noOfProperty;
  String availabilityStartTime;
  String availabilityEndTime;
  String createdAt;
  String updatedAt;
  User? user;

  Landlord({
    required this.id,
    required this.userId,
    required this.noOfProperty,
    required this.availabilityStartTime,
    required this.availabilityEndTime,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory Landlord.fromJson(Map<String, dynamic> json) => Landlord(
    id: json["id"] ?? 0,
    userId: json["user_id"] ?? "",
    noOfProperty: json["no_of_property"] ?? "",
    availabilityStartTime: json["availability_start_time"] ?? "",
    availabilityEndTime: json["availability_end_time"] ?? "",
    createdAt: json["created_at"] ?? "",
    updatedAt: json["updated_at"] ?? "",
    user: json["user"] == null ? null  : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "no_of_property": noOfProperty,
    "availability_start_time": availabilityStartTime,
    "availability_end_time": availabilityEndTime,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "user": user,
  };
}

class User {
  int id;
  String fullname;
  String email;
  String phoneNumber;
  String roleId;
  String profileimage;
  String createdAt;
  String updatedAt;

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
    id: json["id"] ?? 0,
    fullname: json["fullname"] ?? "",
    email: json["email"]??"",
    phoneNumber: json["phone_number"] ?? "",
    roleId: json["role_id"] ?? "",
    profileimage: json["profileimage"] ?? "",
    createdAt: json["created_at"] ?? "",
    updatedAt: json["updated_at"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullname": fullname,
    "email": email,
    "phone_number": phoneNumber,
    "role_id": roleId,
    "profileimage": profileimage,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
