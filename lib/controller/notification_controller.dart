import 'package:get/get.dart';
import 'package:home_cache/config/helper/app_snackbar.dart';
import 'package:home_cache/model/notification_model.dart';
import 'package:home_cache/services/api_checker.dart';
import 'package:home_cache/services/api_clients.dart';
import 'package:home_cache/services/api_constants.dart';

class NotificationController extends GetxController {
  var isLoading = false.obs;
  var taskNotificationList = <TaskNotification>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTaskNotification();
  }

  // ! task notification
  Future<void> fetchTaskNotification() async {
    isLoading(true);
    final Response response =
        await ApiClient.getData(ApiConstants.taskNotification);
    if (response.statusCode == 200) {
      var responseData = response.body;
      if (responseData['data'] != null) {
        var taskData = responseData['data'] as List;
        taskNotificationList.value = taskData
            .map<TaskNotification>((e) => TaskNotification.fromJson(e))
            .toList();
      }
    } else {
      ApiChecker.checkApi(response);
    }
    isLoading(false);
  }

  // ! task notification mark as done
  Future<void> markAsDone(var data) async {
    isLoading(true);
    final Response response =
        await ApiClient.patchData(ApiConstants.markNotificationAsRead, data);
    if (response.statusCode == 200) {
      fetchTaskNotification();
      AppSnackbar.show(
        message: 'Notification marked as read',
        type: SnackType.success,
      );
    } else {
      ApiChecker.checkApi(response);
      AppSnackbar.show(
        message: 'Failed to mark notification as done',
        type: SnackType.warning,
      );
    }
    isLoading(false);
  }
}
