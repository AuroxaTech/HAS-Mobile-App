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
  final Landlord landlord;
  final int totalProperties;
  final int pendingContract;
  final int totalSpend;

  LandLordData({
    required this.landlord,
    required this.totalProperties,
    this.pendingContract = 0, // Default value
    required this.totalSpend,
  });

  factory LandLordData.fromJson(Map<String, dynamic> json) {
    return LandLordData(
      landlord: Landlord.fromJson(json['landlord']),
      totalProperties: json['total_properties'] ?? 0,
      pendingContract: json['pending_contract'] ?? 0,
      totalSpend: json['total_spend'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "landlord": landlord.toJson(),
    "total_properties": totalProperties,
    "pending_contract": pendingContract,
    "total_spend": totalSpend,
  };
}

class Landlord {
  final int id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String profileImage;
  final User? user;

  Landlord({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.profileImage,
    this.user,
  });

  factory Landlord.fromJson(Map<String, dynamic> json) {
    return Landlord(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      profileImage: json['profile_image'],
      user: User(
        fullname: json['full_name'],
        profileimage: json['profile_image'],
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "email": email,
    "phone_number": phoneNumber,
    "profile_image": profileImage,
    "user": user,
  };
}

class User {
  final String fullname;
  final String profileimage;

  User({
    required this.fullname,
    required this.profileimage,
  });

  Map<String, dynamic> toJson() => {
    "fullname": fullname,
    "profileimage": profileimage,
  };
}
