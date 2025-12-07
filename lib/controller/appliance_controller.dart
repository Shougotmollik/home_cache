import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_cache/config/route/route_names.dart';
import 'package:home_cache/model/appliance.dart';
import 'package:home_cache/model/appliance_category.dart';
import 'package:home_cache/model/appliance_details_model.dart';
import 'package:home_cache/model/appliance_type.dart';
import 'package:home_cache/services/api_checker.dart';
import 'package:home_cache/services/api_clients.dart';
import 'package:home_cache/services/api_constants.dart';

class ApplianceController extends GetxController {
  var isLoading = false.obs;
  var selectedFile = Rx<File?>(null);
  var selectedImageFile = Rx<File?>(null);

  var applianceTypeList = <ApplianceType>[].obs;
  var applianceCategoryList = <ApplianceCategory>[].obs;
  var appliancesByCategoryList = <ApplianceModel>[].obs;
  var applianceDetails = Rx<ApplianceDetailsModel?>(null);

  // Controllers for editing
  late TextEditingController typeController;
  late TextEditingController locationController;
  late TextEditingController notesController;

  @override
  void onInit() {
    super.onInit();
    typeController = TextEditingController();
    locationController = TextEditingController();
    notesController = TextEditingController();
  }

  @override
  void onClose() {
    typeController.dispose();
    locationController.dispose();
    notesController.dispose();
    super.onClose();
  }

  /// Safely extract file extension
  String? _extension() {
    final file = selectedFile.value;
    if (file == null) return null;

    final segments = file.path.split('.');
    if (segments.length < 2) return null;

    return segments.last.toLowerCase();
  }

  /// Check if the file is an image
  bool isImage() {
    final ext = _extension();
    if (ext == null) return false;

    const imageExt = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'heic'];
    return imageExt.contains(ext);
  }

  /// Check if the file is a PDF
  bool isPDF() {
    final ext = _extension();
    return ext == 'pdf';
  }

  /// Check if file is a document (pdf, doc, excel)
  bool isDocument() {
    final ext = _extension();
    if (ext == null) return false;

    const docExt = ['pdf', 'doc', 'docx', 'xls', 'xlsx'];
    return docExt.contains(ext);
  }

  /// Remove selected file
  void removeFile() {
    selectedFile.value = null;
  }

  // ! get appliance types
  Future<void> getApplianceTypes(String id) async {
    isLoading(true);

    Response response = await ApiClient.getData("/view-by-type/appliance/$id");

    if (response.statusCode == 200) {
      final responseData = response.body;

      if (responseData['data'] != null) {
        applianceTypeList.clear();
        for (var item in responseData['data']) {
          applianceTypeList.add(ApplianceType.fromJson(item));
        }
      }
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }

  // ! get appliance categories
  Future<void> getApplianceCategories() async {
    isLoading(true);

    Response response =
        await ApiClient.getData("/view-by-type/users-all-appliance");

    if (response.statusCode == 200) {
      final responseData = response.body;

      if (responseData['data'] != null) {
        applianceCategoryList.clear();
        for (var item in responseData['data']) {
          applianceCategoryList.add(ApplianceCategory.fromJson(item));
        }
      }
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }

  // ! get appliances by category
  Future<void> getAppliancesByCategory(String categoryId) async {
    isLoading(true);

    Response response = await ApiClient.getData(
        "/view-by-type/users-single-appliance-all-details/$categoryId");

    if (response.statusCode == 200) {
      final responseData = response.body;

      if (responseData['data'] != null) {
        appliancesByCategoryList.clear();

        final dataMap = responseData['data'] as Map<String, dynamic>;

        // iterate through map values
        for (var item in dataMap.values) {
          try {
            appliancesByCategoryList.add(ApplianceModel.fromJson(item));
          } catch (e) {
            debugPrint("Skipping invalid appliance: $e");
          }
        }
      }
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }

  // ! add new appliance
  Future<void> addNewAppliance(var data) async {
    isLoading(true);
    if (data['details'] != null) {
      data['details'] = jsonEncode(data['details']);
    }
    Map<String, String> newData = {};
    data.forEach((key, value) {
      if (value != null) {
        newData[key] = value.toString();
      }
    });
    List<MultipartBody> multiParts = [];

    if (selectedImageFile.value != null) {
      multiParts.add(MultipartBody('image', selectedImageFile.value!));
    }

    if (selectedFile.value != null) {
      multiParts.add(MultipartBody('files', selectedFile.value!));
    }

    Response response = await ApiClient.postMultipartData(
      ApiConstants.addNewAppliance,
      newData,
      multipartBody: multiParts,
    );

    if (response.statusCode == 200) {
      await Future.delayed(const Duration(seconds: 1));
      Get.offAllNamed(RouteNames.viewByType);
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }

  // ! get appliance details
  Future<void> getApplianceDetails(String id) async {
    try {
      isLoading(true);

      final response = await ApiClient.getData("/view-by-type/details/$id");

      if (response.statusCode == 200) {
        final responseData = response.body;
        if (responseData['data'] != null) {
          final details = ApplianceDetailsModel.fromJson(responseData['data']);
          typeController.text = details.userAppliance?.appliance?.name ?? '';
          locationController.text = details.room?.name ?? '';
          notesController.text = details.details?.notes?.toString() ?? '';
          applianceDetails.value = details;
        }
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      debugPrint("Error fetching appliance details: $e");
    } finally {
      isLoading(false);
    }
  }

  // ! update appliance details
  Future<void> updateApplianceDetails(String id, var data) async {
    isLoading(true);

    if (data['details'] != null) {
      data['details'] = jsonEncode(data['details']);
    }

    Map<String, String> newData = {};
    data.forEach((key, value) {
      if (value != null) {
        newData[key] = value.toString();
      }
    });

    List<MultipartBody> multiParts = [];

    if (selectedImageFile.value != null) {
      multiParts.add(MultipartBody('image', selectedImageFile.value!));
    }

    if (selectedFile.value != null) {
      multiParts.add(MultipartBody('files', selectedFile.value!));
    }

    // API call
    Response response = await ApiClient.patchMultipartData(
      "${ApiConstants.updateAppliance}$id",
      newData,
      multipartBody: multiParts,
    );

    if (response.statusCode == 200) {
      await Future.delayed(const Duration(seconds: 1));
      Get.back();
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }
}
