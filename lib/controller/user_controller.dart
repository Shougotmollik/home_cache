import 'dart:convert';

import 'package:get/get.dart';
import 'package:home_cache/config/helper/app_snackbar.dart';
import 'package:home_cache/model/home_member_model.dart';
import 'package:home_cache/model/user_model.dart';
import 'package:home_cache/services/api_checker.dart';
import 'package:home_cache/services/api_clients.dart';
import 'package:home_cache/services/api_constants.dart';

class UserController extends GetxController {
  var isLoading = false.obs;
  var userDataList = <UserData>[].obs;
  var homeMemberList = <HomeMemberModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  // ! Fetch user data from API
  Future<void> getUserData() async {
    isLoading(true);
    final response = await ApiClient.getData(ApiConstants.fetchUserData);

    if (response.statusCode == 200) {
      final body = response.body;
      if (body is List) {
        userDataList.value =
            body.map((json) => UserData.fromJson(json)).toList();
      } else if (body is Map<String, dynamic>) {
        final jsonData = body.containsKey('data') ? body['data'] : body;

        if (jsonData is List) {
          userDataList.value =
              jsonData.map((json) => UserData.fromJson(json)).toList();
        } else if (jsonData is Map<String, dynamic>) {
          userDataList.value = [UserData.fromJson(jsonData)];
        }
      }
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }

  // ! refresh user data
  Future<void> refreshUserData() async {
    userDataList.clear();
    await getUserData();
  }

  // ! Fetch home member data from API
  Future<void> getHomeMemberData() async {
    isLoading(true);
    final Response response =
        await ApiClient.getData(ApiConstants.fetchHomeMember);
    if (response.statusCode == 200) {
      var responseData = response.body['data'] as List;
      if (responseData.isNotEmpty) {
        homeMemberList.value = responseData
            .map<HomeMemberModel>((e) => HomeMemberModel.fromJson(e))
            .toList();
      }
    } else {
      ApiChecker.checkApi(response);
    }
    isLoading(false);
  }

  // ! product support
  Future<void> productSupport(var data) async {
    isLoading(true);
    final Response response =
        await ApiClient.postData(ApiConstants.productSupport, jsonEncode(data));
    if (response.statusCode == 200) {
      AppSnackbar.show(
        message: 'Product support message sent successfully',
        type: SnackType.success,
      );
      Get.back();
    } else {
      ApiChecker.checkApi(response);
      AppSnackbar.show(
        message: 'Failed to send product support message',
        type: SnackType.warning,
      );
    }
    isLoading(false);
  }
}
