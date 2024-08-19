class AppUrls {

  static const mapKey = "AIzaSyDyeWs6PDrJbaqLv_AL0m1aww0munJ_vlc";

 // static const baseUrl = "https://pktours.pk";
  static const baseUrl = "https://haservices.ca:8080";
  static const profileImageBaseUrl = "$baseUrl/assets/profile_images/";
  static const electricityBillBaseUrl = "$baseUrl/assets/electricity_bill/";
  static const certificateImagesBaseUrl = "$baseUrl/assets/certification_images/";
  static const CNIC = "$baseUrl/assets/cnic/";
  static const propertyImages = "$baseUrl/assets/property_images/";
  static const servicesImages = "$baseUrl/assets/service_images/";
  static const mediaImages = "$baseUrl/assets/media_images/";

  //Registration
  static const registerUrl = "$baseUrl/register";
  static const loginUrl = "$baseUrl/login";
  static const userState = "$baseUrl/service-provider-stat";
  static const landlordStat = "$baseUrl/landlord-stat";
  static const tenantStat = "$baseUrl/tenant-stat";
  static const visitorStat = "$baseUrl/visitor-stat";
  static const getUser = "$baseUrl/get-user-by-id";

  //property
  static const getProperties  = "$baseUrl/all-properties";
  static const getLandLordProperty  = "$baseUrl/get-properties";
  static const getAllProperty  = "$baseUrl/all-properties";
  static const getProperty  = "$baseUrl/get-property";
  static const updateProperty  = "$baseUrl/update-property";
  static const deleteProperty  = "$baseUrl/delete-property";
  static const addProperty  = "$baseUrl/add-property";
  static const addFavoriteProperty  = "$baseUrl/add-fav-property";
  static const getApprovedContractProperty  = "$baseUrl/approved-contract-property";

  //service
  static const addServices = "$baseUrl/add-service";
  static const getServices = "$baseUrl/get-services";
  static const getAllServices = "$baseUrl/all-services";
  static const getService = "$baseUrl/get-service";
  static const deleteService = "$baseUrl/destroy-service";
  static const updateService = "$baseUrl/update-service";
  static const addServiceRequest = "$baseUrl/add-service-request";
  static const markCompleteRequest = "$baseUrl/mark-service-job-status";
  static const getServiceProviderRequest = "$baseUrl/get-service-request";
  static const getServiceUserRequest = "$baseUrl/get-user-request";
  static const serviceRequestDecline = "$baseUrl/service-request-decline";
  static const serviceRequestAccept = "$baseUrl/add-service-job";
  static const getJobs = "$baseUrl/service-job-by-status";
  static const getServiceRequest = "$baseUrl/get-service-provider-request";
  static const getServiceProviderJob = "$baseUrl/get-service-provider-job";
  static const getServiceJobDetail = "$baseUrl/get-job-detail";
  static const getServiceFeedback = "$baseUrl/get-provider-rating";

  // favourite providerx`
  static const addFavouriteProvider = "$baseUrl/add-fav-provider";
  static const addFavouriteService = "$baseUrl/add-fav-service";
  static const getFavourite = "$baseUrl/get-favourite";

  // contract api
  static const addContract = "$baseUrl/add-contract";
  static const getTenantContract = "$baseUrl/get-contract";
  static const getLandlordContract = "$baseUrl/get-landlord-contract";
  static const acceptContract = "$baseUrl/mark-contract-status";
  static const contractDetail = "$baseUrl/get-contract-detail";

  //Profile
  static const updateProfile = "$baseUrl/update-profile";
  static const updatePassword = "$baseUrl/update-password";
  static const forgotPassword = "$baseUrl/forgot-password";
  static const deleteUser = "$baseUrl/user/delete";

  static const makeFeedBack = "$baseUrl/make-service-feedback";
}