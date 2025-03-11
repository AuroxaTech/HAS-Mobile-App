// To parse this JSON data, do
//
//     final favorite = favoriteFromJson(jsonString);

import 'dart:convert';

FavoriteResponse favoriteFromJson(String str) => FavoriteResponse.fromJson(json.decode(str));

String favoriteToJson(FavoriteResponse data) => json.encode(data.toJson());

class FavoriteResponse {
  bool success;
  String message;
  FavoritePayload payload;

  FavoriteResponse({
    required this.success,
    required this.message,
    required this.payload,
  });

  factory FavoriteResponse.fromJson(Map<String, dynamic> json) => FavoriteResponse(
    success: json["success"] ?? false,
    message: json["message"] ?? "",
    payload: FavoritePayload.fromJson(json["payload"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "payload": payload.toJson(),
  };
}

class FavoritePayload {
  int currentPage;
  List<FavoriteItem> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  List<Link> links;
  String? nextPageUrl;
  String path;
  int perPage;
  String? prevPageUrl;
  int? to;
  int total;

  FavoritePayload({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
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

  factory FavoritePayload.fromJson(Map<String, dynamic> json) => FavoritePayload(
    currentPage: json["current_page"] ?? 1,
    data: List<FavoriteItem>.from((json["data"] ?? []).map((x) => FavoriteItem.fromJson(x))),
    firstPageUrl: json["first_page_url"] ?? "",
    from: json["from"] ?? 0,
    lastPage: json["last_page"] ?? 1,
    lastPageUrl: json["last_page_url"] ?? "",
    links: List<Link>.from((json["links"] ?? []).map((x) => Link.fromJson(x))),
    nextPageUrl: json["next_page_url"],
    path: json["path"] ?? "",
    perPage: json["per_page"] ?? 10,
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"] ?? 0,
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

class FavoriteItem {
  int id;
  int userId;
  int favouritableId;
  String favouritableType;
  int favFlag;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic favouritable;

  FavoriteItem({
    required this.id,
    required this.userId,
    required this.favouritableId,
    required this.favouritableType,
    required this.favFlag,
    required this.createdAt,
    required this.updatedAt,
    required this.favouritable,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) => FavoriteItem(
    id: json["id"] ?? 0,
    userId: json["user_id"] ?? 0,
    favouritableId: json["favouritable_id"] ?? 0,
    favouritableType: json["favouritable_type"] ?? "",
    favFlag: json["fav_flag"] ?? 0,
    createdAt: DateTime.parse(json["created_at"] ?? DateTime.now().toIso8601String()),
    updatedAt: DateTime.parse(json["updated_at"] ?? DateTime.now().toIso8601String()),
    favouritable: json["favouritable"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "favouritable_id": favouritableId,
    "favouritable_type": favouritableType,
    "fav_flag": favFlag,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "favouritable": favouritable,
  };

  // Helper method to get property data
  PropertyData? get property {
    if (favouritableType.contains("Property") && favouritable != null) {
      return PropertyData.fromJson(favouritable);
    }
    return null;
  }

  // Helper method to get service data
  ServiceData? get service {
    if (favouritableType.contains("Service") && favouritable != null) {
      return ServiceData.fromJson(favouritable);
    }
    return null;
  }
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
    label: json["label"] ?? "",
    active: json["active"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}

class PropertyData {
  int id;
  String type;
  String city;
  String amount;
  String address;
  String lat;
  String long;
  String areaRange;
  String bedroom;
  String bathroom;
  String? description;
  String? electricityBill;
  String propertyType;
  String propertySubType;
  int userId;
  DateTime createdAt;
  DateTime updatedAt;
  int isFavorite;
  String? images;
  List<PropertyImage> propertyImages;

  PropertyData({
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
    this.description,
    this.electricityBill,
    required this.propertyType,
    required this.propertySubType,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.isFavorite,
    this.images,
    required this.propertyImages,
  });

  factory PropertyData.fromJson(Map<String, dynamic> json) => PropertyData(
    id: json["id"] ?? 0,
    type: json["type"]?.toString() ?? "",
    city: json["city"] ?? "",
    amount: json["amount"] ?? "0.00",
    address: json["address"] ?? "",
    lat: json["lat"] ?? "0.0",
    long: json["long"] ?? "0.0",
    areaRange: json["area_range"] ?? "",
    bedroom: json["bedroom"]?.toString() ?? "0",
    bathroom: json["bathroom"]?.toString() ?? "0",
    description: json["description"],
    electricityBill: json["electricity_bill"],
    propertyType: json["property_type"]?.toString() ?? "",
    propertySubType: json["property_sub_type"]?.toString() ?? "",
    userId: json["user_id"] ?? 0,
    createdAt: DateTime.parse(json["created_at"] ?? DateTime.now().toIso8601String()),
    updatedAt: DateTime.parse(json["updated_at"] ?? DateTime.now().toIso8601String()),
    isFavorite: json["isFavorite"] ?? 0,
    images: json["images"],
    propertyImages: json["property_images"] != null 
        ? List<PropertyImage>.from(json["property_images"].map((x) => PropertyImage.fromJson(x)))
        : [],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "city": city,
    "amount": amount,
    "address": address,
    "lat": lat,
    "long": long,
    "area_range": areaRange,
    "bedroom": bedroom,
    "bathroom": bathroom,
    "description": description,
    "electricity_bill": electricityBill,
    "property_type": propertyType,
    "property_sub_type": propertySubType,
    "user_id": userId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "isFavorite": isFavorite,
    "images": images,
    "property_images": List<dynamic>.from(propertyImages.map((x) => x.toJson())),
  };
}

class PropertyImage {
  int id;
  int propertyId;
  String imagePath;
  DateTime createdAt;
  DateTime updatedAt;

  PropertyImage({
    required this.id,
    required this.propertyId,
    required this.imagePath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PropertyImage.fromJson(Map<String, dynamic> json) => PropertyImage(
    id: json["id"] ?? 0,
    propertyId: json["property_id"] ?? 0,
    imagePath: json["image_path"] ?? "",
    createdAt: DateTime.parse(json["created_at"] ?? DateTime.now().toIso8601String()),
    updatedAt: DateTime.parse(json["updated_at"] ?? DateTime.now().toIso8601String()),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "property_id": propertyId,
    "image_path": imagePath,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class ServiceData {
  int id;
  int userId;
  String serviceName;
  String description;
  String pricing;
  String duration;
  String startTime;
  String endTime;
  String location;
  String? lat;
  String? long;
  String? additionalInformation;
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
  String? media;
  List<ServiceImage> serviceImages;

  ServiceData({
    required this.id,
    required this.userId,
    required this.serviceName,
    required this.description,
    required this.pricing,
    required this.duration,
    required this.startTime,
    required this.endTime,
    required this.location,
    this.lat,
    this.long,
    this.additionalInformation,
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
    this.media,
    required this.serviceImages,
  });

  factory ServiceData.fromJson(Map<String, dynamic> json) => ServiceData(
    id: json["id"] ?? 0,
    userId: json["user_id"] ?? 0,
    serviceName: json["service_name"] ?? "",
    description: json["description"] ?? "",
    pricing: json["pricing"] ?? "0.00",
    duration: json["duration"]?.toString() ?? "0",
    startTime: json["start_time"] ?? "",
    endTime: json["end_time"] ?? "",
    location: json["location"] ?? "",
    lat: json["lat"],
    long: json["long"],
    additionalInformation: json["additional_information"],
    country: json["country"] ?? "",
    city: json["city"] ?? "",
    yearExperience: json["year_experience"] ?? 0,
    cnicFrontPic: json["cnic_front_pic"],
    cnicBackPic: json["cnic_back_pic"],
    certification: json["certification"],
    resume: json["resume"],
    createdAt: DateTime.parse(json["created_at"] ?? DateTime.now().toIso8601String()),
    updatedAt: DateTime.parse(json["updated_at"] ?? DateTime.now().toIso8601String()),
    status: json["status"] ?? "pending",
    providerId: json["provider_id"],
    serviceType: json["service_type"] ?? "request",
    paymentStatus: json["payment_status"] ?? "pending",
    postalCode: json["postal_code"],
    isApplied: json["is_applied"] ?? 0,
    assignedAt: json["assigned_at"] != null ? DateTime.parse(json["assigned_at"]) : null,
    completedAt: json["completed_at"] != null ? DateTime.parse(json["completed_at"]) : null,
    isFavorite: json["isFavorite"] ?? 0,
    serviceId: json["service_id"],
    propertyType: json["property_type"],
    media: json["media"],
    serviceImages: json["service_images"] != null 
        ? List<ServiceImage>.from(json["service_images"].map((x) => ServiceImage.fromJson(x)))
        : [],
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
    "media": media,
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
    id: json["id"] ?? 0,
    serviceId: json["service_id"] ?? 0,
    imagePath: json["image_path"] ?? "",
    createdAt: DateTime.parse(json["created_at"] ?? DateTime.now().toIso8601String()),
    updatedAt: DateTime.parse(json["updated_at"] ?? DateTime.now().toIso8601String()),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "service_id": serviceId,
    "image_path": imagePath,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
