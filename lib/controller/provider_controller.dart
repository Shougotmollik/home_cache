import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:home_cache/model/provider_model.dart';
import 'package:home_cache/services/api_checker.dart';
import 'package:home_cache/services/api_clients.dart';
import 'package:home_cache/services/api_constants.dart';
import 'package:http/http.dart' as http;

class ProviderController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  final searchText = ''.obs;

  var allProviders = <Provider>[].obs;
  var filteredAllProviders = <Provider>[].obs;

  // Single provider details
  var selectedProvider = Rxn<Provider>();
  var lastAppointment = Rxn<Appointment>();
  var nextAppointment = Rxn<Appointment>();

  @override
  void onInit() {
    super.onInit();
    fetchAllProviders();

    debounce<String>(searchText, (query) {
      _applyFilter(query);
    }, time: const Duration(milliseconds: 300));
  }

  //! Called from search bar
  void onSearchChanged(String query) {
    searchText.value = query;
  }

  //! Apply filter logic
  void _applyFilter(String query) {
    debugPrint("Filtering with query: $query");
    if (query.isEmpty) {
      filteredAllProviders.value = allProviders;
      return;
    }

    final lowerQuery = query.toLowerCase();

    filteredAllProviders.value = allProviders.where((p) {
      final name = p.name.toLowerCase();
      final type = p.type.toLowerCase();
      final company = p.company.toLowerCase();
      final lastServiceDate = p.lastServiceDate?.toLowerCase() ?? '';

      final matches = name.contains(lowerQuery) ||
          type.contains(lowerQuery) ||
          company.contains(lowerQuery) ||
          lastServiceDate.contains(lowerQuery);

      debugPrint("Checking ${p.name}: $matches");
      return matches;
    }).toList();
  }

  //! Fetch all providers
  Future<void> fetchAllProviders() async {
    debugPrint('Fetching all providers...');
    isLoading(true);
    Response response = await ApiClient.getData(ApiConstants.fetchProviders);

    if (response.statusCode == 200) {
      var responseData = response.body;
      if (responseData['data'] != null) {
        var providerData = responseData['data'] as List;
        allProviders.value =
            providerData.map<Provider>((e) => Provider.fromJson(e)).toList();

        // Initialize filtered list
        filteredAllProviders.value = allProviders;
      }
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }

  //! Fetch provider details by ID
  Future<void> fetchProviderDetails(String id) async {
    try {
      isLoading(true);
      Response response =
          await ApiClient.getData("${ApiConstants.fetchProviders}$id");

      if (response.statusCode == 200) {
        var responseData = response.body;

        if (responseData['data'] != null &&
            responseData['data']['provider'] != null) {
          selectedProvider.value =
              Provider.fromJson(responseData['data']['provider']);

          lastAppointment.value = responseData['data']['lastAppointment'] !=
                  null
              ? Appointment.fromJson(responseData['data']['lastAppointment'])
              : null;

          nextAppointment.value = responseData['data']['nextAppointment'] !=
                  null
              ? Appointment.fromJson(responseData['data']['nextAppointment'])
              : null;
        } else {
          errorMessage.value = "No provider found";
        }
      } else {
        ApiChecker.checkApi(response);
        errorMessage.value = "Failed to load provider details";
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading(false);
    }
  }

// // ! toggle follow provider
//   Future<bool> toggleFollowProvider(String providerId) async {
//     try {

//       final response = await http.post(
//         Uri.parse(
//             'https://k10swf0g-6000.inc1.devtunnels.ms/api/v1/provider/toogle-follow'),

//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization':
//               'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2VtYWlsIjoic2hvdWdvdG1vbGxpa0BnbWFpbC5jb20iLCJ1c2VyX2lkIjoiNWQ0NDVhZTItOWRmNy00ZWIyLTkzY2MtMGQ4NjAxOGM5NTVlIiwidXNlcl9yb2xlIjoidXNlciIsImlhdCI6MTc2NjM4NDIwMSwiZXhwIjoxNzY4OTc2MjAxfQ.GNmYDs1ELsenpC-2tiFjMcZ0MQwR8GFJnrV89q6YIHk',
//         },
//         body: json.encode({
//           "provider_id": providerId,
//         }),
//       );

//       print('Status: ${response.statusCode}');
//       print('Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         return data['data']['is_followed'];
//       }
//       throw Exception('Failed');
//     } catch (e) {
//       print('Error: $e');
//       rethrow;
//     }
//   }

  Future<bool> toggleFollowProvider(String providerId) async {
    isLoading(true);
    try {
      var body = json.encode({
        "provider_id": providerId,
      });

      Response response = await ApiClient.postData(
        ApiConstants.followProvider,
        body,
      );

      if (response.statusCode == 200) {
        var responseData = response.body;

        bool isFollowed = responseData['data']['is_followed'] ?? false;

        return isFollowed;
      } else {
        throw Exception('Failed to toggle follow status');
      }
    } catch (e) {
      print("❌ Error in toggleFollowProvider: $e");
      rethrow;
    } finally {
      isLoading(false);
    }
  }
}

// Optional Appointment model
class Appointment {
  final String id;
  final String title;
  final String date;
  final String status;

  Appointment({
    required this.id,
    required this.title,
    required this.date,
    required this.status,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Untitled',
      date: json['date'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
