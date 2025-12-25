import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_cache/services/api_checker.dart';
import 'package:home_cache/services/api_clients.dart';
import 'package:home_cache/services/api_constants.dart';

class HomeMemberController extends GetxController {
  var isLoading = false.obs;

// ! Join home
  Future<void> joinHome(Map<String, dynamic> data) async {
    if (data['home_id'] == null || data['home_id'].trim().isEmpty) return;

    try {
      isLoading(true);
      String jsonData = jsonEncode(data);

      Response response =
          await ApiClient.postData(ApiConstants.joinHome, jsonData);

      if (response.statusCode == 200) {
        await Future.delayed(const Duration(seconds: 2));
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      print("Error joining home: $e");
    } finally {
      isLoading(false);
      Get.back();
    }
  }

// ! Invite home member
  Future<void> inviteHomeMember(Map<String, dynamic> data) async {
    if (data['email'] == null || data['email'].trim().isEmpty) {
      print("Error: Please enter an email");
      return;
    }

    try {
      isLoading(true);

      // Encode data as JSON before sending
      String jsonData = jsonEncode(data);

      Response response =
          await ApiClient.postData(ApiConstants.inviteHomeMember, jsonData);

      // Handle response
      if (response.statusCode == 200) {
        Map<String, dynamic> body = {};
        try {
          body = response.body is Map<String, dynamic>
              ? response.body
              : jsonDecode(response.body);
        } catch (e) {
          print("JSON decode error: $e");
        }

        if (body['status_code'] == 200 && body['success'] == true) {
          print("Invite sent successfully: ${body['message']}");
        } else {
          print("Failed to send invite: ${body['message']}");
        }
      } else {
        print("API Error: ${response.statusCode} - ${response.statusText}");
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      print("Exception while sending invite: $e");
    } finally {
      isLoading(false);
    }
  }

  // ! Remove home member
  Future<void> removeHomeMember() async {
    isLoading(true);

    final Response response =
        await ApiClient.deleteData(ApiConstants.removeMember);

    if (response.statusCode == 200) {
      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          content: Text('Member removed successfully'),
        ),
      );
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          content: Text('Home Owner Cannot be removed'),
        ),
      );
    }

    isLoading(false);
  }
}
