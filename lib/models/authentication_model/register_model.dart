class Visitor {
  String? fullName;
  String? email;
  int? password;
  int? passwordConfirmation;
  int? roleId;

  Visitor({
    this.fullName,
    this.email,
    this.password,
    this.passwordConfirmation,
    this.roleId,
  });

  factory Visitor.fromJson(Map<String, dynamic> json) {
    return Visitor(
      fullName: json['fullname'],
      email: json['email'],
      password: json['password'],
      passwordConfirmation: json['password_confirmation'],
      roleId: json['role_id'],
    );
  }
}

class ServiceProvider {
  String? fullName;
  String? email;
  String? password;
  int? passwordCconfirmation;
  int? roleId;
  String? profileImage;
  String? services;
  int? yearExperience;
  String? availabilityStartTime;
  String? availabilityEndTime;
  String? cnicFront;
  String? cnicBack;
  String? certification;
  String? certificationFileName;
  // Add other properties specific to the Service Provider

  ServiceProvider({
    this.fullName,
    this.email,
    this.password,
    this.passwordCconfirmation,
    this.roleId,
    this.profileImage,
    this.services,
    this.yearExperience,
    this.availabilityStartTime,
    this.availabilityEndTime,
    this.cnicFront,
    this.cnicBack,
    this.certification,
    this.certificationFileName,
    // Add other properties specific to the Service Provider
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    return ServiceProvider(
      fullName: json['fullname'],
      email: json['email'],
      password: json['password'],
      passwordCconfirmation: json['password_confirmation'],
      roleId: json['role_id'],
      profileImage: json['profileimage'],
      services: json['services'],
      yearExperience: json['year_experience'],
      availabilityStartTime: json['availability_start_time'],
      availabilityEndTime: json['availability_end_time'],
      cnicFront: json['cnic_front'],
      cnicBack: json['cnic_back'],
      certification: json['certification'],
      certificationFileName: json['certification_file_name'],
      // Add other properties specific to the Service Provider
    );
  }
}

class Landlord {
  String? fullName;
  String? email;
  String? password;
  int? roleId;
  String? profileImage;
  String? type;
  String? city;
  int? amount;
  String? address;
  double? lat;
  double? long;
  String? areaRange;
  int? bedroom;
  int? bathroom;
  String? electricityBill;
  List<String>? propertyImages;
  int? noOfProperty;
  String? propertyType;
  String? availabilityStartTime;
  String? availabilityEndTime;
  // Add other properties specific to the Landlord

  Landlord({
    this.fullName,
    this.email,
    this.password,
    this.roleId,
    this.profileImage,
    this.type,
    this.city,
    this.amount,
    this.address,
    this.lat,
    this.long,
    this.areaRange,
    this.bedroom,
    this.bathroom,
    this.electricityBill,
    this.propertyImages,
    this.noOfProperty,
    this.propertyType,
    this.availabilityStartTime,
    this.availabilityEndTime,
    // Add other properties specific to the Landlord
  });

  factory Landlord.fromJson(Map<String, dynamic> json) {
    return Landlord(
      fullName: json['fullname'],
      email: json['email'],
      password: json['password'],
      roleId: json['role_id'],
      profileImage: json['profileimage'],
      type: json['type'],
      city: json['city'],
      amount: json['amount'],
      address: json['address'],
      lat: json['lat'],
      long: json['long'],
      areaRange: json['area_range'],
      bedroom: json['bedroom'],
      bathroom: json['bathroom'],
      electricityBill: json['electricity_bill'],
      propertyImages: List<String>.from(json['property_images'] ?? []),
      noOfProperty: json['no_of_property'],
      propertyType: json['property_type'],
      availabilityStartTime: json['availability_start_time'],
      availabilityEndTime: json['availability_end_time'],
      // Add other properties specific to the Landlord
    );
  }
}

class Tenant {
  String? fullName;
  String? email;
  String? password;
  int? roleId;
  String? profileImage;
  int? lastStatus;
  String? lastLandlordName;
  String? lastTenancy;
  String? lastLandlordContact;
  String? occupation;
  String? leasedDuration;
  int? noOfOccupants;
  // Add other properties specific to the Tenant

  Tenant({
    this.fullName,
    this.email,
    this.password,
    this.roleId,
    this.profileImage,
    this.lastStatus,
    this.lastLandlordName,
    this.lastTenancy,
    this.lastLandlordContact,
    this.occupation,
    this.leasedDuration,
    this.noOfOccupants,
    // Add other properties specific to the Tenant
  });

  factory Tenant.fromJson(Map<String, dynamic> json) {
    return Tenant(
      fullName: json['fullname'],
      email: json['email'],
      password: json['password'],
      roleId: json['role_id'],
      profileImage: json['profileimage'],
      lastStatus: json['last_status'],
      lastLandlordName: json['last_landlord_name'],
      lastTenancy: json['last_tenancy'],
      lastLandlordContact: json['last_landlord_contact'],
      occupation: json['occupation'],
      leasedDuration: json['leased_duration'],
      noOfOccupants: json['no_of_occupants'],
      // Add other properties specific to the Tenant
    );
  }
}

class OwnHouseTenant extends Tenant {
  OwnHouseTenant({
    String? fullName,
    String? email,
    String? password,
    int? roleId,
    // Add other properties specific to the Own House Tenant
  }) : super(
    fullName: fullName,
    email: email,
    password: password,
    roleId: roleId,
  );

  factory OwnHouseTenant.fromJson(Map<String, dynamic> json) {
    // Deserialize OwnHouseTenant specific properties here
    return OwnHouseTenant(
      fullName: json['fullname'],
      email: json['email'],
      password: json['password'],
      roleId: json['role_id'],
      // Deserialize Own House Tenant specific properties
    );
  }
}

class RegisterResponse {
  String? message;

  RegisterResponse({this.message});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      message: json['message'],
    );
  }
}