import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:home_cache/model/provider_model.dart';
import 'package:home_cache/services/api_checker.dart';
import 'package:home_cache/services/api_clients.dart';
import 'package:home_cache/services/api_constants.dart';

class ProviderController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  final searchText = ''.obs;

  var allProviders = <Provider>[].obs;
  var filteredAllProviders = <Provider>[].obs;

  // Single provider details
  var selectedProvider = Rxn<Provider>();
  
  // Changed to lists to match API response
  var lastAppointments = <Appointment>[].obs;
  var nextAppointments = <Appointment>[].obs;

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

      final matches = name.contains(lowerQuery) ||
          type.contains(lowerQuery) ||
          company.contains(lowerQuery);

      debugPrint("Checking ${p.name}: $matches");
      return matches;
    }).toList();
  }

  //! Fetch all providers
  Future<void> fetchAllProviders() async {
    try {
      debugPrint('Fetching all providers...');
      isLoading(true);
      errorMessage.value = '';
      
      Response response = await ApiClient.getData(ApiConstants.fetchProviders);

      if (response.statusCode == 200) {
        var responseData = response.body;
        if (responseData['data'] != null) {
          var providerData = responseData['data'] as List;
          allProviders.value =
              providerData.map<Provider>((e) => Provider.fromJson(e)).toList();

          // Initialize filtered list
          filteredAllProviders.value = allProviders;
          
          debugPrint("✅ Loaded ${allProviders.length} providers");
        } else {
          errorMessage.value = "No providers found";
        }
      } else {
        ApiChecker.checkApi(response);
        errorMessage.value = "Failed to load providers";
      }
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint("❌ Error fetching providers: $e");
    } finally {
      isLoading(false);
    }
  }

  //! Fetch provider details by ID
  Future<void> fetchProviderDetails(String id) async {
    try {
      isLoading(true);
      errorMessage.value = '';
      
      // Clear previous data
      selectedProvider.value = null;
      lastAppointments.clear();
      nextAppointments.clear();
      
      debugPrint("🔍 Fetching provider details for ID: $id");
      
      // Add timestamp to prevent caching
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      Response response = await ApiClient.getData(
        "${ApiConstants.fetchProviders}$id?t=$timestamp"
      );

      debugPrint("📡 Raw Response: ${response.body}");
      
      if (response.statusCode == 200) {
        var responseData = response.body;
        
        debugPrint("📦 Response data: ${responseData.toString()}");

        if (responseData['data'] != null &&
            responseData['data']['provider'] != null) {
          
          // Parse provider
          selectedProvider.value =
              Provider.fromJson(responseData['data']['provider']);
          debugPrint("✅ Provider loaded: ${selectedProvider.value?.name}");

          // Parse lastAppointment (array)
          if (responseData['data']['lastAppointment'] != null) {
            var lastApptData = responseData['data']['lastAppointment'];
            debugPrint("🔍 lastAppointment type: ${lastApptData.runtimeType}");
            debugPrint("🔍 lastAppointment data: $lastApptData");
            
            if (lastApptData is List) {
              lastAppointments.value = lastApptData
                  .map<Appointment>((appt) {
                    debugPrint("📅 Parsing appointment: $appt");
                    return Appointment.fromJson(appt);
                  })
                  .toList();
              debugPrint("✅ Last appointments loaded: ${lastAppointments.length}");
              
              // Log each appointment
              for (var appt in lastAppointments) {
                debugPrint("   📌 ${appt.title} - ${appt.date}");
              }
              
              // Log if empty
              if (lastAppointments.isEmpty) {
                debugPrint("⚠️ lastAppointment array is empty - no appointments in API response");
              }
            } else {
              debugPrint("⚠️ lastAppointment is not a List");
            }
          } else {
            debugPrint("ℹ️ No lastAppointment data");
          }

          // Parse nextAppointment (array)
          if (responseData['data']['nextAppointment'] != null) {
            var nextApptData = responseData['data']['nextAppointment'];
            if (nextApptData is List) {
              nextAppointments.value = nextApptData
                  .map<Appointment>((appt) => Appointment.fromJson(appt))
                  .toList();
              debugPrint("✅ Next appointments loaded: ${nextAppointments.length}");
            } else {
              debugPrint("⚠️ nextAppointment is not a List");
            }
          } else {
            debugPrint("ℹ️ No nextAppointment data");
          }

        } else {
          errorMessage.value = "No provider found";
          debugPrint("❌ No provider data in response");
        }
      } else {
        ApiChecker.checkApi(response);
        errorMessage.value = "Failed to load provider details (${response.statusCode})";
        debugPrint("❌ API returned status code: ${response.statusCode}");
      }
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint("❌ Error fetching provider details: $e");
    } finally {
      isLoading(false);
    }
  }

  //! Toggle follow status for a provider
  Future<bool> toggleFollowProvider(String providerId) async {
    try {
      debugPrint("🔄 Toggling follow for provider: $providerId");
      
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

        debugPrint("✅ Follow status updated to: $isFollowed");

        // Update the selected provider's follow status
        if (selectedProvider.value != null && 
            selectedProvider.value!.id == providerId) {
          selectedProvider.value!.isFollowed = isFollowed;
          selectedProvider.refresh();
        }

        // Update in the all providers list
        final index = allProviders.indexWhere((p) => p.id == providerId);
        if (index != -1) {
          allProviders[index].isFollowed = isFollowed;
          allProviders.refresh();
          
          // Also update filtered list
          final filteredIndex = 
              filteredAllProviders.indexWhere((p) => p.id == providerId);
          if (filteredIndex != -1) {
            filteredAllProviders[filteredIndex].isFollowed = isFollowed;
            filteredAllProviders.refresh();
          }
        }

        return isFollowed;
      } else {
        debugPrint("❌ Follow API returned status: ${response.statusCode}");
        throw Exception('Failed to toggle follow status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("❌ Error in toggleFollowProvider: $e");
      rethrow;
    }
  }

  //! Refresh provider details (pull to refresh)
  Future<void> refreshProviderDetails(String id) async {
    await fetchProviderDetails(id);
  }

  //! Refresh all providers list (pull to refresh)
  Future<void> refreshAllProviders() async {
    await fetchAllProviders();
  }

  //! Clear error message
  void clearError() {
    errorMessage.value = '';
  }

  //! Clear search
  void clearSearch() {
    searchText.value = '';
    filteredAllProviders.value = allProviders;
  }
}