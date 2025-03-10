// // To parse this JSON data, do
// //
// //     final serviceStatus = serviceStatusFromJson(jsonString);
//
// import 'dart:convert';
//
// ServiceStatus serviceStatusFromJson(String str) =>
//     ServiceStatus.fromJson(json.decode(str));
//
// String serviceStatusToJson(ServiceStatus data) => json.encode(data.toJson());
//
// class ServiceStatus {
//   bool status;
//   DataStatus data;
//   String message;
//
//   ServiceStatus({
//     required this.status,
//     required this.data,
//     required this.message,
//   });
//
//   factory ServiceStatus.fromJson(Map<String, dynamic> json) => ServiceStatus(
//         status: json["status"],
//         data: DataStatus.fromJson(json["data"]),
//         message: json["message"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "data": data.toJson(),
//         "message": message,
//       };
// }
//
// class DataStatus {
//   List<PendingJob> pendingJobs;
//   Pagination pendingJobsPagination;
//   List<CompletedJob> completedJobs;
//   Pagination completedJobsPagination;
//   List<RejectedJob> rejectedJobs;
//   Pagination rejectedJobsPagination;
//
//   DataStatus({
//     required this.pendingJobs,
//     required this.pendingJobsPagination,
//     required this.completedJobs,
//     required this.completedJobsPagination,
//     required this.rejectedJobs,
//     required this.rejectedJobsPagination,
//   });
//
//   factory DataStatus.fromJson(Map<String, dynamic> json) {
//     return DataStatus(
//       pendingJobs: _parseJobs<PendingJob>(
//           json['pending_jobs']?['data'] ?? [], PendingJob.fromJson),
//       pendingJobsPagination: Pagination.fromJson(json['pending_jobs'] ?? {}),
//       completedJobs: _parseJobs<CompletedJob>(
//           json['completed_jobs']?['data'] ?? [], CompletedJob.fromJson),
//       completedJobsPagination:
//           Pagination.fromJson(json['completed_jobs'] ?? {}),
//       rejectedJobs: _parseJobs<RejectedJob>(
//           json['rejected_jobs']?['data'] ?? [], RejectedJob.fromJson),
//       rejectedJobsPagination: Pagination.fromJson(json['rejected_jobs'] ?? {}),
//     );
//   }
//
//   static List<T> _parseJobs<T>(
//       List<dynamic> data, T Function(Map<String, dynamic>) fromJson) {
//     return data.map((x) => fromJson(x as Map<String, dynamic>)).toList();
//   }
//
//   Map<String, dynamic> toJson() => {
//         "pending_jobs": {
//           "data": List<dynamic>.from(pendingJobs.map((x) => x.toJson())),
//           "pagination": pendingJobsPagination.toJson(),
//         },
//         "completed_jobs": {
//           "data": List<dynamic>.from(completedJobs.map((x) => x.toJson())),
//           "pagination": completedJobsPagination.toJson(),
//         },
//         "rejected_jobs": {
//           "data": List<dynamic>.from(rejectedJobs.map((x) => x.toJson())),
//           "pagination": rejectedJobsPagination.toJson(),
//         },
//       };
// }
//
// class PendingJob {
//   int id;
//   int userId;
//   int requestId;
//   int providerId;
//   String status;
//   DateTime? createdAt; // Nullable to handle null values
//   DateTime? updatedAt; // Nullable to handle null values
//   Request request;
//   Provider provider;
//   Service? service;
//
//   PendingJob({
//     required this.id,
//     required this.userId,
//     required this.requestId,
//     required this.providerId,
//     required this.status,
//     this.createdAt, // Nullable
//     this.updatedAt, // Nullable
//     required this.request,
//     required this.provider,
//     this.service,
//   });
//
//   factory PendingJob.fromJson(Map<String, dynamic> json) => PendingJob(
//         id: json["id"],
//         userId: json["user_id"],
//         requestId: json["request_id"] ?? 0,
//         providerId: json["provider_id"],
//         status: json["status"],
//         createdAt: json["created_at"] != null
//             ? DateTime.parse(json["created_at"])
//             : null, // Handle null case
//         updatedAt: json["updated_at"] != null
//             ? DateTime.parse(json["updated_at"])
//             : null, // Handle null case
//         request: Request.fromJson(json["request"]),
//         provider: Provider.fromJson(json["provider"]),
//         service: json["service"] == null
//             ? null
//             : Service.fromJson(json["service"] as Map<String, dynamic>),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "user_id": userId,
//         "request_id": requestId,
//         "provider_id": providerId,
//         "status": status,
//         "created_at": createdAt?.toIso8601String(), // Handle null case
//         "updated_at": updatedAt?.toIso8601String(), // Handle null case
//         "request": request.toJson(),
//         "provider": provider.toJson(),
//         "service": service?.toJson(),
//       };
// }
//
// class CompletedJob {
//   int id;
//   int userId;
//   int requestId;
//   int providerId;
//   int status;
//   DateTime createdAt;
//   DateTime updatedAt;
//   Request request;
//   Provider provider;
//   Service? service;
//
//   CompletedJob(
//       {required this.id,
//       required this.userId,
//       required this.requestId,
//       required this.providerId,
//       required this.status,
//       required this.createdAt,
//       required this.updatedAt,
//       required this.request,
//       required this.provider,
//       required this.service});
//
//   factory CompletedJob.fromJson(Map<String, dynamic> json) => CompletedJob(
//         id: json["id"],
//         userId: json["user_id"],
//         requestId: json["request_id"],
//         providerId: json["provider_id"],
//         status: json["status"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         request: Request.fromJson(json["request"]),
//         provider: Provider.fromJson(json["provider"]),
//         service:
//             json["service"] == null ? null : Service.fromJson(json["service"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "user_id": userId,
//         "request_id": requestId,
//         "provider_id": providerId,
//         "status": status,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//         "request": request.toJson(),
//         "provider": provider.toJson(),
//         "service": service,
//       };
// }
//
// class RejectedJob {
//   int id;
//   int userId;
//   int requestId;
//   int providerId;
//   int status;
//   DateTime createdAt;
//   DateTime updatedAt;
//   Request request;
//   Provider provider;
//   Service? service;
//
//   RejectedJob(
//       {required this.id,
//       required this.userId,
//       required this.requestId,
//       required this.providerId,
//       required this.status,
//       required this.createdAt,
//       required this.updatedAt,
//       required this.request,
//       required this.provider,
//       required this.service});
//
//   factory RejectedJob.fromJson(Map<String, dynamic> json) => RejectedJob(
//         id: json["id"],
//         userId: json["user_id"],
//         requestId: json["request_id"],
//         providerId: json["provider_id"],
//         status: json["status"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         request: Request.fromJson(json["request"]),
//         provider: Provider.fromJson(json["provider"]),
//         service:
//             json["service"] == null ? null : Service.fromJson(json["service"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "user_id": userId,
//         "request_id": requestId,
//         "provider_id": providerId,
//         "status": status,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//         "request": request.toJson(),
//         "provider": provider.toJson(),
//         "service": service,
//       };
// }
//
// class Provider {
//   int id;
//   String fullname;
//   String email;
//   String phoneNumber;
//   int roleId;
//   String profileimage;
//   DateTime createdAt;
//   DateTime updatedAt;
//
//   Provider({
//     required this.id,
//     required this.fullname,
//     required this.email,
//     required this.phoneNumber,
//     required this.roleId,
//     required this.profileimage,
//     required this.createdAt,
//     required this.updatedAt,
//   });
//
//   factory Provider.fromJson(Map<String, dynamic> json) => Provider(
//         id: json["id"],
//         fullname: json["fullname"],
//         email: json["email"],
//         phoneNumber: json["phone_number"] ?? "",
//         roleId: json["role_id"],
//         profileimage: json["profileimage"] ?? "",
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "fullname": fullname,
//         "email": email,
//         "phone_number": phoneNumber,
//         "role_id": roleId,
//         "profileimage": profileimage,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//       };
// }
//
// class Request {
//   int id;
//   int userId;
//   int serviceproviderId;
//   int serviceId;
//   String address;
//   String lat;
//   String long;
//   int propertyType;
//   String price;
//   String date;
//   String time;
//   String description;
//   String additionalInfo;
//   int approved;
//   int decline;
//   DateTime createdAt;
//   DateTime updatedAt;
//   Service service;
//
//   Request({
//     required this.id,
//     required this.userId,
//     required this.serviceproviderId,
//     required this.serviceId,
//     required this.address,
//     required this.lat,
//     required this.long,
//     required this.propertyType,
//     required this.price,
//     required this.date,
//     required this.time,
//     required this.description,
//     required this.additionalInfo,
//     required this.approved,
//     required this.decline,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.service,
//   });
//
//   factory Request.fromJson(Map<String, dynamic> json) => Request(
//         id: json["id"],
//         userId: json["user_id"],
//         serviceproviderId: json["serviceprovider_id"],
//         serviceId: json["service_id"],
//         address: json["address"],
//         lat: json["lat"],
//         long: json["long"],
//         propertyType: json["property_type"],
//         price: json["price"],
//         date: json["date"],
//         time: json["time"],
//         description: json["description"],
//         additionalInfo: json["additional_info"] ?? "",
//         approved: json["approved"],
//         decline: json["decline"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         service: Service.fromJson(json["service"] ?? {}),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "user_id": userId,
//         "serviceprovider_id": serviceproviderId,
//         "service_id": serviceId,
//         "address": address,
//         "lat": lat,
//         "long": long,
//         "property_type": propertyType,
//         "price": price,
//         "date": date,
//         "time": time,
//         "description": description,
//         "additional_info": additionalInfo,
//         "approved": approved,
//         "decline": decline,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//         "service": service.toJson(),
//       };
// }
//
// class Service {
//   int id;
//   int userId;
//   String serviceName;
//   String description;
//   dynamic categoryId;
//   String pricing;
//   dynamic durationId;
//   String startTime;
//   String endTime;
//   String location;
//   String lat;
//   String long;
//   String media;
//   String additionalInformation;
//   String country;
//   String city;
//   DateTime? createdAt; // Nullable
//   DateTime? updatedAt; // Nullable
//
//   Service({
//     required this.id,
//     required this.userId,
//     required this.serviceName,
//     required this.description,
//     required this.categoryId,
//     required this.pricing,
//     required this.durationId,
//     required this.startTime,
//     required this.endTime,
//     required this.location,
//     required this.lat,
//     required this.long,
//     required this.media,
//     required this.additionalInformation,
//     required this.country,
//     required this.city,
//     this.createdAt, // Nullable
//     this.updatedAt, // Nullable
//   });
//
//   factory Service.fromJson(Map<String, dynamic> json) => Service(
//         id: json["id"] ?? 0,
//         userId: json["user_id"] ?? 0,
//         serviceName: json["service_name"] ?? "",
//         description: json["description"] ?? "",
//         categoryId: json["category_id"] ?? 0,
//         pricing: json["pricing"] ?? "",
//         durationId: json["duration_id"] ?? 0,
//         startTime: json["start_time"] ?? "",
//         endTime: json["end_time"] ?? "",
//         location: json["location"] ?? "",
//         lat: json["lat"] ?? "",
//         long: json["long"] ?? "",
//         media: json["media"] ?? "",
//         additionalInformation: json["additional_information"] ?? "",
//         country: json["country"] ?? "",
//         city: json["city"] ?? "",
//         createdAt: json["created_at"] != null
//             ? DateTime.parse(json["created_at"])
//             : null, // Handle null value
//         updatedAt: json["updated_at"] != null
//             ? DateTime.parse(json["updated_at"])
//             : null, // Handle null value
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "user_id": userId,
//         "service_name": serviceName,
//         "description": description,
//         "category_id": categoryId,
//         "pricing": pricing,
//         "duration_id": durationId,
//         "start_time": startTime,
//         "end_time": endTime,
//         "location": location,
//         "lat": lat,
//         "long": long,
//         "media": media,
//         "additional_information": additionalInformation,
//         "country": country,
//         "city": city,
//         "created_at": createdAt?.toIso8601String(), // Nullable
//         "updated_at": updatedAt?.toIso8601String(), // Nullable
//       };
// }
//
// class Pagination {
//   final int currentPage;
//   final int lastPage;
//   final int perPage;
//   final int total;
//   final String? nextPageUrl;
//   final String? prevPageUrl;
//
//   Pagination({
//     required this.currentPage,
//     required this.lastPage,
//     required this.perPage,
//     required this.total,
//     this.nextPageUrl,
//     this.prevPageUrl,
//   });
//
//   factory Pagination.fromJson(Map<String, dynamic> json) {
//     return Pagination(
//       currentPage:
//           json['current_page'] as int? ?? 1, // Provide a default value if null
//       lastPage:
//           json['last_page'] as int? ?? 1, // Provide a default value if null
//       perPage: json['per_page'] as int? ?? 0, // Provide a default value if null
//       total: json['total'] as int? ?? 0, // Provide a default value if null
//       nextPageUrl: json['next_page_url'] as String?,
//       prevPageUrl: json['prev_page_url'] as String?,
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//         "current_page": currentPage,
//         "last_page": lastPage,
//         "per_page": perPage,
//         "total": total,
//         "next_page_url": nextPageUrl,
//         "prev_page_url": prevPageUrl,
//       };
// }



import 'dart:convert';

ServiceStatus serviceStatusFromJson(String str) =>
    ServiceStatus.fromJson(json.decode(str));

String serviceStatusToJson(ServiceStatus data) => json.encode(data.toJson());

class ServiceStatus {
  bool success; // Changed 'status' to 'success' to match response
  Payload data; // Changed 'DataStatus' to 'Payload' and 'data' to 'payload' in response
  String message;

  ServiceStatus({
    required this.success, // Changed 'status' to 'success'
    required this.data, // Changed 'DataStatus' to 'Payload'
    required this.message,
  });

  factory ServiceStatus.fromJson(Map<String, dynamic> json) => ServiceStatus(
    success: json["success"], // Changed 'status' to 'success'
    data: Payload.fromJson(json["payload"]), // Changed 'DataStatus' to 'Payload' and 'data' to 'payload' in response
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success, // Changed 'status' to 'success'
    "payload": data.toJson(), // Changed 'DataStatus' to 'Payload' and 'data' to 'payload' in response
    "message": message,
  };
}

class Payload { // Renamed from DataStatus to Payload
  JobsData pendingJobs; // Renamed from List<PendingJob> and Pagination to JobsData for better structure
  JobsData completedJobs; // Renamed from List<CompletedJob> and Pagination to JobsData for better structure
  JobsData cancelledJobs; // Renamed from List<CancelledJob> and Pagination to JobsData for better structure (New)
  JobsData rejectedJobs; // Renamed from List<RejectedJob> and Pagination to JobsData for better structure
  JobsData acceptedJobs; // Renamed from List<AcceptedJob> and Pagination to JobsData for better structure (New)

  Payload({ // Renamed from DataStatus to Payload
    required this.pendingJobs,
    required this.completedJobs,
    required this.cancelledJobs, // New
    required this.rejectedJobs,
    required this.acceptedJobs, // New
  });

  factory Payload.fromJson(Map<String, dynamic> json) { // Renamed from DataStatus to Payload
    return Payload( // Renamed from DataStatus to Payload
      pendingJobs: JobsData.fromJson(json['pending_jobs'] ?? {}), // Wrapped in JobsData
      completedJobs: JobsData.fromJson(json['completed_jobs'] ?? {}), // Wrapped in JobsData
      cancelledJobs: JobsData.fromJson(json['cancelled_jobs'] ?? {}), // Wrapped in JobsData (New)
      rejectedJobs: JobsData.fromJson(json['rejected_jobs'] ?? {}), // Wrapped in JobsData
      acceptedJobs: JobsData.fromJson(json['accepted_jobs'] ?? {}), // Wrapped in JobsData (New)
    );
  }

  Map<String, dynamic> toJson() => {
    "pending_jobs": pendingJobs.toJson(), // Wrapped in JobsData
    "completed_jobs": completedJobs.toJson(), // Wrapped in JobsData
    "cancelled_jobs": cancelledJobs.toJson(), // Wrapped in JobsData (New)
    "rejected_jobs": rejectedJobs.toJson(), // Wrapped in JobsData
    "accepted_jobs": acceptedJobs.toJson(), // Wrapped in JobsData (New)
  };
}

class JobsData { // New class to encapsulate jobs and pagination
  List<Job> data; // Changed from specific job types to generic Job
  Pagination pagination;

  JobsData({
    required this.data,
    required this.pagination,
  });

  factory JobsData.fromJson(Map<String, dynamic> json) {
    return JobsData(
      data: _parseJobs<Job>(json['data'] ?? [], Job.fromJson), // Using generic Job model
      pagination: Pagination.fromJson(json),
    );
  }

  static List<T> _parseJobs<T>(
      List<dynamic> data, T Function(Map<String, dynamic>) fromJson) {
    return data.map((x) => fromJson(x as Map<String, dynamic>)).toList();
  }

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "pagination": pagination.toJson(),
  };
}


class Pagination {
  int currentPage;
  int lastPage;
  String? firstPageUrl;
  String? lastPageUrl;
  String? path;
  int perPage;
  int total;
  String? nextPageUrl;
  String? prevPageUrl;
  int? from; // Added from and to, and made from nullable
  int? to;   // Added from and to, and made to nullable


  Pagination({
    required this.currentPage,
    required this.lastPage,
    this.firstPageUrl,
    this.lastPageUrl,
    this.path,
    required this.perPage,
    required this.total,
    this.nextPageUrl,
    this.prevPageUrl,
    this.from,
    this.to,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    currentPage: json["current_page"] ?? 0,
    lastPage: json["last_page"] ?? 0,
    firstPageUrl: json["first_page_url"],
    lastPageUrl: json["last_page_url"],
    path: json["path"],
    perPage: json["per_page"] ?? 0,
    total: json["total"] ?? 0,
    nextPageUrl: json["next_page_url"],
    prevPageUrl: json["prev_page_url"],
    from: json["from"],
    to: json["to"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "last_page": lastPage,
    "first_page_url": firstPageUrl,
    "last_page_url": lastPageUrl,
    "path": path,
    "per_page": perPage,
    "total": total,
    "next_page_url": nextPageUrl,
    "prev_page_url": prevPageUrl,
    "from": from,
    "to": to,
  };
}


class Job { // Renamed from PendingJob and made generic to handle all job types
  int id;
  int userId;
  String serviceName; // From response, previously request details were nested. Using service_name directly
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
  List<dynamic> serviceImages; // Assuming dynamic as type is not specified, based on [] in response
  List<dynamic> reviews; // Assuming dynamic as type is not specified, based on [] in response


  Job({ // Renamed from PendingJob
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
    required this.serviceImages,
    required this.reviews,
  });

  factory Job.fromJson(Map<String, dynamic> json) => Job( // Renamed from PendingJob
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
    createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
    updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : null,
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
    serviceImages: json["service_images"] ?? [],
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
    "service_images": serviceImages,
    "reviews": reviews,
  };
}


class User { // Reusing existing User model, seems consistent
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


  User({ // Reusing existing User model
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

  factory User.fromJson(Map<String, dynamic> json) => User( // Reusing existing User model
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
    createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
    updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : null,
  );

  Map<String, dynamic> toJson() => { // Reusing existing User model
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

