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
