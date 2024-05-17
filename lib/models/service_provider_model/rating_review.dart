// To parse this JSON data, do
//
//     final serviceFeedback = serviceFeedbackFromJson(jsonString);

import 'dart:convert';

ServiceFeedback serviceFeedbackFromJson(String str) => ServiceFeedback.fromJson(json.decode(str));

String serviceFeedbackToJson(ServiceFeedback data) => json.encode(data.toJson());

class ServiceFeedback {
  bool status;
  List<FeedBack> data;
  String message;

  ServiceFeedback({
    required this.status,
    required this.data,
    required this.message,
  });

  factory ServiceFeedback.fromJson(Map<String, dynamic> json) => ServiceFeedback(
    status: json["status"],
    data: List<FeedBack>.from(json["data"].map((x) => FeedBack.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class FeedBack {
  int id;
  String userId;
  String serviceId;
  String propertySubTypeId;
  String rate;
  String description;
  DateTime createdAt;
  DateTime updatedAt;
  User user;
  Subpropertytype subpropertytype;

  FeedBack({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.propertySubTypeId,
    required this.rate,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.subpropertytype,
  });

  factory FeedBack.fromJson(Map<String, dynamic> json) => FeedBack(
    id: json["id"],
    userId: json["user_id"],
    serviceId: json["service_id"],
    propertySubTypeId: json["property_sub_type_id"],
    rate: json["rate"],
    description: json["description"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    user: User.fromJson(json["user"]),
    subpropertytype: Subpropertytype.fromJson(json["subpropertytype"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "service_id": serviceId,
    "property_sub_type_id": propertySubTypeId,
    "rate": rate,
    "description": description,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "user": user.toJson(),
    "subpropertytype": subpropertytype.toJson(),
  };
}

class Subpropertytype {
  int id;
  String name;
  String typeId;
  dynamic createdBy;
  dynamic createdAt;
  dynamic updatedAt;

  Subpropertytype({
    required this.id,
    required this.name,
    required this.typeId,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Subpropertytype.fromJson(Map<String, dynamic> json) => Subpropertytype(
    id: json["id"],
    name: json["name"],
    typeId: json["type_id"],
    createdBy: json["created_by"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type_id": typeId,
    "created_by": createdBy,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

class User {
  int id;
  String fullname;
  String email;
  String phoneNumber;
  String roleId;
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
