import 'package:get/get.dart';
import 'package:home_cache/model/home_health_data.dart' hide MyData;
import 'package:home_cache/model/home_task_data.dart';
import 'package:home_cache/services/api_checker.dart';
import 'package:home_cache/services/api_clients.dart';
import 'package:home_cache/services/api_constants.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;

  var homeTaskData = Rxn<HomeTaskHealth>();

  final homeHealth = HomeHealthModel(
    health: 0,
    totalTasks: 0,
    completedTasks: 0,
  ).obs;

  // Add MyData
  final myData = MyData(completed: 0, pending: 0).obs;

  @override
  void onInit() {
    super.onInit();
    getHomeHealthWithTask();
    getHomeHealth();
  }

  Future<void> getHomeHealth() async {
    try {
      isLoading(true);

      final response = await ApiClient.getData(ApiConstants.homeHealthData);

      if (response.statusCode == 200) {
        final responseData = response.body;
        if (responseData['data'] != null) {
          homeHealth.value =
              HomeHealthModel.fromJson(responseData['data']['home_health']);

          // Update myData
          myData.value = MyData(
            completed: homeHealth.value.completedTasks,
            pending:
                homeHealth.value.totalTasks - homeHealth.value.completedTasks,
          );
        }
      } else {
        ApiChecker.checkApi(response);
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> getHomeHealthWithTask() async {
    try {
      isLoading(true);

      final response = await ApiClient.getData(ApiConstants.homeTaskData);

      if (response.statusCode == 200) {
        final responseData = response.body;

        if (responseData['data'] != null) {
          homeTaskData.value = HomeTaskHealth.fromJson(responseData['data']);
        }
      } else {
        ApiChecker.checkApi(response);
      }
    } finally {
      isLoading(false);
    }
  }
}
