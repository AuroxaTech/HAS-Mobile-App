// To parse this JSON data, do
//
//     final contractModel = contractModelFromJson(jsonString);

import 'dart:convert';

ContractModel contractModelFromJson(String str) => ContractModel.fromJson(json.decode(str));

String contractModelToJson(ContractModel data) => json.encode(data.toJson());

class ContractModel {
  bool status;
  List<Contracts> data;
  String message;

  ContractModel({
    required this.status,
    required this.data,
    required this.message,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) => ContractModel(
    status: json["status"],
    data: List<Contracts>.from(json["data"].map((x) => Contracts.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class Contracts {
  int id;
  int userId;
  int propertyId;
  String landlordId;
  String landlordName;
  String landlordAddress;
  String landlordPhone;
  String tenantName;
  String tenantAddress;
  String tenantPhone;
  String tenantEmail;
  int occupants;
  String premisesAddress;
  String propertyType;
  String leaseStartDate;
  String leaseEndDate;
  String leaseType;
  String rentAmount;
  String rentDueDate;
  String rentPaymentMethod;
  String securityDepositAmount;
  String includedUtilities;
  String tenantResponsibilities;
  String emergencyContactName;
  String emergencyContactPhone;
  String emergencyContactAddress;
  String buildingSuperintendentName;
  String buildingSuperintendentAddress;
  String buildingSuperintendentPhone;
  int rentIncreaseNoticePeriod;
  int noticePeriodForTermination;
  String latePaymentFee;
  String rentalIncentives;
  String additionalTerms;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic property;
  Tenant? tenant;
  Landlord? landlord;

  Contracts({
    required this.id,
    required this.userId,
    required this.propertyId,
    required this.landlordId,
    required this.landlordName,
    required this.landlordAddress,
    required this.landlordPhone,
    required this.tenantName,
    required this.tenantAddress,
    required this.tenantPhone,
    required this.tenantEmail,
    required this.occupants,
    required this.premisesAddress,
    required this.propertyType,
    required this.leaseStartDate,
    required this.leaseEndDate,
    required this.leaseType,
    required this.rentAmount,
    required this.rentDueDate,
    required this.rentPaymentMethod,
    required this.securityDepositAmount,
    required this.includedUtilities,
    required this.tenantResponsibilities,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.emergencyContactAddress,
    required this.buildingSuperintendentName,
    required this.buildingSuperintendentAddress,
    required this.buildingSuperintendentPhone,
    required this.rentIncreaseNoticePeriod,
    required this.noticePeriodForTermination,
    required this.latePaymentFee,
    required this.rentalIncentives,
    required this.additionalTerms,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.property,
    required this.tenant,
    required this.landlord,
  });

  factory Contracts.fromJson(Map<String, dynamic> json) => Contracts(
    id: json["id"],
    userId: json["user_id"],
    propertyId: json["property_id"],
    landlordId: json["landlord_id"] ?? "",
    landlordName: json["landlordName"],
    landlordAddress: json["landlordAddress"],
    landlordPhone: json["landlordPhone"],
    tenantName: json["tenantName"],
    tenantAddress: json["tenantAddress"],
    tenantPhone: json["tenantPhone"],
    tenantEmail: json["tenantEmail"],
    occupants: json["occupants"],
    premisesAddress: json["premisesAddress"],
    propertyType: json["propertyType"],
    leaseStartDate: json["leaseStartDate"],
    leaseEndDate: json["leaseEndDate"],
    leaseType: json["leaseType"],
    rentAmount: json["rentAmount"],
    rentDueDate: json["rentDueDate"],
    rentPaymentMethod: json["rentPaymentMethod"],
    securityDepositAmount: json["securityDepositAmount"],
    includedUtilities: json["includedUtilities"],
    tenantResponsibilities: json["tenantResponsibilities"],
    emergencyContactName: json["emergencyContactName"],
    emergencyContactPhone: json["emergencyContactPhone"],
    emergencyContactAddress: json["emergencyContactAddress"],
    buildingSuperintendentName: json["buildingSuperintendentName"],
    buildingSuperintendentAddress: json["buildingSuperintendentAddress"],
    buildingSuperintendentPhone: json["buildingSuperintendentPhone"],
    rentIncreaseNoticePeriod: json["rentIncreaseNoticePeriod"],
    noticePeriodForTermination: json["noticePeriodForTermination"],
    latePaymentFee: json["latePaymentFee"],
    rentalIncentives: json["rentalIncentives"],
    additionalTerms: json["additionalTerms"],
    status: json["status"].toString(),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    property: json["property"],
    tenant: json["tenant"] != null ? Tenant.fromJson(json["tenant"]) : null,
    landlord: json["landlord"] != null ? Landlord.fromJson(json["landlord"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "property_id": propertyId,
    "landlord_id": landlordId,
    "landlordName": landlordName,
    "landlordAddress": landlordAddress,
    "landlordPhone": landlordPhone,
    "tenantName": tenantName,
    "tenantAddress": tenantAddress,
    "tenantPhone": tenantPhone,
    "tenantEmail": tenantEmail,
    "occupants": occupants,
    "premisesAddress": premisesAddress,
    "propertyType": propertyType,
    "leaseStartDate": leaseStartDate,
    "leaseEndDate": leaseEndDate,
    "leaseType": leaseType,
    "rentAmount": rentAmount,
    "rentDueDate": rentDueDate,
    "rentPaymentMethod": rentPaymentMethod,
    "securityDepositAmount": securityDepositAmount,
    "includedUtilities": includedUtilities,
    "tenantResponsibilities": tenantResponsibilities,
    "emergencyContactName": emergencyContactName,
    "emergencyContactPhone": emergencyContactPhone,
    "emergencyContactAddress": emergencyContactAddress,
    "buildingSuperintendentName": buildingSuperintendentName,
    "buildingSuperintendentAddress": buildingSuperintendentAddress,
    "buildingSuperintendentPhone": buildingSuperintendentPhone,
    "rentIncreaseNoticePeriod": rentIncreaseNoticePeriod,
    "noticePeriodForTermination": noticePeriodForTermination,
    "latePaymentFee": latePaymentFee,
    "rentalIncentives": rentalIncentives,
    "additionalTerms": additionalTerms,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "property": property,
    "tenant": tenant,
    "landlord": landlord,
  };
}

class Landlord {
  int id;
  String fullname;
  String email;
  String phoneNumber;
  String roleId;
  String profileimage;
  DateTime createdAt;
  DateTime updatedAt;

  Landlord({
    required this.id,
    required this.fullname,
    required this.email,
    required this.phoneNumber,
    required this.roleId,
    required this.profileimage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Landlord.fromJson(Map<String, dynamic> json) => Landlord(
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

class Tenant {
  int id;
  String fullname;
  String email;
  String phoneNumber;
  String roleId;
  String profileimage;
  DateTime createdAt;
  DateTime updatedAt;

  Tenant({
    required this.id,
    required this.fullname,
    required this.email,
    required this.phoneNumber,
    required this.roleId,
    required this.profileimage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) => Tenant(
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

DateTime parseDateFromString(String dateString) {
  // Split the string by the delimiter '-'
  List<String> parts = dateString.split('-');
  // Check if the date string is in the expected format
  if (parts.length != 3) {
    throw FormatException("Invalid date format", dateString);
  }
  // Convert the parts into integers
  int day = int.parse(parts[0]);
  int month = int.parse(parts[1]);
  int year = int.parse(parts[2]);
  // Return the DateTime object
  return DateTime(year, month, day);
}