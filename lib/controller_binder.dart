import 'package:get/get.dart';
import 'package:home_cache/controller/auth_controller.dart';
import 'package:home_cache/controller/dialong_controller.dart';
import 'package:home_cache/controller/onboarding_choice_controller.dart';
import 'package:home_cache/controller/profile_controller.dart';
import 'package:home_cache/controller/schedule_controller.dart';
import 'package:home_cache/controller/task_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.lazyPut<DialongController>(() => DialongController());
    Get.lazyPut<OnboardingChoiceController>(() => OnboardingChoiceController());
    Get.lazyPut<TaskController>(
      () => TaskController(),
    );
    Get.put(ProfileController());
    Get.lazyPut<ScheduleController>(() => ScheduleController());
  }
}
