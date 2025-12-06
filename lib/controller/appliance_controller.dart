import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:home_cache/config/route/route_names.dart';
import 'package:home_cache/model/appliance.dart';
import 'package:home_cache/model/appliance_category.dart';
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
  var appliancesByCategoryList = <Appliance>[].obs;

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
        for (var item in responseData['data']) {
          try {
            appliancesByCategoryList.add(Appliance.fromJson(item));
          } catch (e) {
            print("Skipping invalid appliance: $e");
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

    // Encode nested details JSON
    if (data['details'] != null) {
      data['details'] = jsonEncode(data['details']);
    }

    // Safe Map<String, String> conversion
    Map<String, String> newData = {};
    data.forEach((key, value) {
      if (value != null) {
        newData[key] = value.toString();
      }
    });

    // Build multipart list (send both)
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
}
