import 'package:get/get.dart';
import 'package:home_cache/config/helper/app_snackbar.dart';
import 'package:home_cache/model/schedule_model.dart';
import 'package:home_cache/services/api_checker.dart';
import 'package:home_cache/services/api_clients.dart';
import 'package:home_cache/services/api_constants.dart';

class ScheduleController extends GetxController {
  var isLoading = false.obs;

  var schedule = <ScheduleModel>[].obs;

  @override
  void onInit() {
    fetchAllSchedule();
    super.onInit();
  }

  // ! Get all schedule
  Future<void> fetchAllSchedule() async {
    isLoading(true);
    var response = await ApiClient.getData(ApiConstants.fetchScheduleData);
    if (response.statusCode == 200) {
      var responseData = response.body;
      if (responseData['data'] != null) {
        var scheduleData = responseData['data'] as List;
        schedule.value = scheduleData
            .map<ScheduleModel>((e) => ScheduleModel.fromJson(e))
            .toList();
      }
    } else {
      ApiChecker.checkApi(response);
    }
    isLoading(false);
  }

  //! Assign new member to task
  Future<void> assignNewProvider(var data) async {
    isLoading(true);
    Response response =
        await ApiClient.patchData(ApiConstants.assignNewMember, data);
    if (response.statusCode == 200) {
      AppSnackbar.show(
        message: 'provider assigned successfully',
        type: SnackType.success,
      );
      Get.back();
      // fetchTaskDetails('id');
    } else {
      AppSnackbar.show(
        message: 'Something went wrong',
        type: SnackType.warning,
      );
      ApiChecker.checkApi(response);
    }
  }
}
