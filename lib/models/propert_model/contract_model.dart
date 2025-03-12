// To parse this JSON data, do
//
//     final contractModel = contractModelFromJson(jsonString);

// ContractModel contractModelFromJson(String str) => ContractModel.fromJson(json.decode(str));
//
// String contractModelToJson(ContractModel data) => json.encode(data.toJson());
//
// class ContractModel {
//   bool status;
//   List<Contracts> data;
//   String message;
//
//   ContractModel({
//     required this.status,
//     required this.data,
//     required this.message,
//   });
//
//   factory ContractModel.fromJson(Map<String, dynamic> json) => ContractModel(
//     status: json["status"],
//     data: List<Contracts>.from(json["data"].map((x) => Contracts.fromJson(x))),
//     message: json["message"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "data": List<dynamic>.from(data.map((x) => x.toJson())),
//     "message": message,
//   };
// }

class ContractDetail {
  final int id;
  final int userId;
  final String status;
  final int propertyId;
  final String landlordName;
  final String landlordAddress;
  final String landlordPhone;
  final String tenantName;
  final String tenantAddress;
  final String tenantPhone;
  final String tenantEmail;
  final int occupants;
  final String premisesAddress;
  final String propertyType;
  final String leaseStartDate;
  final String leaseEndDate;
  final String leaseType;
  final String rentAmount;
  final String rentDueDate;
  final String rentPaymentMethod;
  final String securityDepositAmount;
  final String includedUtilities;
  final String tenantResponsibilities;
  final String emergencyContactName;
  final String emergencyContactPhone;
  final String emergencyContactAddress;
  final String buildingSuperintendentName;
  final String buildingSuperintendentAddress;
  final String buildingSuperintendentPhone;
  final int rentIncreaseNoticePeriod;
  final int noticePeriodForTermination;
  final String latePaymentFee;
  final String rentalIncentives;
  final String additionalTerms;
  final String createdAt;
  final String updatedAt;
  final Property? property;
  final User user;
  dynamic propertys;

  ContractDetail({
    required this.id,
    required this.userId,
    required this.status,
    required this.propertyId,
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
    required this.createdAt,
    required this.updatedAt,
    this.property,
    required this.user,
    required this.propertys,
  });

  factory ContractDetail.fromJson(Map<String, dynamic> json) {
    return ContractDetail(
      id: json['id'],
      userId: json['user_id'],
      status: json['status'].toString(),
      propertyId: json['property_id'],
      landlordName: json['landlordName'],
      landlordAddress: json['landlordAddress'],
      landlordPhone: json['landlordPhone'],
      tenantName: json['tenantName'],
      tenantAddress: json['tenantAddress'],
      tenantPhone: json['tenantPhone'],
      tenantEmail: json['tenantEmail'],
      occupants: json['occupants'],
      premisesAddress: json['premisesAddress'],
      propertyType: json['propertyType'],
      leaseStartDate: json['leaseStartDate'],
      leaseEndDate: json['leaseEndDate'],
      leaseType: json['leaseType'],
      rentAmount: json['rentAmount'],
      rentDueDate: json['rentDueDate'],
      rentPaymentMethod: json['rentPaymentMethod'],
      securityDepositAmount: json['securityDepositAmount'],
      includedUtilities: json['includedUtilities'],
      tenantResponsibilities: json['tenantResponsibilities'],
      emergencyContactName: json['emergencyContactName'],
      emergencyContactPhone: json['emergencyContactPhone'],
      emergencyContactAddress: json['emergencyContactAddress'],
      buildingSuperintendentName: json['buildingSuperintendentName'],
      buildingSuperintendentAddress: json['buildingSuperintendentAddress'],
      buildingSuperintendentPhone: json['buildingSuperintendentPhone'],
      rentIncreaseNoticePeriod: json['rentIncreaseNoticePeriod'],
      noticePeriodForTermination: json['noticePeriodForTermination'],
      latePaymentFee: json['latePaymentFee'],
      rentalIncentives: json['rentalIncentives'],
      additionalTerms: json['additionalTerms'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      propertys: json["property"],
      // property:
      //     json['property'] == null ? null : Property.fromJson(json['property']),
      user: User.fromJson(json['user']),
    );
  }
}

class Contracts {
  final int id;
  final int userId;
  final String status;
  final int propertyId;
  final String landlordName;
  final String landlordAddress;
  final String landlordPhone;
  final String tenantName;
  final String tenantAddress;
  final String tenantPhone;
  final String tenantEmail;
  final int occupants;
  final String premisesAddress;
  final String propertyType;
  final String leaseStartDate;
  final String leaseEndDate;
  final String leaseType;
  final String rentAmount;
  final String rentDueDate;
  final String rentPaymentMethod;
  final String securityDepositAmount;
  final String includedUtilities;
  final String tenantResponsibilities;
  final String emergencyContactName;
  final String emergencyContactPhone;
  final String emergencyContactAddress;
  final String buildingSuperintendentName;
  final String buildingSuperintendentAddress;
  final String buildingSuperintendentPhone;
  final int rentIncreaseNoticePeriod;
  final int noticePeriodForTermination;
  final String latePaymentFee;
  final String rentalIncentives;
  final String additionalTerms;
  final String createdAt;
  final String updatedAt;

  Contracts({
    required this.id,
    required this.userId,
    required this.status,
    required this.propertyId,
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
    required this.createdAt,
    required this.updatedAt,
  });

  factory Contracts.fromJson(Map<String, dynamic> json) {
    return Contracts(
      id: json['id'],
      userId: json['user_id'],
      status: json['status'].toString(),
      propertyId: json['property_id'],
      landlordName: json['landlordName'],
      landlordAddress: json['landlordAddress'],
      landlordPhone: json['landlordPhone'],
      tenantName: json['tenantName'],
      tenantAddress: json['tenantAddress'],
      tenantPhone: json['tenantPhone'],
      tenantEmail: json['tenantEmail'],
      occupants: json['occupants'],
      premisesAddress: json['premisesAddress'],
      propertyType: json['propertyType'],
      leaseStartDate: json['leaseStartDate'],
      leaseEndDate: json['leaseEndDate'],
      leaseType: json['leaseType'],
      rentAmount: json['rentAmount'],
      rentDueDate: json['rentDueDate'],
      rentPaymentMethod: json['rentPaymentMethod'],
      securityDepositAmount: json['securityDepositAmount'],
      includedUtilities: json['includedUtilities'],
      tenantResponsibilities: json['tenantResponsibilities'],
      emergencyContactName: json['emergencyContactName'],
      emergencyContactPhone: json['emergencyContactPhone'],
      emergencyContactAddress: json['emergencyContactAddress'],
      buildingSuperintendentName: json['buildingSuperintendentName'],
      buildingSuperintendentAddress: json['buildingSuperintendentAddress'],
      buildingSuperintendentPhone: json['buildingSuperintendentPhone'],
      rentIncreaseNoticePeriod: json['rentIncreaseNoticePeriod'],
      noticePeriodForTermination: json['noticePeriodForTermination'],
      latePaymentFee: json['latePaymentFee'],
      rentalIncentives: json['rentalIncentives'],
      additionalTerms: json['additionalTerms'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class Property {
  final int id;
  final String type;
  final String city;
  final String amount;
  final String address;
  final String lat;
  final String long;
  final String areaRange;
  final String bedroom;
  final String bathroom;
  final String description;
  final String electricityBill;
  final String propertyType;
  final String propertySubType;
  final int userId;
  final String createdAt;
  final String updatedAt;
  final int isFavorite;
  final User user;

  Property({
    required this.id,
    required this.type,
    required this.city,
    required this.amount,
    required this.address,
    required this.lat,
    required this.long,
    required this.areaRange,
    required this.bedroom,
    required this.bathroom,
    required this.description,
    required this.electricityBill,
    required this.propertyType,
    required this.propertySubType,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.isFavorite,
    required this.user,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      type: json['type'],
      city: json['city'],
      amount: json['amount'],
      address: json['address'],
      lat: json['lat'],
      long: json['long'],
      areaRange: json['area_range'],
      bedroom: json['bedroom'],
      bathroom: json['bathroom'],
      description: json['description'],
      electricityBill: json['electricity_bill'],
      propertyType: json['property_type'],
      propertySubType: json['property_sub_type'],
      userId: json['user_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isFavorite: json['isFavorite'],
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final int id;
  final String fullName;
  final String email;
  final String userName;
  final String phoneNumber;
  final String role;
  final String? emailVerifiedAt;
  final String address;
  final String postalCode;
  final String? profileImage;
  final String platform;
  final String deviceToken;
  final int approvedAt;
  final String verificationToken;
  final int isVerified;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.userName,
    required this.phoneNumber,
    required this.role,
    this.emailVerifiedAt,
    required this.address,
    required this.postalCode,
    this.profileImage,
    required this.platform,
    required this.deviceToken,
    required this.approvedAt,
    required this.verificationToken,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      userName: json['user_name'],
      phoneNumber: json['phone_number'],
      role: json['role'],
      emailVerifiedAt: json['email_verified_at'],
      address: json['address'],
      postalCode: json['postal_code'],
      profileImage: json['profile_image'],
      platform: json['platform'],
      deviceToken: json['device_token'],
      approvedAt: json['approved_at'],
      verificationToken: json['verification_token'],
      isVerified: json['is_verified'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
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
