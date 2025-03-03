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
  final Tenant tenant;
  final int pendingContract;
  final int totalRented;
  final String totalSpend;
  final List<dynamic> properties;

  TenantData({
    required this.tenant,
    required this.pendingContract,
    required this.totalRented,
    required this.totalSpend,
    required this.properties,
  });

  factory TenantData.fromJson(Map<String, dynamic> json) {
    return TenantData(
      tenant: Tenant.fromJson(json['tenant']),
      pendingContract: json['pending_contract'] ?? 0,
      totalRented: json['total_rented'] ?? 0,
      totalSpend: json['total_spend']?.toString() ?? "0",
      properties: json['properties'] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    "tenant": tenant.toJson(),
    "pending_contract": pendingContract,
    "total_rented": totalRented,
    "total_spend": totalSpend,
    "properties": properties,
  };
}

class Tenant {
  final int id;
  final String lastStatus;
  final String? lastTenancy;
  final String? lastLandlordName;
  final String? lastLandlordContact;
  final String occupation;
  final String leasedDuration;
  final String noOfOccupants;
  final int userId;
  final String createdAt;
  final String updatedAt;
  final User user;

  Tenant({
    required this.id,
    required this.lastStatus,
    this.lastTenancy,
    this.lastLandlordName,
    this.lastLandlordContact,
    required this.occupation,
    required this.leasedDuration,
    required this.noOfOccupants,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) {
    return Tenant(
      id: json['id'],
      lastStatus: json['last_status'] ?? "0",
      lastTenancy: json['last_tenancy'],
      lastLandlordName: json['last_landlord_name'],
      lastLandlordContact: json['last_landlord_contact'],
      occupation: json['occupation'] ?? "",
      leasedDuration: json['leased_duration'] ?? "",
      noOfOccupants: json['no_of_occupants'] ?? "",
      userId: json['user_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: User.fromJson(json['user']),
    );
  }

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
    "created_at": createdAt,
    "updated_at": updatedAt,
    "user": user.toJson(),
  };
}

class User {
  final int id;
  final String fullname;
  final String email;
  final String userName;
  final String phoneNumber;
  final String role;
  final String address;
  final String postalCode;
  final String profileimage;

  User({
    required this.id,
    required this.fullname,
    required this.email,
    required this.userName,
    required this.phoneNumber,
    required this.role,
    required this.address,
    required this.postalCode,
    required this.profileimage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullname: json['full_name'],
      email: json['email'],
      userName: json['user_name'],
      phoneNumber: json['phone_number'],
      role: json['role'],
      address: json['address'] ?? "",
      postalCode: json['postal_code'] ?? "",
      profileimage: json['profile_image'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullname": fullname,
    "email": email,
    "user_name": userName,
    "phone_number": phoneNumber,
    "role": role,
    "address": address,
    "postal_code": postalCode,
    "profile_image": profileimage,
  };
}
