// To parse this JSON data, do
//
//     final getServices = getServicesFromJson(jsonString);

import 'dart:convert';

GetServices getServicesFromJson(String str) =>
    GetServices.fromJson(json.decode(str));

String getServicesToJson(GetServices data) => json.encode(data.toJson());

class GetServices {
  bool success;
  String message;
  Payload payload;

  GetServices({
    required this.success,
    required this.message,
    required this.payload,
  });

  factory GetServices.fromJson(Map<String, dynamic> json) => GetServices(
        success: json["success"],
        message: json["message"],
        payload: Payload.fromJson(json["payload"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "payload": payload.toJson(),
      };
}

class Payload {
  int currentPage;
  List<Services> data;
  String firstPageUrl;
  int? from;
  int lastPage;
  String lastPageUrl;
  List<Link> links;
  String? nextPageUrl;
  String path;
  int perPage;
  String? prevPageUrl;
  int? to;
  int total;

  Payload({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    this.to,
    required this.total,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        currentPage: json["current_page"],
        data:
            List<Services>.from(json["data"].map((x) => Services.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Link {
  String? url;
  String label;
  bool active;

  Link({
    this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}

class Services {
  int id;
  int userId;
  String serviceName;
  String description;
  String pricing;
  String? duration;
  String startTime;
  String endTime;
  String location;
  String? lat;
  String? long;
  String? additionalInformation;
  String? country;
  String? city;
  int? yearExperience;
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
  List<ServiceImage> serviceImages;

  Services({
    required this.id,
    required this.userId,
    required this.serviceName,
    required this.description,
    required this.pricing,
    this.duration,
    required this.startTime,
    required this.endTime,
    required this.location,
    this.lat,
    this.long,
    this.additionalInformation,
    this.country,
    this.city,
    this.yearExperience,
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
    required this.serviceImages,
  });

  factory Services.fromJson(Map<String, dynamic> json) => Services(
        id: json["id"],
        userId: json["user_id"],
        serviceName: json["service_name"],
        description: json["description"],
        pricing: json["pricing"],
        duration: json["duration"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        location: json["location"],
        lat: json["lat"]?.toString(),
        long: json["long"]?.toString(),
        additionalInformation: json["additional_information"],
        country: json["country"],
        city: json["city"],
        yearExperience: json["year_experience"],
        cnicFrontPic: json["cnic_front_pic"],
        cnicBackPic: json["cnic_back_pic"],
        certification: json["certification"],
        resume: json["resume"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        status: json["status"],
        providerId: json["provider_id"],
        serviceType: json["service_type"],
        paymentStatus: json["payment_status"],
        postalCode: json["postal_code"],
        isApplied: json["is_applied"],
        assignedAt: json["assigned_at"] == null ? null : DateTime.parse(json["assigned_at"]),
        completedAt: json["completed_at"] == null ? null : DateTime.parse(json["completed_at"]),
        serviceImages: List<ServiceImage>.from(json["service_images"].map((x) => ServiceImage.fromJson(x))),
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
        "service_images": List<dynamic>.from(serviceImages.map((x) => x.toJson())),
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
        id: json["id"],
        serviceId: json["service_id"],
        imagePath: json["image_path"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_id": serviceId,
        "image_path": imagePath,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
