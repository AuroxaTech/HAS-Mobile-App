// To parse this JSON data, do
//
//     final allProperty = allPropertyFromJson(jsonString);

import 'dart:convert';

AllProperty allPropertyFromJson(String str) => AllProperty.fromJson(json.decode(str));

String allPropertyToJson(AllProperty data) => json.encode(data.toJson());

class AllProperty {
  bool status;
  String message;
  AllPropertyData data;

  AllProperty({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AllProperty.fromJson(Map<String, dynamic> json) => AllProperty(
    status: json["status"],
    message: json["message"],
    data: AllPropertyData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class AllPropertyData {
  int currentPage;
  List<PropertData> data;
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

  AllPropertyData({
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

  factory AllPropertyData.fromJson(Map<String, dynamic> json) => AllPropertyData(
    currentPage: json["current_page"],
    data: List<PropertData>.from(json["data"].map((x) => PropertData.fromJson(x))),
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

class PropertData {
  int id;
  String userId;
  String type;
  String? images;
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
  DateTime createdAt;
  DateTime updatedAt;
  String noOfProperty;
  AvailabilityStartTime availabilityStartTime;
  AvailabilityEndTime availabilityEndTime;

  PropertData({
    required this.id,
    required this.userId,
    required this.type,
    required this.images,
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
    required this.createdAt,
    required this.updatedAt,
    required this.noOfProperty,
    required this.availabilityStartTime,
    required this.availabilityEndTime,
  });

  factory PropertData.fromJson(Map<String, dynamic> json) => PropertData(
    id: json["id"],
    userId: json["user_id"],
    type: json["type"],
    images: json["images"],
    city: json["city"],
    amount: json["amount"],
    address: json["address"],
    lat: json["lat"],
    long: json["long"],
    areaRange: json["area_range"],
    bedroom: json["bedroom"],
    bathroom: json["bathroom"],
    description: json["description"],
    electricityBill: json["electricity_bill"],
    propertyType: json["property_type"],
    propertySubType: json["property_sub_type"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    noOfProperty: json["no_of_property"],
    availabilityStartTime: availabilityStartTimeValues.map[json["availability_start_time"]]!,
    availabilityEndTime: availabilityEndTimeValues.map[json["availability_end_time"]]!,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "type": type,
    "images": images,
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
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "no_of_property": noOfProperty,
    "availability_start_time": availabilityStartTimeValues.reverse[availabilityStartTime],
    "availability_end_time": availabilityEndTimeValues.reverse[availabilityEndTime],
  };
}

enum AvailabilityEndTime {
  THE_0500_PM,
  THE_0600_PM,
  THE_500_AM,
  TIME_OF_DAY_1700
}

final availabilityEndTimeValues = EnumValues({
  "05:00 PM": AvailabilityEndTime.THE_0500_PM,
  "06:00 PM": AvailabilityEndTime.THE_0600_PM,
  "5 : 00 AM": AvailabilityEndTime.THE_500_AM,
  "TimeOfDay(17:00)": AvailabilityEndTime.TIME_OF_DAY_1700
});

enum AvailabilityStartTime {
  THE_0900_AM,
  THE_900_AM,
  TIME_OF_DAY_0900
}

final availabilityStartTimeValues = EnumValues({
  "09:00 AM": AvailabilityStartTime.THE_0900_AM,
  "9 : 00 AM": AvailabilityStartTime.THE_900_AM,
  "TimeOfDay(09:00)": AvailabilityStartTime.TIME_OF_DAY_0900
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
