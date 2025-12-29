import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:home_cache/config/helper/app_snackbar.dart';
import 'package:home_cache/controller/schedule_controller.dart';
import 'package:home_cache/model/task_details_model.dart';
import 'package:home_cache/services/api_checker.dart';
import 'package:home_cache/services/api_clients.dart';
import 'package:home_cache/services/api_constants.dart';
import 'package:home_cache/model/task.dart';

class TaskController extends GetxController {
  var tasks = <Task>[].obs;
  var isLoading = false.obs;
  var selectedIndex = 0.obs;
  Rx<TaskDetailsModel?> taskDetails = Rx<TaskDetailsModel?>(null);

  RxInt totalTasks = 10.obs;
  RxInt completedTasks = 3.obs;

  final ScheduleController scheduleController = Get.put(ScheduleController());

  @override
  void onInit() {
    super.onInit();
    fetchAllTask(
      "upcoming",
    );
  }

  // ! When button clicked
  void selectOption(int index) {
    selectedIndex.value = index;

    if (index == 0) {
      fetchAllTask("upcoming");
    } else {
      fetchAllTask("overdue");
    }
  }

  //! Create Task api call
  Future<void> createTask(var data) async {
    isLoading(true);

    Response response = await ApiClient.postData(
      ApiConstants.createTask,
      jsonEncode(data),
    );

    if (response.statusCode == 200) {
      AppSnackbar.show(
        message: 'Task created successfully',
        type: SnackType.success,
      );
      Get.back();
      scheduleController.fetchAllSchedule();

      // fetchAllTask(
      //   "upcoming",
      // );
    } else {
      AppSnackbar.show(
        message: 'Failed to create task',
        type: SnackType.warning,
      );
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }

  // !Fetch task api call
  Future<void> fetchAllTask(String status) async {
    debugPrint('--------------');
    debugPrint(status);
    isLoading(true);

    Response response = await ApiClient.getData(ApiConstants.fetchTask,
        query: {'task_time': status});

    if (response.statusCode == 200) {
      var responseData = response.body;

      if (responseData['data'] != null) {
        var taskData = responseData['data'] as List;

        tasks.value = taskData.map<Task>((e) => Task.fromJson(e)).toList();
      }

      Get.back();
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }

  // !Fetch task details api call
  Future<void> fetchTaskDetails(String id) async {
    isLoading(true);

    Response response =
        await ApiClient.getData("${ApiConstants.fetchTaskDetails}$id");

    if (response.statusCode == 200) {
      var responseData = response.body;
      if (responseData['data'] != null) {
        taskDetails.value = TaskDetailsModel.fromJson(responseData['data']);
      }
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }

  // ! task mark complete
  Future<void> markTaskComplete(var data) async {
    isLoading(true);
    Response response =
        await ApiClient.patchData(ApiConstants.markTaskComplete, data);
    if (response.statusCode == 200) {
      AppSnackbar.show(
        message: 'Task completed successfully',
        type: SnackType.success,
      );
      Get.back();
      fetchAllTask(
        "upcoming",
      );
    } else {
      AppSnackbar.show(
        message: 'Failed to complete task',
        type: SnackType.warning,
      );
      ApiChecker.checkApi(response);
    }
  }

// ! change schedule date
  Future<void> changeScheduleDate(String id, var selectedDate) async {
    isLoading(true);

    Map<String, dynamic> body = {
      "date": selectedDate,
    };

    Response response = await ApiClient.patchData(
      "${ApiConstants.changeScheduleDate}$id",
      body,
    );

    isLoading(false);

    if (response.statusCode == 200) {
      AppSnackbar.show(
          message: 'Schedule date changed successfully',
          type: SnackType.success);
    } else {
      AppSnackbar.show(
        message: 'Failed to change schedule date',
        type: SnackType.warning,
      );
      ApiChecker.checkApi(response);
    }
  }

  //! Assign new member to task
  Future<void> assignNewMember(var data) async {
    isLoading(true);
    Response response =
        await ApiClient.patchData(ApiConstants.assignNewMember, data);
    if (response.statusCode == 200) {
      AppSnackbar.show(
        message: 'Member assigned successfully',
        type: SnackType.success,
      );
      // Get.back();
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
