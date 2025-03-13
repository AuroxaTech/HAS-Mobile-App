// To parse this JSON data, do
//
//     final serviceRequest = serviceRequestFromJson(jsonString);

import 'dart:convert';

ServiceRequest serviceRequestFromJson(String str) =>
    ServiceRequest.fromJson(json.decode(str));

String serviceRequestToJson(ServiceRequest data) => json.encode(data.toJson());

// To parse this JSON data, do
// final serviceRequest = serviceRequestFromJson(jsonString);

class ServiceRequest {
  bool status;
  List<ServiceRequestProvider> data;
  String message;

  ServiceRequest({
    required this.status,
    required this.data,
    required this.message,
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) => ServiceRequest(
        status: json["status"],
        data: List<ServiceRequestProvider>.from(
            json["data"].map((x) => ServiceRequestProvider.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class ServiceRequestProvider {
  // Renamed from PendingJob and made generic to handle all job types
  int id;
  int userId;
  String
      serviceName; // From response, previously request details were nested. Using service_name directly
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
  dynamic cnicFrontPic; // dynamic to handle null
  dynamic cnicBackPic; // dynamic to handle null
  dynamic certification; // dynamic to handle null
  dynamic resume; // dynamic to handle null
  DateTime? createdAt;
  DateTime? updatedAt;
  String status;
  int? providerId; // Nullable as it can be null
  String serviceType;
  String paymentStatus;
  String postalCode;
  int isApplied;
  dynamic assignedAt; // dynamic to handle null
  dynamic completedAt; // dynamic to handle null
  int isFavorite;
  dynamic serviceId; // dynamic to handle null
  dynamic propertyType; // dynamic to handle null
  User user;
  List<dynamic>?
      serviceImages; // Assuming dynamic as type is not specified, based on [] in response
  List<dynamic>
      reviews; // Assuming dynamic as type is not specified, based on [] in response

  ServiceRequestProvider({
    // Renamed from PendingJob
    required this.id,
    required this.userId,
    required this.serviceName, // From response
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
    this.createdAt,
    this.updatedAt,
    required this.status,
    this.providerId,
    required this.serviceType,
    required this.paymentStatus,
    required this.postalCode,
    required this.isApplied,
    this.assignedAt,
    this.completedAt,
    required this.isFavorite,
    this.serviceId,
    this.propertyType,
    required this.user,
    this.serviceImages,
    required this.reviews,
  });

  factory ServiceRequestProvider.fromJson(Map<String, dynamic> json) =>
      ServiceRequestProvider(
        // Renamed from PendingJob
        id: json["id"],
        userId: json["user_id"],
        serviceName: json["service_name"] ?? "", // From response
        description: json["description"] ?? "",
        pricing: json["pricing"] ?? "",
        duration: json["duration"] ?? "",
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
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
        status: json["status"] ?? "",
        providerId: json["provider_id"],
        serviceType: json["service_type"] ?? "",
        paymentStatus: json["payment_status"] ?? "",
        postalCode: json["postal_code"] ?? "",
        isApplied: json["is_applied"] ?? 0,
        assignedAt: json["assigned_at"],
        completedAt: json["completed_at"],
        isFavorite: json["isFavorite"] ?? 0,
        serviceId: json["service_id"],
        propertyType: json["property_type"],
        user: User.fromJson(json["user"]),
        // serviceImages: json["service_images"] ?? [],
        reviews: json["reviews"] ?? [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "service_name": serviceName, // From response
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
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "status": status,
        "provider_id": providerId,
        "service_type": serviceType,
        "payment_status": paymentStatus,
        "postal_code": postalCode,
        "is_applied": isApplied,
        "assigned_at": assignedAt,
        "completed_at": completedAt,
        "isFavorite": isFavorite,
        "service_id": serviceId,
        "property_type": propertyType,
        "user": user.toJson(),
        // "service_images": List<dynamic>.from(serviceImages.map((x) => x.toJson())),
        "reviews": reviews,
      };
}

class PropertyType {
  int id;
  String name;
  dynamic createdBy;
  dynamic createdAt;
  dynamic updatedAt;

  PropertyType({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PropertyType.fromJson(Map<String, dynamic> json) => PropertyType(
        id: json["id"],
        name: json["name"],
        createdBy: json["created_by"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_by": createdBy,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Service {
  int id;
  int userId;
  String? serviceName;
  String? description;
  String pricing;
  String startTime;
  String endTime;
  String location;
  String lat;
  String long;
  String media;
  String additionalInformation;
  DateTime createdAt;
  DateTime updatedAt;

  Service({
    required this.id,
    required this.userId,
    required this.serviceName,
    required this.description,
    required this.pricing,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.lat,
    required this.long,
    required this.media,
    required this.additionalInformation,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        userId: json["user_id"],
        serviceName: json["service_name"],
        description: json["description"],
        pricing: json["pricing"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        location: json["location"],
        lat: json["lat"],
        long: json["long"],
        media: json["media"],
        additionalInformation: json["additional_information"] ?? "",
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "service_name": serviceName,
        "description": description,
        "pricing": pricing,
        "start_time": startTime,
        "end_time": endTime,
        "location": location,
        "lat": lat,
        "long": long,
        "media": media,
        "additional_information": additionalInformation,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class User {
  // Reusing existing User model, seems consistent
  int id;
  String fullName; // Changed from fullname to full_name in API response
  String email;
  String userName; // Changed from username to user_name in API response
  String phoneNumber;
  String role;
  dynamic emailVerifiedAt; // dynamic to handle null
  String address;
  String postalCode;
  String profileImage;
  String platform;
  String deviceToken;
  int approvedAt;
  String verificationToken;
  int isVerified;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    // Reusing existing User model
    required this.id,
    required this.fullName, // Changed from fullname
    required this.email,
    required this.userName, // Changed from username
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
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        // Reusing existing User model
        id: json["id"],
        fullName: json["full_name"] ?? "", // Changed from fullname
        email: json["email"] ?? "",
        userName: json["user_name"] ?? "", // Changed from username
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
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        // Reusing existing User model
        "id": id,
        "full_name": fullName, // Changed from fullname
        "email": email,
        "user_name": userName, // Changed from username
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
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class ServiceRequestUser {
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
  List<dynamic> favourites;
  List<dynamic> reviews;
  User user;

  ServiceRequestUser({
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
    required this.favourites,
    required this.reviews,
    required this.user,
  });

  factory ServiceRequestUser.fromJson(Map<String, dynamic> json) =>
      ServiceRequestUser(
        id: json["id"],
        userId: json["user_id"],
        serviceName: json["service_name"] ?? "",
        description: json["description"] ?? "",
        pricing: json["pricing"] ?? "0.00",
        duration: json["duration"] ?? "0",
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
            : [],
        favourites: json["favourites"] ?? [],
        reviews: json["reviews"] ?? [],
        user: User.fromJson(json["user"]),
      );

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
        "service_images":
            List<dynamic>.from(serviceImages.map((x) => x.toJson())),
        "favourites": favourites,
        "reviews": reviews,
        "user": user.toJson(),
      };
}

class PropertyTypeUser {
  int id;
  String name;
  dynamic createdBy;
  dynamic createdAt;
  dynamic updatedAt;

  PropertyTypeUser({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PropertyTypeUser.fromJson(Map<String, dynamic> json) =>
      PropertyTypeUser(
        id: json["id"],
        name: json["name"],
        createdBy: json["created_by"] ?? "",
        createdAt: json["created_at"] ?? "",
        updatedAt: json["updated_at"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_by": createdBy,
        "created_at": createdAt,
        "updated_at": updatedAt,
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
