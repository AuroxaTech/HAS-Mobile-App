// To parse this JSON data, do
//
//     final serviceStatus = serviceStatusFromJson(jsonString);

import 'dart:convert';

import 'package:property_app/models/service_provider_model/service_request_model.dart';

import '../authentication_model/user_model.dart';

ServiceStatus serviceStatusFromJson(String str) => ServiceStatus.fromJson(json.decode(str));

String serviceStatusToJson(ServiceStatus data) => json.encode(data.toJson());

class ServiceStatus {
  bool status;
  DataStatus data;
  String message;

  ServiceStatus({
    required this.status,
    required this.data,
    required this.message,
  });

  factory ServiceStatus.fromJson(Map<String, dynamic> json) => ServiceStatus(
    status: json["status"],
    data: DataStatus.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
    "message": message,
  };
}

class DataStatus {
  List<PendingJob> pendingJobs;
  Pagination pendingJobsPagination;
  List<CompletedJob> completedJobs;
  Pagination completedJobsPagination;
  List<RejectedJob> rejectedJobs;
  Pagination rejectedJobsPagination;

  DataStatus({
    required this.pendingJobs,
    required this.pendingJobsPagination,
    required this.completedJobs,
    required this.completedJobsPagination,
    required this.rejectedJobs,
    required this.rejectedJobsPagination,
  });

  factory DataStatus.fromJson(Map<String, dynamic> json) {
    return DataStatus(
      pendingJobs: _parseJobs<PendingJob>(json['pending_jobs']?['data'] ?? [], PendingJob.fromJson),
      pendingJobsPagination: Pagination.fromJson(json['pending_jobs'] ?? {}),
      completedJobs: _parseJobs<CompletedJob>(json['completed_jobs']?['data'] ?? [], CompletedJob.fromJson),
      completedJobsPagination: Pagination.fromJson(json['completed_jobs'] ?? {}),
      rejectedJobs: _parseJobs<RejectedJob>(json['rejected_jobs']?['data'] ?? [], RejectedJob.fromJson),
      rejectedJobsPagination: Pagination.fromJson(json['rejected_jobs'] ?? {}),
    );
  }

  static List<T> _parseJobs<T>(List<dynamic> data, T Function(Map<String, dynamic>) fromJson) {
    return data.map((x) => fromJson(x as Map<String, dynamic>)).toList();
  }

  Map<String, dynamic> toJson() => {
    "pending_jobs": {
      "data": List<dynamic>.from(pendingJobs.map((x) => x.toJson())),
      "pagination": pendingJobsPagination.toJson(),
    },
    "completed_jobs": {
      "data": List<dynamic>.from(completedJobs.map((x) => x.toJson())),
      "pagination": completedJobsPagination.toJson(),
    },
    "rejected_jobs": {
      "data": List<dynamic>.from(rejectedJobs.map((x) => x.toJson())),
      "pagination": rejectedJobsPagination.toJson(),
    },
  };
}

class PendingJob {
  int id;
  String userId;
  String requestId;
  String providerId;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  Request request;
  Provider provider;
  Service? service;

  PendingJob({
    required this.id,
    required this.userId,
    required this.requestId,
    required this.providerId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.request,
    required this.provider,
    required this.service
  });

  factory PendingJob.fromJson(Map<String, dynamic> json) => PendingJob(
    id: json["id"],
    userId: json["user_id"],
    requestId: json["request_id"],
    providerId: json["provider_id"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    request: Request.fromJson(json["request"]),
    provider: Provider.fromJson(json["provider"]),
    service: json["service"] == null  ? null : Service.fromJson(json["service"] as Map<String, dynamic>),


  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "request_id": requestId,
    "provider_id": providerId,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "request": request.toJson(),
    "provider": provider.toJson(),
    "service": service?.toJson(),
  };
}

class CompletedJob {
  int id;
  String userId;
  String requestId;
  String providerId;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  Request request;
  Provider provider;
  Service? service;

  CompletedJob({
    required this.id,
    required this.userId,
    required this.requestId,
    required this.providerId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.request,
    required this.provider,
    required this.service
  });

  factory CompletedJob.fromJson(Map<String, dynamic> json) => CompletedJob(
    id: json["id"],
    userId: json["user_id"],
    requestId: json["request_id"],
    providerId: json["provider_id"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    request: Request.fromJson(json["request"]),
    provider: Provider.fromJson(json["provider"]),
    service: json["service"] == null ? null : Service.fromJson(json["service"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "request_id": requestId,
    "provider_id": providerId,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "request": request.toJson(),
    "provider": provider.toJson(),
    "service": service,
  };
}

class RejectedJob {
  int id;
  String userId;
  String requestId;
  String providerId;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  Request request;
  Provider provider;
  Service? service;

  RejectedJob({
    required this.id,
    required this.userId,
    required this.requestId,
    required this.providerId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.request,
    required this.provider,
    required this.service
  });

  factory RejectedJob.fromJson(Map<String, dynamic> json) => RejectedJob(
    id: json["id"],
    userId: json["user_id"],
    requestId: json["request_id"],
    providerId: json["provider_id"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    request: Request.fromJson(json["request"]),
    provider: Provider.fromJson(json["provider"]),
    service: json["service"] == null ? null : Service.fromJson(json["service"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "request_id": requestId,
    "provider_id": providerId,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "request": request.toJson(),
    "provider": provider.toJson(),
    "service": service,
  };
}

class Provider {
  int id;
  String fullname;
  String email;
  String phoneNumber;
  String roleId;
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
    profileimage: json["profileimage"] ?? "",
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
  String userId;
  String serviceproviderId;
  String serviceId;
  String address;
  String lat;
  String long;
  String propertyType;
  String price;
  String date;
  String time;
  String description;
  String additionalInfo;
  String approved;
  String decline;
  DateTime createdAt;
  DateTime updatedAt;
  Service service;

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
    service: Service.fromJson(json["service"]),
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
    "service": service.toJson(),
  };
}

class Service {
  int id;
  String userId;
  String serviceName;
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
    additionalInformation: json["additional_information"],
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

class Pagination {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final String? nextPageUrl;
  final String? prevPageUrl;

  Pagination({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'] as int? ?? 1,  // Provide a default value if null
      lastPage: json['last_page'] as int? ?? 1,        // Provide a default value if null
      perPage: json['per_page'] as int? ?? 0,          // Provide a default value if null
      total: json['total'] as int? ?? 0,               // Provide a default value if null
      nextPageUrl: json['next_page_url'] as String?,
      prevPageUrl: json['prev_page_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "last_page": lastPage,
    "per_page": perPage,
    "total": total,
    "next_page_url": nextPageUrl,
    "prev_page_url": prevPageUrl,
  };
}