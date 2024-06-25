// To parse this JSON data, do
//
//     final allServices = allServicesFromJson(jsonString);

import 'dart:convert';

AllServices allServicesFromJson(String str) => AllServices.fromJson(json.decode(str));

String allServicesToJson(AllServices data) => json.encode(data.toJson());

class AllServices {
  bool status;
  String message;
  Data data;

  AllServices({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AllServices.fromJson(Map<String, dynamic> json) => AllServices(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data: List<AllService>.from(json["data"].map((x) => AllService.fromJson(x))),
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

class AllService {
  int id;
  int userId;
  String serviceName;
  String description;
  String pricing;
  String startTime;
  String endTime;
  String location;
  String lat;
  int countOfService;
  int totalRate;
  int averageRate;
  String long;
  String media;
  String city;
  String country;
  String additionalInformation;
  DateTime createdAt;
  DateTime updatedAt;
  bool isFavorite;
  User? user;

  AllService({
    required this.id,
    required this.userId,
    required this.serviceName,
    required this.description,
    required this.pricing,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.lat,
    required this.countOfService,
    required this.totalRate,
    required this.averageRate,
    required this.long,
    required this.media,
    required this.city,
    required this.country,
    required this.additionalInformation,
    required this.createdAt,
    required this.updatedAt,
    required this.isFavorite,
    required this.user,
  });

  factory AllService.fromJson(Map<String, dynamic> json) => AllService(
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
    countOfService: json["count_of_service"] ?? 0,
    totalRate: json["total_rate"] ?? 0,
    averageRate: json["average_rate"] ?? 0,
    media: json["media"] ?? "",
    country: json["country"] ?? "",
    city: json["city"] ?? "",
    additionalInformation: json["additional_information"] ?? "",
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    isFavorite: json["is_favorite"] ?? false,
    user: json["user"] != null ? User.fromJson(json["user"]) : null,
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
    "count_of_service": countOfService,
    "total_rate": totalRate,
    "average_rate": averageRate,
    "media": media,
    "country" : country,
    "city" : city,
    "additional_information": additionalInformation,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "is_favorite": isFavorite,
    "user": user,
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

enum StartTime {
  THE_0800_AM,
  THE_3_E,
  THE_900_AM
}

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
  int roleId;
  String profileimage;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.fullname,
    required this.email,
    required this.phoneNumber,
    required this.roleId,
    required this.profileimage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
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
    "fullname": fullnameValues.reverse[fullname],
    "email": emailValues.reverse[email],
    "phone_number": phoneNumber,
    "role_id": roleId,
    "profileimage": profileimageValues.reverse[profileimage],
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

enum Email {
  AYAZPROVIDER_EXAMPLE_COM,
  VZHDH_GFF_GG
}

final emailValues = EnumValues({
  "ayazprovider@example.com": Email.AYAZPROVIDER_EXAMPLE_COM,
  "vzhdh@gff.gg": Email.VZHDH_GFF_GG
});

enum Fullname {
  AYAZ,
  JANE_SMITH
}

final fullnameValues = EnumValues({
  "Ayaz": Fullname.AYAZ,
  "Jane Smith": Fullname.JANE_SMITH
});

enum Profileimage {
  EMPTY,
  PROFILE_65_E57_EE8_B26_EA_SCREENSHOT_20240225_AT_31946_PM_PNG
}

final profileimageValues = EnumValues({
  "": Profileimage.EMPTY,
  "Profile-65e57ee8b26ea-Screenshot 2024-02-25 at 3.19.46 PM.png": Profileimage.PROFILE_65_E57_EE8_B26_EA_SCREENSHOT_20240225_AT_31946_PM_PNG
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
