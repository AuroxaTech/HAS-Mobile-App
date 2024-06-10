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
  Visitor visitor;
  int pendingJob;
  String totalSpend;
  int totalFavorite;

  VisitorData({
    required this.visitor,
    required this.pendingJob,
    required this.totalSpend,
    required this.totalFavorite,
  });

  factory VisitorData.fromJson(Map<String, dynamic> json) => VisitorData(
    visitor: Visitor.fromJson(json["visitor"]),
    pendingJob: json["pending_job"],
    totalSpend: json["total_spend"],
    totalFavorite: json["total_favorite"],
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
