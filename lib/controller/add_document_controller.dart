import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:home_cache/config/route/route_names.dart';
import 'package:home_cache/services/api_checker.dart';
import 'package:home_cache/services/api_clients.dart';
import 'package:home_cache/services/api_constants.dart';

class AddDocumentController extends GetxController {
  var selectedFile = Rx<File?>(null);
  var isLoading = false.obs;
  var isReadable = true.obs;

  // Focus only the first field of any doc type
  final FocusNode firstFieldFocus = FocusNode();

  void toggleEditable() {
    isReadable.value = !isReadable.value;

    if (!isReadable.value) {
      // Focus the first field after a short delay to ensure the TextField exists
      Future.delayed(Duration(milliseconds: 100), () {
        firstFieldFocus.requestFocus();
      });
    }
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

  // ! adding new document
  Future<void> addDocument(var data) async {
    isLoading(true);

    try {
      Response response = await ApiClient.postMultipartData(
        ApiConstants.addDocument,
        data,
        multipartBody: selectedFile.value != null
            ? [MultipartBody('files', selectedFile.value!)]
            : [],
      );

      if (response.statusCode == 200) {
        await Future.delayed(const Duration(seconds: 2));
        // Get.back();
        Get.offAllNamed(RouteNames.documents);
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      debugPrint("Error in addDocument: $e");
    }

    isLoading(false);
  }

  // ! update Documents

  Future<void> updateDocument(var data, String id) async {
    isLoading(true);
    Response response =
        await ApiClient.patchData("/document/details/$id", data);
    // print(" APi Url ======>>${ApiConstants.updateDocument}$id");
    if (response.statusCode == 200) {
      await Future.delayed(const Duration(seconds: 2));
    } else {
      ApiChecker.checkApi(response);
    }
    isLoading(false);
  }

  @override
  void onClose() {
    firstFieldFocus.dispose();
    super.onClose();
  }
}
