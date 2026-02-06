import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingChoiceController extends GetxController {
  final TextEditingController addressController = TextEditingController();

  var addressSuggestions = <String>[].obs;
  var selectedAddress = RxnString();

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

  @override
  void onClose() {
    addressController.dispose();
    super.onClose();
  }
}
