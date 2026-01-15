import 'dart:io';

import 'package:get/get.dart';

class UtilitiesController extends GetxController {
  var isLoading = false.obs;

  var selectedImageFile = Rx<File?>(null);

  var selectedFile = Rx<File?>(null);
}
