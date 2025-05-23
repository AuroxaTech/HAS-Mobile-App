class AppUrls {
  static const mapKey = "AIzaSyDyeWs6PDrJbaqLv_AL0m1aww0munJ_vlc";
  static const stripePKTestKey =
      "pk_test_51HjIu0CtN8FBu4sMBrRyqvMhEHkLO1fAG4EUIqadkjchf3YTILAc0gnqkk0LFRCqbsxkb8k66DKe07cwuycRO3Y000zt0BGyQV";

  // static const stripePKLiveKey =
  //     "pk_live_51OzihLBFjIw5Tzwc1rtHQpQT6eLGwhPu4ofUdeiGyUXg2xg3K5SVWZqHzUmWK5FQzyOKBb6GLrQaSQ3fWT1KPah000kgnRST9A";

  // static const baseUrl = "https://pktours.pk";

  ///Old Banckend
  //static const baseUrl = "https://haservices.ca:8080";

  ///New Banckend
  //static const baseUrl = "https://haservices.ca:8080/api";

  //static const baseUrl = "https://has-backend.wazirafghan.online/api";
  static const baseUrl = "https://has-backend.hspfarms.com/api";

  // static const electricityBillBaseUrl = "$baseUrl/assets/electricity_bill/";
  // static const certificateImagesBaseUrl =
  //     "$baseUrl/assets/certification_images/";
  // static const CNIC = "$baseUrl/assets/cnic/";
  static const propertyImages = "$baseUrl/assets/property_images/";
  // static const servicesImages = "$baseUrl/assets/service_images/";
  static const mediaImages = "$baseUrl/assets/media_images/";

  //Registration
  static const registerUrl = "$baseUrl/register";
  static const loginUrl = "$baseUrl/login";
  static const userState = "$baseUrl/service-provider-state";
  static const landlordStat = "$baseUrl/landlord-state";
  static const tenantStat = "$baseUrl/tenant-state";
  static const visitorStat = "$baseUrl/visitor-state";
  static const getUser = "$baseUrl/get-user-by-id";

  //property
  // static const getProperties = "$baseUrl/all-properties";
  // static const getLandLordProperty = "$baseUrl/get-properties";
  static const getAllProperty = "$baseUrl/properties";
  static const propertyDetail = "$baseUrl/property/details";
  static const getProperty = "$baseUrl/get-property";
  static const updateProperty = "$baseUrl/property/update";
  static const deleteProperty = "$baseUrl/property/delete";
  static const addProperty = "$baseUrl/property/store";
  static const addFavoriteProperty = "$baseUrl/property-favourites";
  static const getApprovedContractProperty =
      "$baseUrl/approved-contract-property";

  //service
  static const addServices = "$baseUrl/service/store";
  static const getServices = "$baseUrl/get-services";
  static const getService = "$baseUrl/service";
  static const deleteService = "$baseUrl/service/delete";
  static const updateService = "$baseUrl/service/update";
  static const addServiceRequest = "$baseUrl/add-service-request";
  static const markCompleteRequest = "$baseUrl/services";
  static const getServiceProviderRequest = "$baseUrl/get-service-request";
  static const getServiceUserRequest = "$baseUrl/get-user-request";
  static const serviceRequestDecline = "$baseUrl/service-request-decline";
  static const serviceRequestAccept = "$baseUrl/add-service-job";
  static const getJobs = "$baseUrl/service-job-by-status";
  static const getServiceRequest = "$baseUrl/get-service-provider-request";
  static const getServiceProviderJob = "$baseUrl/get-service-provider-job";
  static const getServiceJobDetail = "$baseUrl/get-job-detail";
  static const getServiceFeedback = "$baseUrl/get-provider-rating";

  // favourite provider
  static const addFavouriteProvider = "$baseUrl/add-fav-provider";
  static const addFavouriteService = "$baseUrl/service-favourites";
  // Update these constants
  static const getFavouriteServices = "$baseUrl/get-favourite-services";
  static const getFavouriteProperties = "$baseUrl/get-favourite-properties";
  // contract api
  static const addContract = "$baseUrl/contract/store";
  static const getTenantContract = "$baseUrl/contracts";
  static const getLandlordContract = "$baseUrl/get-landlord-contract";
  static const acceptContract = "$baseUrl/mark-contract-status";
  static const contractDetail = "$baseUrl/get-contract-detail";

  //Profile
  static const updateProfile = "$baseUrl/update-profile";
  static const updatePassword = "$baseUrl/update-password";
  static const forgotPassword = "$baseUrl/forgot-password";
  static const deleteUser = "$baseUrl/user/delete";
  static const searchUser = "$baseUrl/get-user";

  static const makeFeedBack = "$baseUrl/make-service-feedback";
}
