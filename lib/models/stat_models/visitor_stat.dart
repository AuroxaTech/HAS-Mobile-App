// To parse this JSON data, do
//
//     final visitorStat = visitorStatFromJson(jsonString);

import 'dart:convert';

VisitorStat visitorStatFromJson(String str) => VisitorStat.fromJson(json.decode(str));

String visitorStatToJson(VisitorStat data) => json.encode(data.toJson());

class VisitorStat {
  bool status;
  VisitorData data;
  String message;

  VisitorStat({
    required this.status,
    required this.data,
    required this.message,
  });

  factory VisitorStat.fromJson(Map<String, dynamic> json) => VisitorStat(
    status: json["status"],
    data: VisitorData.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
    "message": message,
  };
}

class VisitorData {
  final User visitor;
  final int pendingJob;
  final String totalSpend;
  final int totalFavorite;

  VisitorData({
    required this.visitor,
    this.pendingJob = 0,
    this.totalSpend = "0",
    this.totalFavorite = 0,
  });

  factory VisitorData.fromJson(Map<String, dynamic> json) => VisitorData(
    visitor: User.fromJson(json["visitor"]),
    pendingJob: json["pending_job"] ?? 0,
    totalSpend: json["total_spend"]?.toString() ?? "0",
    totalFavorite: json["total_favorite"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "visitor": visitor.toJson(),
    "pending_job": pendingJob,
    "total_spend": totalSpend,
    "total_favorite": totalFavorite,
  };
}

class Visitor {
  int id;
  int userId;
  DateTime createdAt;
  DateTime updatedAt;
  User user;

  Visitor({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory Visitor.fromJson(Map<String, dynamic> json) => Visitor(
    id: json["id"],
    userId: json["user_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "user": user.toJson(),
  };
}

class User {
  final int id;
  final String fullname;
  final String email;
  final String phoneNumber;
  final String profileimage;

  User({
    required this.id,
    required this.fullname,
    required this.email,
    required this.phoneNumber,
    required this.profileimage,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    fullname: json["full_name"] ?? json["fullname"] ?? "",
    email: json["email"] ?? "",
    phoneNumber: json["phone_number"] ?? "",
    profileimage: json["profile_image"] ?? json["profileimage"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullname": fullname,
    "email": email,
    "phone_number": phoneNumber,
    "profileimage": profileimage,
  };
}
