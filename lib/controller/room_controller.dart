import 'dart:io';
import 'package:get/get.dart';
import 'package:home_cache/model/room.dart';
import 'package:home_cache/model/room_data.dart';
import 'package:home_cache/model/room_item.dart';
import 'package:home_cache/model/room_type.dart';
import 'package:home_cache/model/user_room_item.dart';
import 'package:home_cache/services/api_checker.dart';
import 'package:home_cache/services/api_clients.dart';
import 'package:home_cache/services/api_constants.dart';

class RoomController extends GetxController {
  var isLoading = false.obs;
  var selectedFile = Rx<File?>(null);

  var allRooms = <RoomData>[].obs;
  var roomType = <RoomTypeModel>[].obs;
  var roomItem = <RoomItem>[].obs;
  var roomDetails = Rx<Room?>(null);

  var userRoomItems = <UserRoomItem>[].obs;

// New reactive lists for UI
  var filteredRoomItems = <String>[].obs;
  var selectedItems = <String>[].obs;

  /// Clear selected file
  void removeFile() => selectedFile.value = null;

//! Add new room
  Future<void> addRoom(Map<String, dynamic> data) async {
    isLoading(true);

    Map<String, String> fields = {
      'type_id': data['type_id'],
      'name': data['name'],
    };
    for (int i = 0; i < data['item_id'].length; i++) {
      fields['item_id[$i]'] = data['item_id'][i];
    }

    Response response = await ApiClient.postMultipartData(
      ApiConstants.addRoom,
      fields,
      multipartBody: selectedFile.value != null
          ? [MultipartBody('file', selectedFile.value!)]
          : [],
    );

    if (response.statusCode == 200) {
      fetchAllRoom();
      Get.back();
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }

//! get all room
  Future<void> fetchAllRoom() async {
    isLoading(true);

    Response response = await ApiClient.getData(ApiConstants.fetchAllRoom);

    if (response.statusCode == 200) {
      var responseData = response.body;
      if (responseData['data'] != null) {
        var roomData = responseData['data'] as List;
        allRooms.value =
            roomData.map<RoomData>((e) => RoomData.fromJson(e)).toList();
      }
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }

// ! get room type
  Future<void> fetchRoomType() async {
    isLoading(true);

    Response response = await ApiClient.getData(ApiConstants.fetchRoomType);

    if (response.statusCode == 200) {
      var responseData = response.body;
      if (responseData['data'] != null) {
        var roomTypeData = responseData['data'] as List;
        roomType.value = roomTypeData
            .map<RoomTypeModel>((e) => RoomTypeModel.fromJson(e))
            .toList();
      }
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }

// ! get room item
  Future<void> fetchRoomItem(String roomTypeId, String searchQuery) async {
    isLoading(true);

    final url =
        "${ApiConstants.fetchRoomItem}$roomTypeId?search_term=$searchQuery";

    print("API URL => $url");

    Response response = await ApiClient.getData(url);

    if (response.statusCode == 200) {
      var responseData = response.body;

      if (responseData['data'] != null) {
        var roomItemData = responseData['data'] as List;

        roomItem.value =
            roomItemData.map<RoomItem>((e) => RoomItem.fromJson(e)).toList();

        // Initialize filteredRoomItems
        filteredRoomItems.value = roomItem.map((e) => e.name).toList();
      }
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }

// Filter room items by search query
  void filterRoomItems(String query) {
    if (query.isEmpty) {
      filteredRoomItems.value = roomItem.map((e) => e.name).toList();
    } else {
      filteredRoomItems.value = roomItem
          .map((e) => e.name)
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

// Add selected item
  void addSelectedItem(String item) {
    if (!selectedItems.contains(item)) {
      selectedItems.add(item);
    }
  }

// Remove selected item
  void removeSelectedItem(String item) {
    selectedItems.remove(item);
  }

// ! get room details
  Future<void> fetchRoomDetails(String roomId) async {
    isLoading(true);

    Response response = await ApiClient.getData(
      '${ApiConstants.fetchRoomDetails}/$roomId',
    );

    if (response.statusCode == 200) {
      var responseData = response.body;
      if (responseData['data'] != null) {
        roomDetails.value = Room.fromJson(responseData['data']);
      }
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }

// ! user room items
  Future<void> fetchUserRoomItems(String userId) async {
    isLoading(true);

    Response response =
        await ApiClient.getData("${ApiConstants.fetchUserRoomItems}$userId");

    if (response.statusCode == 200) {
      var responseData = response.body;
      if (responseData['data'] != null) {
        var roomItemData = responseData['data'] as List;
        userRoomItems.value = roomItemData
            .map<UserRoomItem>((e) => UserRoomItem.fromJson(e))
            .toList();
      }
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }

// ! add user room item
  Future<void> addUserRoomItem(Map<String, dynamic> data) async {
    isLoading(true);

    try {
      final Map<String, String> stringData = data.map(
          (key, value) => MapEntry(key, value == null ? '' : value.toString()));

      Response response = await ApiClient.postMultipartData(
        ApiConstants.addUserRoomItem,
        stringData,
        multipartBody: selectedFile.value != null
            ? [MultipartBody('file', selectedFile.value!)]
            : [],
      );

      if (response.statusCode == 200) {
        Get.back();

        // Parse new item from response
        final responseData = response.body;
        if (responseData['data'] != null && responseData['data'].isNotEmpty) {
          final newItem = UserRoomItem.fromJson(responseData['data'][0]);
          userRoomItems.add(newItem);
        }
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      print("Error adding user room item: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<bool> updateUserRoomItem(Map<String, dynamic> data, String id) async {
    isLoading(true);

    final Map<String, String> stringData = data.map((key, value) {
      return MapEntry(key.toString(), value?.toString() ?? '');
    });

    Response response = await ApiClient.patchMultipartData(
      "${ApiConstants.updateUserRoomItem}$id",
      stringData,
      multipartBody: selectedFile.value != null
          ? [MultipartBody('file', selectedFile.value!)]
          : [],
    );

    isLoading(false);

    if (response.statusCode == 200) {
      return true; // success
    } else {
      ApiChecker.checkApi(response);
      return false;
    }
  }

  // ! delete user room item
  Future<void> deleteUserRoomItem(String id) async {
    isLoading(true);

    Response response =
        await ApiClient.deleteData("${ApiConstants.deleteUserRoomItem}$id");

    if (response.statusCode == 200) {
      Get.back();
      userRoomItems.removeWhere((item) => item.id == id);
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }
}
