// To parse this JSON data, do
//
//     final allServices = allServicesFromJson(jsonString);

import 'dart:convert';

AllServices allServicesFromJson(String str) {
  final dynamic decoded = json.decode(str);

  // Handle different response formats
  if (decoded is List) {
    // If it's a list of services, create a custom wrapper
    return AllServices(
      success: true,
      message: "Service list retrieved",
      payload: Data(
        currentPage: 1,
        data: List<AllService>.from(decoded.map((x) => AllService.fromJson(x))),
        firstPageUrl: "",
        from: 1,
        lastPage: 1,
        lastPageUrl: "",
        links: [],
        nextPageUrl: "",
        path: "",
        perPage: decoded.length,
        prevPageUrl: null,
        to: decoded.length,
        total: decoded.length,
      ),
    );
  } else {
    // Regular object response
    return AllServices.fromJson(decoded);
  }
}

String allServicesToJson(AllServices data) => json.encode(data.toJson());

class AllServices {
  bool success;
  String message;
  Data payload;

  AllServices({
    required this.success,
    required this.message,
    required this.payload,
  });

  factory AllServices.fromJson(Map<String, dynamic> json) {
    // Handle direct payload (single object) vs paginated response
    return AllServices(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      payload: json.containsKey("payload")
          ? Data.fromJson(json["payload"])
          : Data.fromJson(json), // Fallback to treating the whole json as data
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "payload": payload.toJson(),
      };
}

class Data {
  int currentPage;
  List<AllService> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  List<Link> links;
  String nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  Data({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    // Check if we're dealing with a single object response (not paginated)
    if (!json.containsKey("current_page")) {
      // Single object response, not paginated
      return Data(
        currentPage: 1,
        data: [AllService.fromJson(json)],
        firstPageUrl: "",
        from: 1,
        lastPage: 1,
        lastPageUrl: "",
        links: [],
        nextPageUrl: "",
        path: "",
        perPage: 1,
        prevPageUrl: null,
        to: 1,
        total: 1,
      );
    } else {
      // Regular paginated response
      return Data(
        currentPage: json["current_page"],
        data: List<AllService>.from(
            json["data"].map((x) => AllService.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"] ?? 0,
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"] ?? "",
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"] ?? 0,
        total: json["total"],
      );
    }
  }

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

class AllService {
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
  dynamic yearExperience;
  String? cnicFrontPic;
  String? cnicBackPic;
  String? certification;
  String? resume;
  DateTime createdAt;
  DateTime updatedAt;
  String status;
  int providerId;
  String serviceType;
  String paymentStatus;
  String? postalCode;
  int isApplied;
  DateTime? assignedAt;
  DateTime? completedAt;
  int isFavorite;
  int? serviceId;
  String? propertyType;
  int? countOfService;
  int? totalRate;
  int? averageRate;
  User? user;
  List<ServiceProviderRequest>? serviceProviderRequests;
  List<ServiceImage> serviceImages;

  AllService({
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
    this.yearExperience,
    this.cnicFrontPic,
    this.cnicBackPic,
    this.certification,
    this.resume,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.providerId,
    required this.serviceType,
    required this.paymentStatus,
    this.postalCode,
    required this.isApplied,
    this.assignedAt,
    this.completedAt,
    required this.isFavorite,
    this.serviceId,
    this.propertyType,
    this.countOfService,
    this.totalRate,
    this.averageRate,
    this.user,
    this.serviceProviderRequests,
    required this.serviceImages,
  });

  factory AllService.fromJson(Map<String, dynamic> json) {
    print("All Services List => ${json.toString()}");

    // Parse service provider requests if they exist
    final serviceProviderRequests = json["service_provider_requests"] != null
        ? List<ServiceProviderRequest>.from(json["service_provider_requests"]
            .map((x) => ServiceProviderRequest.fromJson(x)))
        : null;

    // Find the latest request (highest ID) if requests exist
    ServiceProviderRequest? latestRequest;
    if (serviceProviderRequests != null && serviceProviderRequests.isNotEmpty) {
      latestRequest = serviceProviderRequests
          .reduce((curr, next) => curr.id > next.id ? curr : next);
    }

    // Extract values from latestRequest or fallback to json values
    final isApplied = json["is_applied"] ?? 0;
    print("AllService - isApplied: ${isApplied}");

    return AllService(
      id: json["id"],
      userId: json["user_id"],
      serviceName: json["service_name"],
      description: json["description"],
      pricing: json["pricing"],
      duration: json["duration"] ?? "0",
      startTime: json["start_time"],
      endTime: json["end_time"],
      location: json["location"],
      lat: json["lat"],
      long: json["long"],
      additionalInformation: json["additional_information"] ?? "",
      country: json["country"] ?? "",
      city: json["city"] ?? "",
      yearExperience: json["year_experience"],
      cnicFrontPic: json["cnic_front_pic"],
      cnicBackPic: json["cnic_back_pic"],
      certification: json["certification"],
      resume: json["resume"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      status: json["status"] ?? "pending",
      providerId: json["provider_id"] ?? 0,
      serviceType: json["service_type"] ?? "request",
      paymentStatus: json["payment_status"] ?? "pending",
      postalCode: json["postal_code"],
      isApplied: isApplied,
      assignedAt: json["assigned_at"] != null
          ? DateTime.parse(json["assigned_at"])
          : null,
      completedAt: json["completed_at"] != null
          ? DateTime.parse(json["completed_at"])
          : null,
      isFavorite: json["isFavorite"] ?? 0,
      serviceId: json["service_id"],
      propertyType: json["property_type"],
      countOfService: json["count_of_service"] ?? 0,
      totalRate: json["total_rate"] ?? 0,
      averageRate: json["average_rate"] ?? 0,
      user: json["user"] != null ? User.fromJson(json["user"]) : null,
      serviceProviderRequests: serviceProviderRequests,
      serviceImages: json["service_images"] != null
          ? List<ServiceImage>.from(
              json["service_images"].map((x) => ServiceImage.fromJson(x)))
          : [],
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
        "count_of_service": countOfService,
        "total_rate": totalRate,
        "average_rate": averageRate,
        "user": user?.toJson(),
        "service_provider_requests": serviceProviderRequests != null
            ? List<dynamic>.from(
                serviceProviderRequests!.map((x) => x.toJson()))
            : null,
        "service_images":
            List<dynamic>.from(serviceImages.map((x) => x.toJson())),
      };
}

class ServiceProviderRequest {
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
  String? additionalInfo;
  int? approved;
  int? decline;
  DateTime createdAt;
  DateTime updatedAt;
  String? postalCode;
  int? isApplied;

  ServiceProviderRequest({
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
    this.additionalInfo,
    required this.approved,
    required this.decline,
    required this.createdAt,
    required this.updatedAt,
    this.postalCode,
    this.isApplied,
  });

  factory ServiceProviderRequest.fromJson(Map<String, dynamic> json) {
    print("All Service Provider List => ${json.toString()}");

    return ServiceProviderRequest(
      id: json['id'],
      userId: json['user_id'],
      serviceproviderId: json['serviceprovider_id'],
      serviceId: json['service_id'],
      address: json['address'],
      lat: json['lat'],
      long: json['long'],
      propertyType: json['property_type'],
      price: json['price'],
      date: json['date'],
      time: json['time'],
      description: json['description'],
      additionalInfo: json['additional_info'],
      approved: json['approved'],
      decline: json['decline'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      postalCode: json['postal_code'],
      isApplied: json['is_applied'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'serviceprovider_id': serviceproviderId,
        'service_id': serviceId,
        'address': address,
        'lat': lat,
        'long': long,
        'property_type': propertyType,
        'price': price,
        'date': date,
        'time': time,
        'description': description,
        'additional_info': additionalInfo,
        'approved': approved,
        'decline': decline,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'postal_code': postalCode,
        'is_applied': isApplied,
      };
}

enum Location {
  LOCATION_PAKISTAN,
  PAKISTAN,
  THE_123_MAIN_STREET_1,
  WDFWFEWFWEFEF
}

final locationValues = EnumValues({
  "Pakistan": Location.LOCATION_PAKISTAN,
  "pakistan": Location.PAKISTAN,
  "123 Main Street 1": Location.THE_123_MAIN_STREET_1,
  "wdfwfewfwefef": Location.WDFWFEWFWEFEF
});

enum StartTime { THE_0800_AM, THE_3_E, THE_900_AM }

final startTimeValues = EnumValues({
  "08:00 AM": StartTime.THE_0800_AM,
  "3 e": StartTime.THE_3_E,
  "9:00 AM": StartTime.THE_900_AM
});

class User {
  int id;
  String fullname;
  String email;
  String? phoneNumber;
  String roleId;
  String profileimage;
  DateTime createdAt;
  DateTime updatedAt;
  String? address;
  String? postalCode;
  String? userName;

  User({
    required this.id,
    required this.fullname,
    required this.email,
    required this.phoneNumber,
    required this.roleId,
    required this.profileimage,
    required this.createdAt,
    required this.updatedAt,
    this.address,
    this.postalCode,
    this.userName,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        fullname: json["full_name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        roleId: json["role"],
        profileimage: json["profile_image"] ?? "",
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        address: json["address"],
        postalCode: json["postal_code"],
        userName: json["user_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullname,
        "email": email,
        "phone_number": phoneNumber,
        "role": roleId,
        "profile_image": profileimage,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "address": address,
        "postal_code": postalCode,
        "user_name": userName,
      };
}

enum Email { AYAZPROVIDER_EXAMPLE_COM, VZHDH_GFF_GG }

final emailValues = EnumValues({
  "ayazprovider@example.com": Email.AYAZPROVIDER_EXAMPLE_COM,
  "vzhdh@gff.gg": Email.VZHDH_GFF_GG
});

enum Fullname { AYAZ, JANE_SMITH }

final fullnameValues =
    EnumValues({"Ayaz": Fullname.AYAZ, "Jane Smith": Fullname.JANE_SMITH});

enum Profileimage {
  EMPTY,
  PROFILE_65_E57_EE8_B26_EA_SCREENSHOT_20240225_AT_31946_PM_PNG
}

final profileimageValues = EnumValues({
  "": Profileimage.EMPTY,
  "Profile-65e57ee8b26ea-Screenshot 2024-02-25 at 3.19.46 PM.png":
      Profileimage.PROFILE_65_E57_EE8_B26_EA_SCREENSHOT_20240225_AT_31946_PM_PNG
});

class Link {
  String? url;
  String label;
  bool active;

  Link({
    required this.url,
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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
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
