import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:home_cache/config/route/route_names.dart';
import 'package:home_cache/controller_binder.dart';
import 'package:home_cache/view/auth/login/login_screen.dart';
import 'package:home_cache/view/auth/onboarding/onboarding_screen.dart';
import 'package:home_cache/view/auth/signup/onboardingSignup/screens/address_form_screen.dart';
import 'package:home_cache/view/auth/signup/onboardingSignup/screens/select_cooling_type_screen.dart';
import 'package:home_cache/view/auth/signup/onboardingSignup/screens/select_heat_power_type_screen.dart';
import 'package:home_cache/view/auth/signup/onboardingSignup/screens/select_heating_type.dart';
import 'package:home_cache/view/auth/signup/onboardingSignup/screens/select_power_type.dart';
import 'package:home_cache/view/auth/signup/onboardingSignup/screens/select_reponsible_type_screen.dart';
import 'package:home_cache/view/auth/signup/onboardingSignup/screens/select_role_screen.dart';
import 'package:home_cache/view/auth/signup/onboardingSignup/screens/select_type_of_house_screen.dart';
import 'package:home_cache/view/auth/signup/onboardingSignup/screens/select_water_supply_type_screen.dart';
import 'package:home_cache/view/auth/signup/screens/add_details_iteam_screen.dart';
import 'package:home_cache/view/auth/signup/screens/finish_utility_screen.dart';
import 'package:home_cache/view/auth/signup/screens/home_item_tracker.dart';
import 'package:home_cache/view/auth/signup/screens/select_item_screen.dart';
import 'package:home_cache/view/auth/signup/screens/signup_screen.dart';
import 'package:home_cache/view/auth/splash/splash_screen.dart';
import 'package:home_cache/view/home/Bottom_nav_bar/bottom_nav_bar.dart';
import 'package:home_cache/view/home/account/householdmanagement/screens/household_management_screen.dart';
import 'package:home_cache/view/home/account/productsupport/screens/product_support_screen.dart';
import 'package:home_cache/view/home/account/profilesetting/screens/profile_setting_screen.dart';
import 'package:home_cache/view/home/account/profilesetting/widgets/delete_account_screen.dart';
import 'package:home_cache/view/home/account/profilesetting/widgets/edit_contact_information_screen.dart';
import 'package:home_cache/view/home/account/profilesetting/widgets/password_settings_screen.dart';
import 'package:home_cache/view/home/account/profilesetting/widgets/privacy_policy_screen.dart';
import 'package:home_cache/view/home/account/profilesetting/widgets/terms_of_use_screen.dart';
import 'package:home_cache/view/home/account/subscription/billing_address_screen.dart';
import 'package:home_cache/view/home/account/subscription/card_info_screen.dart';
import 'package:home_cache/view/home/account/subscription/subscription_screen.dart';
import 'package:home_cache/view/home/chat/screens/chat_screen.dart';
import 'package:home_cache/view/home/details/documents/add_documents_details_screen.dart';
import 'package:home_cache/view/home/details/documents/add_documents_screen.dart';
import 'package:home_cache/view/home/details/documents/documents_details_screen.dart';
import 'package:home_cache/view/home/details/documents/documents_screen.dart';
import 'package:home_cache/view/home/details/documents/preview_document_screen.dart';
import 'package:home_cache/view/home/details/providers/add_provider_screen.dart';
import 'package:home_cache/view/home/details/providers/provider_details_screen.dart';
import 'package:home_cache/view/home/details/providers/provider_screen.dart';
import 'package:home_cache/view/home/details/providers/update_provider_screen.dart';
import 'package:home_cache/view/home/details/room/add_new_room_item_screen.dart';
import 'package:home_cache/view/home/details/room/add_room_screen.dart';
import 'package:home_cache/view/home/details/room/edit_room_details_screen.dart';
import 'package:home_cache/view/home/details/room/room_screen.dart';
import 'package:home_cache/view/home/details/room/update_room_item_screen.dart';
import 'package:home_cache/view/home/details/type/appliances/add_appliances_screen.dart';
import 'package:home_cache/view/home/details/type/appliances/appliances_screen.dart';
import 'package:home_cache/view/home/details/type/appliances/edit_appliances_screen.dart';
import 'package:home_cache/view/home/details/type/materials/material_screen.dart';
import 'package:home_cache/view/home/details/type/utility/utility_screen.dart';
import 'package:home_cache/view/home/details/type/view_by_type_screen.dart';
import 'package:home_cache/view/home/home/screens/home_health_screen.dart';
import 'package:home_cache/view/home/notification/notification_details_screen.dart';
import 'package:home_cache/view/home/notification/screens/notification_screen.dart';
import 'package:home_cache/view/home/notification/widgets/calendar_screen.dart';

class AppRoutes {
  static final pages = [
    GetPage(name: RouteNames.splash, page: () => const SplashScreen()),
    GetPage(name: RouteNames.onboard, page: () => const OnboardingScreen()),
    GetPage(
        name: RouteNames.login,
        page: () => const LoginScreen(),
        binding: ControllerBinder()),
    GetPage(
        name: RouteNames.signup,
        page: () => const SignupScreen(),
        binding: ControllerBinder()),
    GetPage(
        name: RouteNames.selectHouse,
        page: () => const SelectTypeOfHouseScreen()),
    GetPage(
        name: RouteNames.homeInfo,
        page: () => AddressFormScreen(),
        binding: ControllerBinder()),
    GetPage(
        name: RouteNames.selectPowerType,
        page: () => const SelectPowerTypeScreen(),
        binding: ControllerBinder()),
    GetPage(
        name: RouteNames.selectWaterSupply,
        page: () => const SelectWaterSupplyTypeScreen(),
        binding: ControllerBinder()),
    GetPage(
        name: RouteNames.selectHeatPowerType,
        page: () => const SelectHeatPowerTypeScreen(),
        binding: ControllerBinder()),
    GetPage(
        name: RouteNames.selectCoolingType,
        page: () => const SelectCoolingTypeScreen(),
        binding: ControllerBinder()),
    GetPage(
        name: RouteNames.selectHeatingType,
        page: () => const SelectHeatingTypeScreen(),
        binding: ControllerBinder()),
    GetPage(
        name: RouteNames.selectResponsibleType,
        page: () => const SelectResponsibleTypeScreen(),
        binding: ControllerBinder()),
    GetPage(
        name: RouteNames.selectHouseRole,
        page: () => const SelectHouseRoleScreen(),
        binding: ControllerBinder()),
    GetPage(
        name: RouteNames.finishUtility,
        page: () => const FinishUtilityScreen(),
        binding: ControllerBinder()),
    GetPage(
        name: RouteNames.trackList,
        page: () => const TrackListScreen(),
        binding: ControllerBinder()),
    GetPage(name: RouteNames.selectIteam, page: () => const SelectItemScreen()),
    GetPage(
        name: RouteNames.addDetailsIteam,
        page: () => const AddDetailsIteamScreen(),
        binding: ControllerBinder()),
    GetPage(
        name: RouteNames.bottomNav,
        page: () => const BottomNavBar(),
        binding: ControllerBinder()),
    GetPage(name: RouteNames.homeHealth, page: () => const HomeHealthScreen()),
    GetPage(name: RouteNames.chat, page: () => ChatScreen()),
    GetPage(
      name: RouteNames.provider,
      page: () => const ProviderScreen(),
    ),
    GetPage(
        name: RouteNames.providerDetails,
        page: () => const ProviderDetailsScreen()),
    GetPage(name: RouteNames.addProvider, page: () => AddProviderScreen()),
    GetPage(
      name: RouteNames.updateProvider,
      page: () => const UpdateProviderScreen(),
    ),
    GetPage(name: RouteNames.documents, page: () => DocumentsScreen()),
    GetPage(
        name: RouteNames.addDocuments, page: () => const AddDocumentsScreen()),
    GetPage(
        name: RouteNames.previewDocument,
        page: () => const PreviewDocumentScreen()),
    GetPage(
      name: RouteNames.addDocumentsDetails,
      page: () => const AddDocumentsDetailsScreen(),
    ),
    GetPage(
        name: RouteNames.documentsDetails,
        page: () => const DocumentsDetailsScreen()),
    GetPage(name: RouteNames.viewByType, page: () => const ViewByTypeScreen()),
    GetPage(name: RouteNames.appliances, page: () => const AppliancesScreen()),
    GetPage(
        name: RouteNames.addAppliances,
        page: () => const AddAppliancesScreen()),
    GetPage(
        name: RouteNames.editAppliances,
        page: () => const EditAppliancesScreen()),
    GetPage(name: RouteNames.room, page: () => const RoomScreen()),
    GetPage(name: RouteNames.addRoom, page: () => const AddRoomScreen()),
    GetPage(
        name: RouteNames.editRoomDetails,
        page: () => const EditRoomDetailsScreen()),
    GetPage(
        name: RouteNames.addNewRoomIteam,
        page: () => const AddNewRoomItemScreen()),
    GetPage(
        name: RouteNames.updateRoomItem,
        page: () => const UpdateRoomItemScreen()),
    GetPage(
        name: RouteNames.subscription, page: () => const SubscriptionScreen()),
    GetPage(
        name: RouteNames.billingAddress,
        page: () => const BillingAddressScreen()),
    GetPage(name: RouteNames.cardInfo, page: () => const CardInfoScreen()),
    GetPage(
        name: RouteNames.profileSetting,
        page: () => const ProfileSettingScreen()),
    GetPage(
        name: RouteNames.privacyPolicy,
        page: () => const PrivacyPolicyScreen()),
    GetPage(name: RouteNames.termsOfUse, page: () => const TermsOfUseScreen()),
    GetPage(
      name: RouteNames.editContactInfo,
      page: () => const EditContactInformationScreen(),
    ),
    GetPage(
        name: RouteNames.passwordSettings,
        page: () => const PasswordSettingsScreen()),
    GetPage(
        name: RouteNames.deleteAccount,
        page: () => const DeleteAccountScreen()),
    GetPage(
        name: RouteNames.productSupport,
        page: () => const ProductSupportScreen()),
    GetPage(
      name: RouteNames.householdManagement,
      page: () => const HouseholdManagementScreen(),
    ),
    GetPage(
        name: RouteNames.notifications, page: () => const NotificationScreen()),
    GetPage(
      name: RouteNames.notificationDetails,
      page: () => const NotificationDetailsScreen(),
    ),
    GetPage(
      name: RouteNames.utility,
      page: () => const UtilityScreen(),
    ),
    GetPage(
      name: RouteNames.material,
      page: () => const MaterialScreen(),
    ),
    GetPage(name: RouteNames.calendar, page: () => const CalendarScreen()),
  ];
}
