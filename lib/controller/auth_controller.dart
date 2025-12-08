import 'dart:convert';

import 'package:get/get.dart';
import 'package:home_cache/config/route/route_names.dart';
import 'package:home_cache/constants/data/app_constants.dart';
import 'package:home_cache/model/sing_up_collected_data.dart';
import 'package:home_cache/services/api_checker.dart';

import 'package:home_cache/services/api_clients.dart';
import 'package:home_cache/services/api_constants.dart';
import 'package:home_cache/services/prefs_helper.dart';

class AuthController extends GetxController {
  RxBool isLoading = false.obs;

//! Signup Api Call
  Future<void> signUp(var data) async {
    isLoading(true);

    Response response = await ApiClient.postData(
        ApiConstants.signup, jsonEncode(data),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      var responseData = response.body['data'];
      String token = responseData['access_token'];
      await PrefsHelper.setString(AppConstants.bearerToken, token);
      Get.offAllNamed(RouteNames.selectHouse);
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }

//! Login Api Call
  Future<void> login(var data) async {
    isLoading(true);

    Response response = await ApiClient.postData(
        ApiConstants.login, jsonEncode(data),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      var responseData = response.body['data'];
      String token = responseData['access_token'];
      await PrefsHelper.setString(AppConstants.bearerToken, token);
      Get.offAllNamed(RouteNames.bottomNav);
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }

// ! Log out method
  Future<void> logOut() async {
    await PrefsHelper.remove(AppConstants.bearerToken);
    Get.offAllNamed(RouteNames.login);
  }

  Rx<SingUpCollectedData> collectedData = SingUpCollectedData(
    userId: null,
    homeType: null,
    homeAddress: null,
    homePowerType: [],
    homeWaterSupplyType: [],
    homeHeatingType: [],
    homeHeatingPower: null,
    houseRole: null,
    homeCoolingType: [],
    responsibleFor: [],
    wantToTrack: [],
    lastServiceData: LastServiceData(),
  ).obs;

// ---------- Update Methods ----------
  void updateUserId(String value) {
    collectedData.update((data) => data?.userId = value);
  }

  void updateHomeType(String value) {
    collectedData.update((data) => data?.homeType = value);
  }

  void updateHomeAddress(String value) {
    collectedData.update((data) => data?.homeAddress = value);
  }

  void updateHomePowerType(List<String> value) {
    collectedData.update((data) => data?.homePowerType = value);
  }

  void updateHomeWaterSupplyType(List<String> value) {
    collectedData.update((data) => data?.homeWaterSupplyType = value);
  }

  void updateHomeHeatingType(List<String> value) {
    collectedData.update((data) => data?.homeHeatingType = value);
  }

  void updateHomeHeatingPower(String value) {
    collectedData.update((data) => data?.homeHeatingPower = value);
  }

  void updateHomeCoolingType(List<String> value) {
    collectedData.update((data) => data?.homeCoolingType = value);
  }

  void updateResponsibleFor(List<String> value) {
    collectedData.update((data) => data?.responsibleFor = value);
  }

  void updateWantToTrack(List<String> value) {
    collectedData.update((data) => data?.wantToTrack = value);
  }

  void updateHouseRole(String value) {
    collectedData.update((data) => data?.houseRole = value);
  }

  void updateLastServiceData({
    String? type,
    String? lastService,
    String? note,
  }) {
    collectedData.update((data) {
      data?.lastServiceData = LastServiceData(
        type: type,
        lastService: lastService,
        note: note,
      );
    });
  }

// ---------- Submit All Collected Data ----------
  Future<void> submitHomeData() async {
    isLoading(true);

    Response response = await ApiClient.patchData(
      ApiConstants.updateHomeData,
      collectedData.value.toJson(),
    );

    if (response.statusCode == 200) {
      print("📤 Sending JSON to API==> ${collectedData.value}");
      // Get.snackbar("Success", "Signup data submitted successfully");
      Get.offAllNamed(RouteNames.bottomNav);
    } else {
      Get.snackbar("Error", "Failed: ${response.body}");
    }

    isLoading(false);
  }
}
