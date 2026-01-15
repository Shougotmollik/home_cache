import 'dart:io';

import 'package:get/get.dart';
import 'package:home_cache/config/helper/app_snackbar.dart';
import 'package:home_cache/config/route/route_names.dart';
import 'package:home_cache/model/paint_item.dart';
import 'package:home_cache/model/room_with_paint.dart';
import 'package:home_cache/services/api_checker.dart';
import 'package:home_cache/services/api_clients.dart';
import 'package:home_cache/services/api_constants.dart';

class PaintController extends GetxController {
  var isLoading = false.obs;

  final roomWithPaint = Rxn<RoomWithPaint>();
  final paintItemList = <PaintItem>[].obs;
  var selectedFile = Rx<File?>(null);

  @override
  void onReady() {
    super.onReady();
    fetchRoomWithPaint();
  }

  // ! Fetch room with paint data

  Future<void> fetchRoomWithPaint() async {
    isLoading(true);
    final Response response =
        await ApiClient.getData(ApiConstants.fetchRoomWithPaint);

    if (response.statusCode == 200) {
      final jsonData = response.body['data'];
      roomWithPaint.value = RoomWithPaint.fromJson(jsonData);
    } else {
      print('Error fetching room with paint data: ${response.statusCode}');
    }
    isLoading(false);
  }

  // ! Fetch with paint data list
  Future<void> fetchingPaintItem(String roomId, String itemId) async {
    isLoading(true);

    final Response response = await ApiClient.getData(
        "${ApiConstants.fetchPaintItem}$roomId/$itemId");

    if (response.statusCode == 200) {
      var jsonData = response.body['data'];
      paintItemList.value =
          jsonData.map<PaintItem>((e) => PaintItem.fromJson(e)).toList();
    } else {
      ApiChecker.checkApi(response);
    }
    isLoading(false);
  }

  // ! add new paint item
  Future<void> addNewPaintItem(Map<String, dynamic> data) async {
    isLoading(true);
    final Map<String, String> stringData =
        data.map((key, value) => MapEntry(key, value.toString()));

    final Response response = await ApiClient.postMultipartData(
      ApiConstants.addNewPaintItem,
      stringData,
      multipartBody: selectedFile.value != null
          ? [MultipartBody('file', selectedFile.value!)]
          : [],
    );

    if (response.statusCode == 200) {
      AppSnackbar.show(
        message: 'Paint Item added successfully',
        type: SnackType.success,
      );
      Get.toNamed(RouteNames.viewByType);
    } else {
      AppSnackbar.show(
        message: 'Failed to add paint item',
        type: SnackType.error,
      );
    }

    isLoading(false);
  }

  // ! update paint item data
  Future<void> updatePaintItemDetails(
    Map<String, dynamic> data,
    String id,
  ) async {
    isLoading(true);

    final Map<String, String> stringData = data.map((key, value) => MapEntry(
          key.toString(),
          value.toString(),
        ));

    final Response response = await ApiClient.patchMultipartData(
      "${ApiConstants.updatePaintItemDetails}$id",
      stringData,
      multipartBody: selectedFile.value != null
          ? [MultipartBody('file', selectedFile.value!)]
          : [],
    );

    if (response.statusCode == 200) {
      AppSnackbar.show(
        message: 'Paint Item updated successfully',
        type: SnackType.success,
      );
      Get.toNamed(RouteNames.viewByType);
    } else {
      AppSnackbar.show(
        message: 'Failed to update paint item',
        type: SnackType.error,
      );
    }

    isLoading(false);
  }
}
