class PropertyResponse {
  bool status;
  String message;
  PropertyData data;

  PropertyResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PropertyResponse.fromJson(Map<String, dynamic> json) {
    return PropertyResponse(
      status: json['status'],
      message: json['message'],
      data: PropertyData.fromJson(json['data']),
    );
  }
}

class PropertyData {
  int currentPage;
  List<Property> properties;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  List<PageLink> links;
  String? nextPageUrl;
  String path;
  int perPage;
  String? prevPageUrl;
  int to;
  int total;

  PropertyData({
    required this.currentPage,
    required this.properties,
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

  factory PropertyData.fromJson(Map<String, dynamic> json) {
    return PropertyData(
      currentPage: json['current_page'],
      properties: List<Property>.from(
        json['data'].map((property) => Property.fromJson(property)),
      ),
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],
      links: List<PageLink>.from(
        json['links'].map((link) => PageLink.fromJson(link)),
      ),
      nextPageUrl: json['next_page_url'],
      path: json['path'],
      perPage: json['per_page'],
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'],
    );
  }
}

class Property {
  int id;
  int userId;
  int type;
  String images;
  String city;
  String amount;
  String address;
  String lat;
  String long;
  String areaRange;
  String bedroom;
  String bathroom;
  String description;
  String electricityBill;
  String createdAt;
  String updatedAt;
  bool isFavorite;
  User? user;

  Property({
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
    required this.createdAt,
    required this.updatedAt,
    required this.isFavorite,
    required this.user
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      userId: json['user_id'],
      type: json['type'],
      images: json['images']??"",
      city: json['city'] ?? "",
      amount: json['amount'],
      address: json['address'],
      lat: json['lat'],
      long: json['long'],
      areaRange: json['area_range'],
      bedroom: json['bedroom'],
      bathroom: json['bathroom'],
      description: json['description']?? "",
      electricityBill: json['electricity_bill'] ?? "",
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isFavorite: json["is_favorite"] ?? false,
      user: json["user"] == null ? null : User.fromJson(json["user"]),
    );
  }
}

class PageLink {
  String? url;
  String label;
  bool active;

  PageLink({
    required this.url,
    required this.label,
    required this.active,
  });

  factory PageLink.fromJson(Map<String, dynamic> json) {
    return PageLink(
      url: json['url'],
      label: json['label'],
      active: json['active'],
    );
  }
}


class User {
  int id;
  String fullname;
  String email;
  String phoneNumber;
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
    "fullname": fullname,
    "email": email,
    "phone_number": phoneNumber,
    "role_id": roleId,
    "profileimage": profileimage,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}