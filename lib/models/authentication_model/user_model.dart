// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  bool status;
  String message;
  User data;

  UserModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        status: json["status"],
        message: json["message"],
        data: User.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class User {
  int id;
  String fullName;
  String userName;
  String email;
  String address;
  String postalCode;
  String phoneNumber;
  String roleId;
  String? profileImage;
  String platform;
  String deviceToken;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.fullName,
    required this.userName,
    required this.email,
    required this.address,
    required this.postalCode,
    required this.phoneNumber,
    required this.roleId,
    this.profileImage,
    required this.platform,
    required this.deviceToken,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        fullName: json["full_name"],
        userName: json["user_name"],
        email: json["email"],
        address: json["address"],
        postalCode: json["postal_code"],
        phoneNumber: json["phone_number"],
        roleId: json["role"],
        profileImage: json["profile_image"] ?? "",
        platform: json["platform"] ?? "",
        deviceToken: json["device_token"] ?? "",
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "user_name": userName,
        "address": address,
        "email": email,
        "postal_code": postalCode,
        "phone_number": phoneNumber,
        "role_id": roleId,
        "profile_image": profileImage,
        "platform": platform,
        "device_token": deviceToken,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
