import 'package:get/get.dart';
import 'package:property_app/views/authentication_screens/add_property_details.dart';
import 'package:property_app/views/authentication_screens/forgot_password/forgot_password_screen.dart';
import 'package:property_app/views/authentication_screens/forgot_password/new_password_screen.dart';
import 'package:property_app/views/authentication_screens/forgot_password/verification_screen.dart';
import 'package:property_app/views/authentication_screens/login_screen.dart';
import 'package:property_app/views/authentication_screens/sign_up_screen.dart';
import 'package:property_app/views/chat_screens/chat_conversion_screen.dart';
import 'package:property_app/views/dashoard_screens/all_property_detail_screen.dart';
import 'package:property_app/views/dashoard_screens/all_property_screen.dart';
import 'package:property_app/views/dashoard_screens/dashboard_screen.dart';
import 'package:property_app/views/dashoard_screens/home_screen.dart';
import 'package:property_app/views/land_lords/add_property_screen.dart';
import 'package:property_app/views/land_lords/contract_detail_screen.dart';
import 'package:property_app/views/land_lords/contract_screen.dart';
import 'package:property_app/views/land_lords/contract_status_screen.dart';
import 'package:property_app/views/land_lords/job_detail_screen.dart';
import 'package:property_app/views/land_lords/job_screeen.dart';
import 'package:property_app/views/land_lords/my_property_screen.dart';
import 'package:property_app/views/land_lords/my_request_service_screen.dart';
import 'package:property_app/views/land_lords/my_service_request_detail_controller.dart';
import 'package:property_app/views/land_lords/propert_detail_screen.dart';
import 'package:property_app/views/land_lords/property_filter_screen.dart';
import 'package:property_app/views/notification_screens/notification_screen.dart';
import 'package:property_app/views/onboarding_screens/on_boarding_screen.dart';
import 'package:property_app/views/payment_screen/payment_screen.dart';
import 'package:property_app/views/service_provider/add_service.dart';
import 'package:property_app/views/service_provider/calendar_detail_screen.dart';
import 'package:property_app/views/service_provider/calender_screen.dart';
import 'package:property_app/views/service_provider/create_offer_screen.dart';
import 'package:property_app/views/service_provider/my_favourite_sreen.dart';
import 'package:property_app/views/service_provider/my_service_edit_screen.dart';
import 'package:property_app/views/service_provider/my_services.dart';
import 'package:property_app/views/service_provider/my_services_detail_screen.dart';
import 'package:property_app/views/service_provider/new_service_request_screen.dart';
import 'package:property_app/views/service_provider/rate_experience.dart';
import 'package:property_app/views/service_provider/rating_screen.dart';
import 'package:property_app/views/service_provider/service_detail_screen.dart';
import 'package:property_app/views/service_provider/service_filter_screen.dart';
import 'package:property_app/views/service_provider/service_listing_screen.dart';
import 'package:property_app/views/service_provider/service_request_detail_screen.dart';
import 'package:property_app/views/service_provider/service_request_screen.dart';
import 'package:property_app/views/service_provider/services_provider_screen.dart';
import 'package:property_app/views/settings/change_password_screen.dart';
import 'package:property_app/views/settings/profile_stting_screen.dart';
import 'package:property_app/views/tenant_profile/current_rented.dart';
import 'package:property_app/views/tenant_profile/tenant_contract_screen.dart';
import 'package:property_app/views/tenant_profile/tenent_dashboard.dart';
import '../app_constants/animations.dart';
import '../views/authentication_screens/splash_screen.dart';
import '../views/land_lords/edit_my_property_screen.dart';
import '../views/tenant_profile/tenant_contract_detail_screen.dart';
import 'constant_routes.dart';
import 'screen_bindings.dart';

class Routes {

  static List<GetPage> getPages() {
    return [
      GetPage(
          name: kSplashScreen,
          page: () => const SplashScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kIntroScreen,
          page: () => const OnBoardingScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kLoginScreen,
          page: () => const LoginScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kSignupScreen,
          page: () => const SignUpScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kAddDetailScreen,
          page: () => const AddPropertyDetailScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kDashboardScreen,
          page: () => const DashBoardScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kMyProperties,
          page: () => const MyPropertyScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kPropertyDetailScreen,
          page: () => const PropertyDetailScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kAddProperties,
          page: () => const AddPropertyScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kContractScreen,
          page: () => const ContractScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kTenantDashboard,
          page: () => const TenantDashboard(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kServiceProvider,
          page: () =>  ServiceProviderScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kAddServiceScreen,
          page: () => const AddServiceScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kRatingScreen,
          page: () => const RatingScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kMyServicesScreen,
          page: () => const MyServicesScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kCreateOfferScreen,
          page: () => const CreateOfferScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kCalendarScreen,
          page: () => const CalendarScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kServiceRequestScreen,
          page: () => const ServiceRequestScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kServiceRequestDetailScreen,
          page: () => const ServiceRequestDetailScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
     GetPage(
          name: kPropertyFilterScreen,
          page: () => const PropertyFilterScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kServiceListingScreen,
          page: () =>  ServicesListingScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kNewServiceRequestScreen,
          page: () => const NewServiceRequestScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kMyFavouriteScreen,
          page: () => const MyFavouriteScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kMyServicesScreenDetailScreen,
          page: () => const MyServicesDetailScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kNotificationScreen,
          page: () => const NotificationScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kHomeScreen,
          page: () => const HomeScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kForgotPasswordScreen,
          page: () => const ForgotPassword(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kVerificationScreen,
          page: () => const VerificationScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
     GetPage(
          name: kNewPasswordScreen,
          page: () => const NewPasswordScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      // GetPage(
      //     name: kChatConversionScreen,
      //     page: () => const ChatConversionScreen(),
      //     binding: ScreenBindings(),
      //     transition: routeTransition
      // ),
      GetPage(
          name: kServiceListingScreenDetail,
          page: () => const ServiceListingDetailScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kPaymentScreen,
          page: () => const PaymentsScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kProfileSettingScreen,
          page: () => const ProfileSettingsScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kContractStatusScreen,
          page: () => const ContractStatusScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kRateExperienceScreen,
          page: () => const RateExperience(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kJobScreen,
          page: () =>  JobsScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kJobDetailScreen,
          page: () => const JobDetailScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kEditPropertyScreen,
          page: () => const EditMyPropertyScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kEditServiceScreen,
          page: () => const MyServiceEditScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kMyServiceRequestScreen,
          page: () => const MyServiceRequest(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kMyServiceRequestDetailScreen,
          page: () => const MyServiceRequestDetailScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
     GetPage(
          name: kCalendarDetailScreen,
          page: () => const CalendarDetailScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
    GetPage(
          name: kAllPropertyScreen,
          page: () =>  AllPropertyScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
    GetPage(
          name: kAllPropertyDetailScreen,
          page: () => const AllPropertyDetailScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
    GetPage(
          name: kTenantContractScreen,
          page: () => const TenantContractScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
    GetPage(
          name: kContractDetailScreen,
          page: () => const ContractDetailScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
    GetPage(
          name: kTenantContractDetailScreen,
          page: () => const TenantContractDetailScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kChangePasswordScreen,
          page: () => const ChangePassword(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),
      GetPage(
          name: kServiceFilterScreen,
          page: () => const ServiceFilterScreen(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),

      GetPage(
          name: kCurrentRentedScreen,
          page: () => const CurrentRented(),
          binding: ScreenBindings(),
          transition: routeTransition
      ),

    ];
  }
}
