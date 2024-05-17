// To parse this JSON data, do
//
//     final ratingProvider = ratingProviderFromJson(jsonString);

import 'dart:convert';

RatingProvider ratingProviderFromJson(String str) => RatingProvider.fromJson(json.decode(str));

String ratingProviderToJson(RatingProvider data) => json.encode(data.toJson());

class RatingProvider {
  bool status;
  Data data;

  RatingProvider({
    required this.status,
    required this.data,
  });

  factory RatingProvider.fromJson(Map<String, dynamic> json) => RatingProvider(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  int oneRate;
  int twoRate;
  int threeRate;
  int fourRate;
  int fiveRate;
  RatingData ratingData;

  Data({
    required this.oneRate,
    required this.twoRate,
    required this.threeRate,
    required this.fourRate,
    required this.fiveRate,
    required this.ratingData,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    oneRate: json["one_rate"],
    twoRate: json["two_rate"],
    threeRate: json["three_rate"],
    fourRate: json["four_rate"],
    fiveRate: json["five_rate"],
    ratingData: RatingData.fromJson(json["rating_data"]),
  );

  Map<String, dynamic> toJson() => {
    "one_rate": oneRate,
    "two_rate": twoRate,
    "three_rate": threeRate,
    "four_rate": fourRate,
    "five_rate": fiveRate,
    "rating_data": ratingData.toJson(),
  };
}

class RatingData {
  int currentPage;
  List<RatingDatum> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  List<Link> links;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  RatingData({
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

  factory RatingData.fromJson(Map<String, dynamic> json) => RatingData(
    currentPage: json["current_page"],
    data: List<RatingDatum>.from(json["data"].map((x) => RatingDatum.fromJson(x))),
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

class RatingDatum {
  int id;
  String userId;
  String serviceId;
  String propertySubTypeId;
  String rate;
  String description;
  DateTime createdAt;
  DateTime updatedAt;
  Subpropertytype subpropertytype;

  RatingDatum({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.propertySubTypeId,
    required this.rate,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.subpropertytype,
  });

  factory RatingDatum.fromJson(Map<String, dynamic> json) => RatingDatum(
    id: json["id"],
    userId: json["user_id"],
    serviceId: json["service_id"],
    propertySubTypeId: json["property_sub_type_id"],
    rate: json["rate"],
    description: json["description"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    subpropertytype: Subpropertytype.fromJson(json["subpropertytype"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "service_id": serviceId,
    "property_sub_type_id": propertySubTypeId,
    "rate": rate,
    "description": description,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "subpropertytype": subpropertytype.toJson(),
  };
}

class Subpropertytype {
  int id;
  String name;

  Subpropertytype({
    required this.id,
    required this.name,
  });

  factory Subpropertytype.fromJson(Map<String, dynamic> json) => Subpropertytype(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

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
