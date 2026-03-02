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
    applyAdvancedFilters(query: query);
  }

  //! Apply filter logic
  // void _applyFilter(String query) {
  //   debugPrint("Filtering with query: $query");
  //   if (query.isEmpty) {
  //     filteredAllProviders.value = allProviders;
  //     return;
  //   }

  //   final lowerQuery = query.toLowerCase();

  //   filteredAllProviders.value = allProviders.where((p) {
  //     final name = p.name.toLowerCase();
  //     final type = p.type.toLowerCase();
  //     final company = p.company.toLowerCase();

  //     final matches = name.contains(lowerQuery) ||
  //         type.contains(lowerQuery) ||
  //         company.contains(lowerQuery);

  //     debugPrint("Checking ${p.name}: $matches");
  //     return matches;
  //   }).toList();
  // }
  //! Update _applyFilter to handle multiple criteria
  void _applyFilter(String query,
      {List<int>? ratings, List<String>? services}) {
    if (query.isEmpty &&
        (ratings == null || ratings.isEmpty) &&
        (services == null || services.isEmpty)) {
      filteredAllProviders.value = allProviders;
      return;
    }

    final lowerQuery = query.toLowerCase();

    filteredAllProviders.value = allProviders.where((p) {
      // 1. Text Search Match
      final matchesText = p.name.toLowerCase().contains(lowerQuery) ||
          p.type.toLowerCase().contains(lowerQuery) ||
          p.company.toLowerCase().contains(lowerQuery);

      // 2. Rating Match (Assuming Provider model has a 'rating' field)
      final matchesRating = ratings == null ||
          ratings.isEmpty ||
          (p.rating != null && ratings.contains(int.parse(p.rating!)));

      // 3. Service Type Match
      final matchesService =
          services == null || services.isEmpty || services.contains(p.type);

      return matchesText && matchesRating && matchesService;
    }).toList();
  }

// Add a specific method for the Dialog to call
  void applyAdvancedFilters({
    String? query,
    List<int>? ratings,
    List<String>? services,
    String? usageTimeframe,
  }) {
    // Use the passed query or the existing one in search bar
    final searchKey = (query ?? searchText.value).toLowerCase();

    filteredAllProviders.value = allProviders.where((p) {
      // 1. Text Search
      final matchesText = searchKey.isEmpty ||
          p.name.toLowerCase().contains(searchKey) ||
          p.type.toLowerCase().contains(searchKey) ||
          p.company.toLowerCase().contains(searchKey);

      // 2. Rating (Assuming p.rating is a String "4" or "4.5")
      final matchesRating = ratings == null ||
          ratings.isEmpty ||
          (p.rating != null &&
              ratings.contains(double.tryParse(p.rating!)?.toInt()));

      // 3. Service Type
      final matchesService =
          services == null || services.isEmpty || services.contains(p.type);

      // 4. Usage Timeframe
      bool matchesUsage = true;
      if (usageTimeframe != null && p.lastAppointmentDate != null) {
        final daysDiff =
            DateTime.now().difference(p.lastAppointmentDate!).inDays;
        if (usageTimeframe == 'Past 30 Days')
          matchesUsage = daysDiff <= 30;
        else if (usageTimeframe == 'Past 90 Days')
          matchesUsage = daysDiff <= 90;
        else if (usageTimeframe == 'Past Year')
          matchesUsage = daysDiff <= 365;
        else if (usageTimeframe == '2+ Years') matchesUsage = daysDiff >= 730;
      } else if (usageTimeframe != null && p.lastAppointmentDate == null) {
        matchesUsage = false; // Filtered for time but no date available
      }

      return matchesText && matchesRating && matchesService && matchesUsage;
    }).toList();

    // Force GetX to update the UI
    filteredAllProviders.refresh();
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

  Future<void> fetchProviderDetails(String id) async {
    try {
      isLoading(true);
      errorMessage.value = '';

      // Clear previous data
      selectedProvider.value = null;
      lastAppointments.clear();
      nextAppointments.clear();

      debugPrint("🔍 Fetching provider details for ID: $id");

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      Response response = await ApiClient.getData(
          "${ApiConstants.fetchProviders}$id?t=$timestamp");

      if (response.statusCode == 200) {
        var responseData = response.body;

        if (responseData['data'] != null &&
            responseData['data']['provider'] != null) {
          // 1. Parse Provider
          selectedProvider.value =
              Provider.fromJson(responseData['data']['provider']);
          debugPrint("✅ Provider loaded: ${selectedProvider.value?.name}");

          // 2. Parse lastAppointment (API returns an Array [])
          var lastApptData = responseData['data']['lastAppointment'];
          if (lastApptData != null && lastApptData is List) {
            lastAppointments.value = lastApptData
                .map<Appointment>((appt) => Appointment.fromJson(appt))
                .toList();
            debugPrint(
                "✅ Last appointments loaded: ${lastAppointments.length}");
          }

          // 3. Parse nextAppointment (API returns a single Object {})
          var nextApptData = responseData['data']['nextAppointment'];
          if (nextApptData != null) {
            if (nextApptData is Map<String, dynamic>) {
              // Fix: Pass the data from the API (nextApptData), not the RxList
              nextAppointments.value = [Appointment.fromJson(nextApptData)];
              debugPrint("✅ Next appointment loaded (Object)");
            } else if (nextApptData is List && nextApptData.isNotEmpty) {
              // Fallback if API structure changes to List
              nextAppointments.value = nextApptData
                  .map<Appointment>((appt) => Appointment.fromJson(appt))
                  .toList();
              debugPrint("✅ Next appointments loaded (List)");
            }
          }
        } else {
          errorMessage.value = "No provider found";
          debugPrint("❌ No provider data in response");
        }
      } else {
        ApiChecker.checkApi(response);
        errorMessage.value =
            "Failed to load provider details (${response.statusCode})";
      }
    } catch (e) {
      errorMessage.value = "Error: ${e.toString()}";
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
        throw Exception(
            'Failed to toggle follow status: ${response.statusCode}');
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
