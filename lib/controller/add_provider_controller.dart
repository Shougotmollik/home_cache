import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_cache/controller/provider_controller.dart';
import 'package:home_cache/services/api_checker.dart';
import 'package:home_cache/services/api_clients.dart';
import 'package:home_cache/services/api_constants.dart';

/// Controller for Add/Update Provider
class AddProviderController extends GetxController {
  final ProviderController _providerController = Get.find<ProviderController>();

  var selectedType = ''.obs;
  var companyName = ''.obs;
  var fullName = ''.obs;
  var phoneNumber = ''.obs;
  var url = ''.obs;
  var rating = 3.obs;
  var isLoading = false.obs;
  var selectedFile = Rx<File?>(null);

  // Check if the selected file is an image
  bool isImage() {
    if (selectedFile.value == null) return false;
    final ext = selectedFile.value!.path.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif'].contains(ext);
  }

  // Remove file
  void removeFile() {
    selectedFile.value = null;
  }

  /// Validate required fields
  bool validateFields() {
    return selectedType.isNotEmpty &&
        companyName.isNotEmpty &&
        fullName.isNotEmpty &&
        phoneNumber.isNotEmpty;
  }

  /// Add new provider
  Future<void> addProvider(Map<String, String> data) async {
    isLoading(true);

    /// Call API with one file
    Response response = await ApiClient.postMultipartData(
      ApiConstants.addProvider,
      data,
      multipartBody: selectedFile.value != null
          ? [MultipartBody('files', selectedFile.value!)]
          : [],
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          content: Text('Provider added successfully'),
        ),
      );
      Get.back();
      _providerController.fetchAllProviders();
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          content: Text('Failed to add provider'),
        ),
      );
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }

  /// Submit new provider
  Future<void> submitProvider() async {
    if (!validateFields()) return;

    Map<String, String> data = {
      "type": selectedType.value,
      "company": companyName.value,
      "name": fullName.value,
      "mobile": phoneNumber.value,
      "web_url": url.value,
      "rating": rating.value.toString(),
    };

    await addProvider(data);
  }

  /// Update existing provider
  Future<void> updateProvider(Map<String, String> data, String id) async {
    isLoading(true);

    Response response = await ApiClient.patchMultipartData(
      "${ApiConstants.updateProvider}$id",
      data,
      multipartBody: selectedFile.value != null
          ? [MultipartBody('files', selectedFile.value!)]
          : [],
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          content: Text('Provider updated successfully'),
        ),
      );
      Get.back();
      _providerController.fetchProviderDetails(id);
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          content: Text('Failed to update provider'),
        ),
      );
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }

  Future<void> submitUpdateProvider(String id) async {
    if (!validateFields()) return;

    Map<String, String> data = {
      "type": selectedType.value,
      "company": companyName.value,
      "name": fullName.value,
      "mobile": phoneNumber.value,
      "web_url": url.value,
      "rating": rating.value.toString(),
    };

    await updateProvider(data, id);
  }
}
