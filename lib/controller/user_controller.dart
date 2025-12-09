import 'package:get/get.dart';
import 'package:home_cache/model/user_model.dart';
import 'package:home_cache/services/api_clients.dart';
import 'package:home_cache/services/api_constants.dart';

class UserController extends GetxController {
  var isLoading = false.obs;
  var userDataList = <UserData>[].obs;

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  // ! Fetch user data from API
  Future<void> getUserData() async {
    try {
      isLoading(true);

      // API call
      final response = await ApiClient.getData(ApiConstants.fetchUserData);

      if (response.statusCode == 200) {
        final body = response.body;

        // Check if API returns a list or single object
        if (body is List) {
          // API returns a list of users
          userDataList.value =
              body.map((json) => UserData.fromJson(json)).toList();
        } else if (body is Map<String, dynamic>) {
          // API returns a single user object or nested 'data' field
          final jsonData = body.containsKey('data') ? body['data'] : body;

          if (jsonData is List) {
            userDataList.value =
                jsonData.map((json) => UserData.fromJson(json)).toList();
          } else if (jsonData is Map<String, dynamic>) {
            userDataList.value = [UserData.fromJson(jsonData)];
          }
        }
      } else {
        print("❌ Failed to fetch user data: ${response.statusCode}");
      }
    } finally {
      isLoading(false);
    }
  }

  // Optional: refresh user data
  Future<void> refreshUserData() async {
    userDataList.clear();
    await getUserData();
  }
}
