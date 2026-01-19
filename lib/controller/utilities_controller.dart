import 'dart:io';

import 'package:get/get.dart';
import 'package:home_cache/config/helper/app_snackbar.dart';
import 'package:home_cache/config/route/route_names.dart';
import 'package:home_cache/model/utilities_type.dart';
import 'package:home_cache/model/utilities_type_details.dart';
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
  var utilityTypeList = <UtilityTypeData>[].obs;
  var utilityTypeDetailList = <UtilityTypeDetails>[].obs;

  @override
  void onInit() {
    // getUtilitiesTypes();
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
    try {
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
    } catch (e) {
      print('Error fetching utility component types: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // add utility
  Future<void> addUtility(var data) async {
    isLoading(true);

    // Ensure 'data' is a Map<String, dynamic>
    final Map<String, dynamic> safeData = Map<String, dynamic>.from(data);

    // Convert all values to strings
    final Map<String, String> stringData = safeData.map(
      (key, value) => MapEntry(key.toString(), value?.toString() ?? ''),
    );

    try {
      Response response = await ApiClient.postMultipartData(
        ApiConstants.addUtility,
        stringData,
        multipartBody: selectedFile.value != null
            ? [MultipartBody('files', selectedFile.value!)]
            : [MultipartBody('image', selectedImageFile.value!)],
      );

      if (response.statusCode == 200) {
        AppSnackbar.show(
          message: "Utility added successfully",
          type: SnackType.success,
        );
        await Future.delayed(const Duration(seconds: 2));
        Get.offAllNamed(RouteNames.viewByType);
      } else {
        AppSnackbar.show(
          message: "Failed to add utility",
          type: SnackType.error,
        );
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      AppSnackbar.show(
        message: "Error: $e",
        type: SnackType.error,
      );
    } finally {
      isLoading(false);
    }
  }

  // get utilities types data
  Future<void> getUtilitiesTypes() async {
    isLoading(true);
    Response response = await ApiClient.getData(ApiConstants.getUtilitiesTypes);
    if (response.statusCode == 200) {
      final responseData = response.body;
      utilityTypeList.clear();
      if (responseData['data'] != null) {
        final List list = responseData['data'];
        utilityTypeList.addAll(
          list.map((e) => UtilityTypeData.fromJson(e)).toList(),
        );
      }
    } else {
      ApiChecker.checkApi(response);
    }
    isLoading(false);
  }

  // get utility type details
  Future<void> getUtilityTypeDetails(String id) async {
    isLoading(true);
    Response response =
        await ApiClient.getData("${ApiConstants.getUtilityTypeDetails}$id");
    if (response.statusCode == 200) {
      final responseData = response.body;
      utilityTypeDetailList.clear();
      if (responseData['data'] != null) {
        final List list = responseData['data'];
        utilityTypeDetailList.addAll(
          list.map((e) => UtilityTypeDetails.fromJson(e)).toList(),
        );
      }
    } else {
      ApiChecker.checkApi(response);
    }
    isLoading(false);
  }
}
