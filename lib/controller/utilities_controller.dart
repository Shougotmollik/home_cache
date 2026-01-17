import 'dart:io';

import 'package:get/get.dart';
import 'package:home_cache/model/utility_component_type.dart';
import 'package:home_cache/model/utility_model.dart';
import 'package:home_cache/services/api_checker.dart';
import 'package:home_cache/services/api_clients.dart';
import 'package:home_cache/services/api_constants.dart';

class UtilitiesController extends GetxController {
  var isLoading = false.obs;

  var selectedImageFile = Rx<File?>(null);
  var selectedFile = Rx<File?>(null);

  var utilityComponents = <UtilityComponent>[].obs;
  var utilityComponentType = <UtilityComponentType>[].obs;

  @override
  void onInit() {
    getUtilityComponents();

    super.onInit();
  }

// get utility components
  Future<void> getUtilityComponents() async {
    try {
      isLoading.value = true;

      Response response =
          await ApiClient.getData(ApiConstants.utilitiesComponents);

      if (response.statusCode == 200) {
        final responseData = response.body;

        utilityComponents.clear();

        if (responseData['data'] != null) {
          final List list = responseData['data'];
          utilityComponents.addAll(
            list.map((e) => UtilityComponent.fromJson(e)).toList(),
          );
        }
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      print('Error fetching utility components: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // get utility component types
  Future<void> getUtilityComponentTypes(String id) async {
    isLoading.value = true;

    Response response =
        await ApiClient.getData("${ApiConstants.utilitiesComponentsType}$id");
    if (response.statusCode == 200) {
      final responseData = response.body;
      utilityComponentType.clear();
      if (responseData['data'] != null) {
        final List list = responseData['data'];
        utilityComponentType.addAll(
          list.map((e) => UtilityComponentType.fromJson(e)).toList(),
        );
      }
    } else {
      ApiChecker.checkApi(response);
    }
  }
}
