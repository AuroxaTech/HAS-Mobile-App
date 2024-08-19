// To parse this JSON data, do
//
//     final tenantStat = tenantStatFromJson(jsonString);

import 'dart:convert';

TenantStat tenantStatFromJson(String str) => TenantStat.fromJson(json.decode(str));

String tenantStatToJson(TenantStat data) => json.encode(data.toJson());

class TenantStat {
  bool status;
  TenantData data;
  String message;

  TenantStat({
    required this.status,
    required this.data,
    required this.message,
  });

  factory TenantStat.fromJson(Map<String, dynamic> json) => TenantStat(
    status: json["status"],
    data: TenantData.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
    "message": message,
  };
}

class TenantData {
  Tenant tenant;
  int pendingContract;
  int totalRented;
  String totalSpend;

  TenantData({
    required this.tenant,
    required this.pendingContract,
    required this.totalRented,
    required this.totalSpend,
  });

  factory TenantData.fromJson(Map<String, dynamic> json) => TenantData(
    tenant: Tenant.fromJson(json["tenant"]),
    pendingContract: json["pending_contract"],
    totalRented: json["total_rented"],
    totalSpend: json["total_spend"],
  );

  Map<String, dynamic> toJson() => {
    "tenant": tenant.toJson(),
    "pending_contract": pendingContract,
    "total_rented": totalRented,
    "total_spend": totalSpend,
  };
}

class Tenant {
  int id;
  int userId;
  String lastStatus;
  dynamic lastTenancy;
  dynamic lastLandlordName;
  dynamic lastLandlordContact;
  String occupation;
  String leasedDuration;
  String noOfOccupants;
  DateTime createdAt;
  DateTime updatedAt;
  User user;

  Tenant({
    required this.id,
    required this.userId,
    required this.lastStatus,
    required this.lastTenancy,
    required this.lastLandlordName,
    required this.lastLandlordContact,
    required this.occupation,
    required this.leasedDuration,
    required this.noOfOccupants,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) => Tenant(
    id: json["id"],
    userId: json["user_id"],
    lastStatus: json["last_status"],
    lastTenancy: json["last_tenancy"],
    lastLandlordName: json["last_landlord_name"],
    lastLandlordContact: json["last_landlord_contact"],
    occupation: json["occupation"],
    leasedDuration: json["leased_duration"],
    noOfOccupants: json["no_of_occupants"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "last_status": lastStatus,
    "last_tenancy": lastTenancy,
    "last_landlord_name": lastLandlordName,
    "last_landlord_contact": lastLandlordContact,
    "occupation": occupation,
    "leased_duration": leasedDuration,
    "no_of_occupants": noOfOccupants,
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
