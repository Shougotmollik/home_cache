import 'package:get/get.dart';
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
}
