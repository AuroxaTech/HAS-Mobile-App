import 'package:get/get.dart';
import 'package:property_app/controllers/authentication_controller/change_password_controller.dart';
import 'package:property_app/controllers/authentication_controller/forgot_password_controller.dart';
import 'package:property_app/controllers/authentication_controller/on_boarding_screen_controller.dart';
import 'package:property_app/controllers/authentication_controller/sign_up_controller.dart';
import 'package:property_app/controllers/chat_screens_controller/chat_convertion_screen_controller.dart';
import 'package:property_app/controllers/dasboard_controller/all_property_controller.dart';
import 'package:property_app/controllers/dasboard_controller/all_property_detail_controller.dart';
import 'package:property_app/controllers/dasboard_controller/dashoard_controller.dart';
import 'package:property_app/controllers/dasboard_controller/home_screen_controller.dart';
import 'package:property_app/controllers/jobs_controller/job_detail_screen.dart';
import 'package:property_app/controllers/jobs_controller/jobs_screen_controller.dart';
import 'package:property_app/controllers/land_lord/add_property_controller.dart';
import 'package:property_app/controllers/land_lord/contract_detail_controller.dart';
import 'package:property_app/controllers/land_lord/contract_status_controller.dart';
import 'package:property_app/controllers/land_lord/my_property_controller.dart';
import 'package:property_app/controllers/land_lord/my_service_request_controller.dart';
import 'package:property_app/controllers/land_lord/profile_setting_screen_controller.dart';
import 'package:property_app/controllers/notification_conroller/notificatio_screens_controller.dart';
import 'package:property_app/controllers/payment_controller/payment_screen_controller.dart';
import 'package:property_app/controllers/services_provider_controller/add_service_controller.dart';
import 'package:property_app/controllers/services_provider_controller/calendar_controller.dart';
import 'package:property_app/controllers/services_provider_controller/calender_screen_controlelr.dart';
import 'package:property_app/controllers/services_provider_controller/create_offer_controller.dart';
import 'package:property_app/controllers/services_provider_controller/my_favourite_screen_controller.dart';
import 'package:property_app/controllers/services_provider_controller/my_service_screen_controller.dart';
import 'package:property_app/controllers/services_provider_controller/my_services_cotroller.dart';
import 'package:property_app/controllers/services_provider_controller/rating_controller.dart';
import 'package:property_app/controllers/services_provider_controller/service_listing_detail_controller.dart';
import 'package:property_app/controllers/services_provider_controller/service_listing_screen_controller.dart';
import 'package:property_app/controllers/services_provider_controller/service_provide_controller.dart';
import 'package:property_app/controllers/services_provider_controller/service_request_cotroller.dart';
import 'package:property_app/controllers/services_provider_controller/service_request_detail_screen_controller.dart';
import 'package:property_app/controllers/tenant_controllers/current_reneted.dart';
import 'package:property_app/controllers/tenant_controllers/tenant_contract_controller.dart';
import 'package:property_app/controllers/tenant_controllers/tenant_dashboard_controller.dart';
import 'package:property_app/views/land_lords/property_filter_screen.dart';

import '../controllers/authentication_controller/login_screen_controller.dart';
import '../controllers/authentication_controller/splash_screen_controller.dart';
import '../controllers/chat_screens_controller/chat_screen_controller.dart';
import '../controllers/land_lord/contract_controller.dart';
import '../controllers/land_lord/my_property_detail_controller.dart';
import '../controllers/land_lord/my_service_request_detail_controller.dart';
import '../controllers/services_provider_controller/ew_service_request_controller.dart';
import '../controllers/services_provider_controller/rate_expereince_controller.dart';
import '../controllers/stripe_payment_controller/stripe_payment_controller.dart';
import '../controllers/visitor_controllers/visitor_dashboard_controller.dart';

class ScreenBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashScreenController>(() => SplashScreenController());
    Get.lazyPut<OnBoardingScreenController>(() => OnBoardingScreenController());
    Get.lazyPut<LoginScreenController>(() => LoginScreenController());
    Get.lazyPut<SignUpController>(() => SignUpController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<MyPropertyController>(() => MyPropertyController());
    Get.lazyPut<AddPropertyController>(() => AddPropertyController());
    Get.lazyPut<ContractController>(() => ContractController());
    Get.lazyPut<TenantDashboardController>(() => TenantDashboardController());
    Get.lazyPut<ServiceProviderController>(() => ServiceProviderController());
    Get.lazyPut<AddServiceController>(() => AddServiceController());
    Get.lazyPut<RatingController>(() => RatingController());
    Get.lazyPut<MyServicesController>(() => MyServicesController());
    Get.lazyPut<CreateOfferController>(() => CreateOfferController());
    Get.lazyPut<CalendarScreenController>(() => CalendarScreenController());
    Get.lazyPut<ServiceRequestController>(() => ServiceRequestController());
    Get.lazyPut<ServiceRequestDetailScreenController>(
        () => ServiceRequestDetailScreenController());
    Get.lazyPut<PropertyFilterScreen>(() => const PropertyFilterScreen());
    Get.lazyPut<ServiceListingScreenController>(
        () => ServiceListingScreenController());
    Get.lazyPut<NewServiceRequestScreenController>(
        () => NewServiceRequestScreenController());
    Get.lazyPut<MyFavouriteScreenController>(
        () => MyFavouriteScreenController());
    Get.lazyPut<MyServicesDetailScreenController>(
        () => MyServicesDetailScreenController());
    Get.lazyPut<NotificationScreenController>(
        () => NotificationScreenController());
    Get.lazyPut<HomeScreenController>(() => HomeScreenController());
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
    Get.lazyPut<ChatScreenListController>(() => ChatScreenListController());
    Get.lazyPut<ChatConversionScreenController>(
        () => ChatConversionScreenController());
    Get.lazyPut<ServiceListingDetailScreenController>(
        () => ServiceListingDetailScreenController());
    Get.lazyPut<PaymentScreenController>(() => PaymentScreenController());
    Get.lazyPut<ProfileSettingsScreenController>(
        () => ProfileSettingsScreenController());
    Get.lazyPut<ContractStatusScreenController>(
        () => ContractStatusScreenController());
    Get.lazyPut<RateExperienceController>(() => RateExperienceController());
    Get.lazyPut<JobDetailController>(() => JobDetailController());
    Get.lazyPut<MyPropertyDetailController>(() => MyPropertyDetailController());
    Get.lazyPut<MyServiceRequestController>(() => MyServiceRequestController());
    Get.lazyPut<MyServiceRequestDetailController>(
        () => MyServiceRequestDetailController());
    Get.lazyPut<CalendarDetailController>(() => CalendarDetailController());
    Get.lazyPut<AllPropertyController>(() => AllPropertyController());
    Get.lazyPut<AllPropertyDetailController>(
        () => AllPropertyDetailController());
    Get.lazyPut<TenantContractController>(() => TenantContractController());
    Get.lazyPut<ContractDetailController>(() => ContractDetailController());
    Get.lazyPut<ChangePasswordController>(() => ChangePasswordController());
    Get.lazyPut<VisitorDashboardController>(() => VisitorDashboardController());
    Get.lazyPut<CurrentRantedPropertiesController>(
        () => CurrentRantedPropertiesController());
    Get.lazyPut<StripePaymentScreenController>(
        () => StripePaymentScreenController());
  }
}
