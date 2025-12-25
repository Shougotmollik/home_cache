import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_cache/controller/user_controller.dart';
import 'package:home_cache/services/api_checker.dart';
import 'package:home_cache/services/api_clients.dart';
import 'package:home_cache/services/api_constants.dart';

class ProfileController extends GetxController {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  var addressSuggestions = <String>[].obs;
  var selectedAddress = RxnString();

  final UserController userController = Get.put(UserController());

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    addressController.addListener(_onAddressChanged);
  }

  void _onAddressChanged() {
    if (addressController.text.isEmpty) {
      addressSuggestions.clear();
      selectedAddress.value = null;
    } else {
      addressSuggestions.value = [
        // '123 Home Ln example, Los Angeles, CA 123456',
        // '456 Maple St example, Los Angeles, CA 123456',
        // '789 Oak Rd example, Los Angeles, CA 123456',
      ];
    }
  }

  void selectAddress(String address) {
    addressController.text = address;
    selectedAddress.value = address;
    addressSuggestions.clear();
  }

  void clearAddress() {
    addressController.clear();
    selectedAddress.value = null;
    addressSuggestions.clear();
  }

  void submitAddress() {
    if (selectedAddress.value != null) {
      debugPrint('Selected Address: ${selectedAddress.value}');

      Get.toNamed('/selectPowerType');
    } else {
      Get.snackbar('Error', 'Please select or enter an address');
    }
  }

  // ! update profile
  Future<void> updateProfile(Map<String, dynamic> data) async {
    isLoading(true);

    Response response = await ApiClient.patchData(
      ApiConstants.updateProfile,
      data,
    );

    if (response.statusCode == 200) {
      await Future.delayed(const Duration(seconds: 2));
      await userController.refreshUserData();
      Get.back();
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          content: Text('Profile updated successfully'),
        ),
      );
    } else {
      ApiChecker.checkApi(response);
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          content: Text('Failed to update profile'),
        ),
      );
    }

    isLoading(false);
  }

  // ! password update profile
  Future<void> updatePassword(Map<String, dynamic> data) async {
    isLoading(true);

    Response response = await ApiClient.patchData(
      "/auth/update-password",
      data,
    );
    if (response.statusCode == 200) {
      await Future.delayed(const Duration(seconds: 2));
      await userController.refreshUserData();
      Get.back();
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          content: Text('Password updated successfully'),
        ),
      );
    } else {
      ApiChecker.checkApi(response);
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          content: Text('Failed to update password'),
        ),
      );
    }
    isLoading(false);
  }

  @override
  void onClose() {
    addressController.dispose();
    super.onClose();
  }
}
