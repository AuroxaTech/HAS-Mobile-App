// To parse this JSON data, do
//
//     final calendarService = calendarServiceFromJson(jsonString);

import 'dart:convert';

CalendarService calendarServiceFromJson(String str) =>
    CalendarService.fromJson(json.decode(str));

String calendarServiceToJson(CalendarService data) =>
    json.encode(data.toJson());

class CalendarService {
  bool status;
  List<CalendarData> data;
  String message;

  CalendarService({
    required this.status,
    required this.data,
    required this.message,
  });

  factory CalendarService.fromJson(Map<String, dynamic> json) =>
      CalendarService(
        status: json["status"],
        data: List<CalendarData>.from(
            json["data"].map((x) => CalendarData.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class CalendarData {
  int id;
  int userId;
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
  String? cnicFrontPic;
  String? cnicBackPic;
  String? certification;
  String? resume;
  DateTime createdAt;
  DateTime updatedAt;
  String status;
  int? providerId;
  String serviceType;
  String paymentStatus;
  String? postalCode;
  int isApplied;
  DateTime? assignedAt;
  DateTime? completedAt;
  int isFavorite;
  int? serviceId;
  String? propertyType;
  List<ServiceImage> serviceImages;
  List<dynamic> reviews;
  User user;

  CalendarData({
    required this.id,
    required this.userId,
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
    this.cnicFrontPic,
    this.cnicBackPic,
    this.certification,
    this.resume,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    this.providerId,
    required this.serviceType,
    required this.paymentStatus,
    this.postalCode,
    required this.isApplied,
    this.assignedAt,
    this.completedAt,
    required this.isFavorite,
    this.serviceId,
    this.propertyType,
    required this.serviceImages,
    required this.reviews,
    required this.user,
  });

  factory CalendarData.fromJson(Map<String, dynamic> json) {
    return CalendarData(
      id: json["id"],
      userId: json["user_id"],
      serviceName: json["service_name"] ?? "",
      description: json["description"] ?? "",
      pricing: json["pricing"] ?? "0.00",
      duration: json["duration"] ?? "Duration Not Available",
      startTime: json["start_time"] ?? "",
      endTime: json["end_time"] ?? "",
      location: json["location"] ?? "",
      lat: json["lat"] ?? "",
      long: json["long"] ?? "",
      additionalInformation: json["additional_information"] ?? "",
      country: json["country"] ?? "",
      city: json["city"] ?? "",
      yearExperience: json["year_experience"] ?? 0,
      cnicFrontPic: json["cnic_front_pic"],
      cnicBackPic: json["cnic_back_pic"],
      certification: json["certification"],
      resume: json["resume"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      status: json["status"] ?? "pending",
      providerId: json["provider_id"],
      serviceType: json["service_type"] ?? "request",
      paymentStatus: json["payment_status"] ?? "pending",
      postalCode: json["postal_code"],
      isApplied: json["is_applied"] ?? 0,
      assignedAt: json["assigned_at"] != null
          ? DateTime.parse(json["assigned_at"])
          : null,
      completedAt: json["completed_at"] != null
          ? DateTime.parse(json["completed_at"])
          : null,
      isFavorite: json["isFavorite"] ?? 0,
      serviceId: json["service_id"],
      propertyType: json["property_type"],
      serviceImages: json["service_images"] != null
          ? List<ServiceImage>.from(
          json["service_images"].map((x) => ServiceImage.fromJson(x)))
          : [],      reviews: json["reviews"] ?? [],
      user: User.fromJson(json["user"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
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
        "cnic_front_pic": cnicFrontPic,
        "cnic_back_pic": cnicBackPic,
        "certification": certification,
        "resume": resume,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "status": status,
        "provider_id": providerId,
        "service_type": serviceType,
        "payment_status": paymentStatus,
        "postal_code": postalCode,
        "is_applied": isApplied,
        "assigned_at": assignedAt?.toIso8601String(),
        "completed_at": completedAt?.toIso8601String(),
        "isFavorite": isFavorite,
        "service_id": serviceId,
        "property_type": propertyType,
        "service_images": List<dynamic>.from(
            serviceImages.map((x) => x is ServiceImage ? x.toJson() : x)),
        "reviews": reviews,
        "user": user.toJson(),
      };
}

class User {
  int id;
  String fullName;
  String email;
  String userName;
  String phoneNumber;
  String role;
  dynamic emailVerifiedAt;
  String address;
  String postalCode;
  String profileImage;
  String platform;
  String deviceToken;
  int approvedAt;
  String verificationToken;
  int isVerified;
  DateTime createdAt;
  DateTime updatedAt;

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
    required this.profileImage,
    required this.platform,
    required this.deviceToken,
    required this.approvedAt,
    required this.verificationToken,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        fullName: json["full_name"] ?? "",
        email: json["email"] ?? "",
        userName: json["user_name"] ?? "",
        phoneNumber: json["phone_number"] ?? "",
        role: json["role"] ?? "",
        emailVerifiedAt: json["email_verified_at"],
        address: json["address"] ?? "",
        postalCode: json["postal_code"] ?? "",
        profileImage: json["profile_image"] ?? "",
        platform: json["platform"] ?? "",
        deviceToken: json["device_token"] ?? "",
        approvedAt: json["approved_at"] ?? 0,
        verificationToken: json["verification_token"] ?? "",
        isVerified: json["is_verified"] ?? 0,
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "email": email,
        "user_name": userName,
        "phone_number": phoneNumber,
        "role": role,
        "email_verified_at": emailVerifiedAt,
        "address": address,
        "postal_code": postalCode,
        "profile_image": profileImage,
        "platform": platform,
        "device_token": deviceToken,
        "approved_at": approvedAt,
        "verification_token": verificationToken,
        "is_verified": isVerified,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Provider {
  int id;
  String fullname;
  String email;
  String phoneNumber;
  int roleId;
  String profileimage;
  DateTime createdAt;
  DateTime updatedAt;

  Provider({
    required this.id,
    required this.fullname,
    required this.email,
    required this.phoneNumber,
    required this.roleId,
    required this.profileimage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Provider.fromJson(Map<String, dynamic> json) => Provider(
        id: json["id"],
        fullname: json["fullname"],
        email: json["email"],
        phoneNumber: json["phone_number"] ?? "",
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

class Request {
  int id;
  int userId;
  int serviceproviderId;
  int serviceId;
  String address;
  String lat;
  String long;
  int propertyType;
  String price;
  String date;
  String time;
  String description;
  String additionalInfo;
  int approved;
  int decline;
  DateTime createdAt;
  DateTime updatedAt;
  Service? service;

  Request({
    required this.id,
    required this.userId,
    required this.serviceproviderId,
    required this.serviceId,
    required this.address,
    required this.lat,
    required this.long,
    required this.propertyType,
    required this.price,
    required this.date,
    required this.time,
    required this.description,
    required this.additionalInfo,
    required this.approved,
    required this.decline,
    required this.createdAt,
    required this.updatedAt,
    required this.service,
  });

  factory Request.fromJson(Map<String, dynamic> json) => Request(
        id: json["id"],
        userId: json["user_id"],
        serviceproviderId: json["serviceprovider_id"],
        serviceId: json["service_id"],
        address: json["address"],
        lat: json["lat"],
        long: json["long"],
        propertyType: json["property_type"],
        price: json["price"],
        date: json["date"],
        time: json["time"],
        description: json["description"],
        additionalInfo: json["additional_info"] ?? "",
        approved: json["approved"],
        decline: json["decline"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        service: json["service"] == null
            ? null
            : Service.fromJson(json["service"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "serviceprovider_id": serviceproviderId,
        "service_id": serviceId,
        "address": address,
        "lat": lat,
        "long": long,
        "property_type": propertyType,
        "price": price,
        "date": date,
        "time": time,
        "description": description,
        "additional_info": additionalInfo,
        "approved": approved,
        "decline": decline,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "service": service,
      };
}

class Service {
  int id;
  int userId;
  String? serviceName;
  String description;
  dynamic categoryId;
  String pricing;
  dynamic durationId;
  String startTime;
  String endTime;
  String location;
  String lat;
  String long;
  String media;
  String additionalInformation;
  String country;
  String city;
  DateTime createdAt;
  DateTime updatedAt;

  Service({
    required this.id,
    required this.userId,
    required this.serviceName,
    required this.description,
    required this.categoryId,
    required this.pricing,
    required this.durationId,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.lat,
    required this.long,
    required this.media,
    required this.additionalInformation,
    required this.country,
    required this.city,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        userId: json["user_id"],
        serviceName: json["service_name"],
        description: json["description"],
        categoryId: json["category_id"],
        pricing: json["pricing"],
        durationId: json["duration_id"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        location: json["location"],
        lat: json["lat"],
        long: json["long"],
        media: json["media"],
        additionalInformation: json["additional_information"] ?? "",
        country: json["country"],
        city: json["city"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "service_name": serviceName,
        "description": description,
        "category_id": categoryId,
        "pricing": pricing,
        "duration_id": durationId,
        "start_time": startTime,
        "end_time": endTime,
        "location": location,
        "lat": lat,
        "long": long,
        "media": media,
        "additional_information": additionalInformation,
        "country": country,
        "city": city,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class ServiceImage {
  int id;
  int serviceId;
  String imagePath;
  DateTime createdAt;
  DateTime updatedAt;

  ServiceImage({
    required this.id,
    required this.serviceId,
    required this.imagePath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceImage.fromJson(Map<String, dynamic> json) => ServiceImage(
        id: json["id"] ?? 0,
        serviceId: json["service_id"] ?? 0,
        imagePath: json["image_path"] ?? "",
        createdAt: DateTime.parse(
            json["created_at"] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(
            json["updated_at"] ?? DateTime.now().toIso8601String()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_id": serviceId,
        "image_path": imagePath,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
