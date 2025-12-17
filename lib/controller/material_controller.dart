import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart' hide MaterialType;
import 'package:get/get.dart';
import 'package:home_cache/config/route/route_names.dart';
import 'package:home_cache/model/material_category.dart';
import 'package:home_cache/model/material_details_model.dart';
import 'package:home_cache/model/material_model.dart';
import 'package:home_cache/model/material_type.dart';
import 'package:home_cache/model/type_material_option.dart';
import 'package:home_cache/services/api_checker.dart';
import 'package:home_cache/services/api_clients.dart';
import 'package:home_cache/services/api_constants.dart';

class MaterialController extends GetxController {
  var isLoading = false.obs;
  var selectedFile = Rx<File?>(null);
  var selectedImageFile = Rx<File?>(null);

  var materialTypeList = <MaterialType>[].obs;
  var materialCategoryList = <MaterialCategory>[].obs;
  var materialsByCategoryList = <MaterialModel>[].obs;
  var typeMaterialOption = Rx<TypeMaterialOption?>(null);
  var materialDetails = Rx<MaterialDetailsModel?>(null);

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
  Future<void> getMaterialTypes(String id) async {
    isLoading(true);

    Response response = await ApiClient.getData("/view-by-type/material/$id");

    if (response.statusCode == 200) {
      final responseData = response.body;

      if (responseData['data'] != null) {
        materialTypeList.clear();
        for (var item in responseData['data']) {
          materialTypeList.add(MaterialType.fromJson(item));
        }
      }
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }

  // ! get appliance categories
  Future<void> getMaterialCategories() async {
    isLoading(true);

    Response response =
        await ApiClient.getData("/view-by-type/users-all-materials");

    if (response.statusCode == 200) {
      final responseData = response.body;

      if (responseData['data'] != null) {
        materialCategoryList.clear();
        for (var item in responseData['data']) {
          materialCategoryList.add(MaterialCategory.fromJson(item));
        }
      }
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }

// ! get appliances by category
  Future<void> getMaterialByCategory(String categoryId) async {
    try {
      isLoading(true);

      Response response = await ApiClient.getData(
        "/view-by-type/users-single-material-all-details/$categoryId",
      );

      if (response.statusCode == 200) {
        final responseData = response.body;

        materialsByCategoryList.clear();

        if (responseData['data'] != null) {
          final List list = responseData['data'];

          materialsByCategoryList.addAll(
            list.map((e) => MaterialModel.fromJson(e)).toList(),
          );
        }
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      print("getMaterialByCategory error: $e");
    } finally {
      isLoading(false);
    }
  }

  // ! get type material options
  Future<void> getTypeMaterialOption(String typeMaterialId) async {
    try {
      isLoading(true);

      Response response = await ApiClient.getData(
        "/view-by-type/material-default-option/$typeMaterialId",
      );

      if (response.statusCode == 200) {
        final responseData = response.body;

        if (responseData['data'] != null) {
          typeMaterialOption.value =
              TypeMaterialOption.fromJson(responseData['data']);
        } else {
          typeMaterialOption.value = null;
        }
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      debugPrint("getTypeMaterialOption error: $e");
    } finally {
      isLoading(false);
    }
  }

  // ! add new material
  Future<void> addNewMaterial(var data) async {
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
      ApiConstants.addMaterial,
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

  // ! get material details
  Future<void> getMaterialDetails(String id) async {
    try {
      isLoading(true);

      final response =
          await ApiClient.getData("/view-by-type/material-details/$id");

      if (response.statusCode == 200) {
        final responseData = response.body['data'];

 
        if (responseData != null && responseData is Map<String, dynamic>) {
          final details = MaterialDetailsModel.fromJson(responseData);

      
          typeController.text = details.userMaterial.material.name ?? '';
          locationController.text = details.room.name ?? '';
          notesController.text = details.details.notes ?? '';

          materialDetails.value = details;
        } else {
          materialDetails.value = null;
        }
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e, s) {
      debugPrint("❌ getMaterialDetails error: $e");
      debugPrint("STACKTRACE: $s");
    } finally {
      isLoading(false);
    }
  }
}
