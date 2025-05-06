// To parse this JSON data, do
//
//     final providerJob = providerJobFromJson(jsonString);

import 'dart:convert';

ProviderJob providerJobFromJson(String str) =>
    ProviderJob.fromJson(json.decode(str));

String providerJobToJson(ProviderJob data) => json.encode(data.toJson());

class ProviderJob {
  bool status;
  List<ProviderJobData> data;
  String message;

  ProviderJob({
    required this.status,
    required this.data,
    required this.message,
  });

  factory ProviderJob.fromJson(Map<String, dynamic> json) => ProviderJob(
        status: json["status"],
        data: List<ProviderJobData>.from(
            json["data"].map((x) => ProviderJobData.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class ProviderJobData {
  int id;
  int userId;
  int providerId;
  String serviceName;
  String description;
  String pricing;
  String duration;
  String startTime;
  String endTime;
  String location;
  String lat;
  String long;
  String additionalInformation;
  String country;
  String city;
  int yearExperience;
  String status;
  String serviceType;
  String paymentStatus;
  int serviceId;
  String propertyType;
  DateTime? createdAt;
  DateTime? updatedAt;
  Provider provider;

  ProviderJobData({
    required this.id,
    required this.userId,
    required this.providerId,
    required this.serviceName,
    required this.description,
    required this.pricing,
    required this.duration,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.lat,
    required this.long,
    required this.additionalInformation,
    required this.country,
    required this.city,
    required this.yearExperience,
    required this.status,
    required this.serviceType,
    required this.paymentStatus,
    required this.serviceId,
    required this.propertyType,
    this.createdAt,
    this.updatedAt,
    required this.provider,
  });

  factory ProviderJobData.fromJson(Map<String, dynamic> json) => ProviderJobData(
    id: json["id"],
    userId: json["user_id"],
    providerId: json["provider_id"],
    serviceName: json["service_name"],
    description: json["description"],
    pricing: json["pricing"],
    duration: json["duration"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    location: json["location"],
    lat: json["lat"],
    long: json["long"],
    additionalInformation: json["additional_information"],
    country: json["country"],
    city: json["city"],
    yearExperience: json["year_experience"],
    status: json["status"],
    serviceType: json["service_type"],
    paymentStatus: json["payment_status"],
    serviceId: json["service_id"],
    propertyType: json["property_type"],
    createdAt: json["created_at"] != null
        ? DateTime.parse(json["created_at"])
        : null,
    updatedAt: json["updated_at"] != null
        ? DateTime.parse(json["updated_at"])
        : null,
    provider: Provider.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "provider_id": providerId,
    "service_name": serviceName,
    "description": description,
    "pricing": pricing,
    "duration": duration,
    "start_time": startTime,
    "end_time": endTime,
    "location": location,
    "lat": lat,
    "long": long,
    "additional_information": additionalInformation,
    "country": country,
    "city": city,
    "year_experience": yearExperience,
    "status": status,
    "service_type": serviceType,
    "payment_status": paymentStatus,
    "service_id": serviceId,
    "property_type": propertyType,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "provider": provider.toJson(),
  };
}

class Provider {
  int id;
  String fullName;
  String email;
  String phoneNumber;
  String role;
  String profileImage;
  DateTime createdAt;
  DateTime updatedAt;

  Provider({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.profileImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Provider.fromJson(Map<String, dynamic> json) => Provider(
    id: json["id"],
    fullName: json["full_name"],
    email: json["email"],
    phoneNumber: json["phone_number"],
    role: json["role"],
    profileImage: json["profile_image"] ?? "",
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "email": email,
    "phone_number": phoneNumber,
    "role": role,
    "profile_image": profileImage,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

