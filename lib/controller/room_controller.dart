import 'dart:io';
import 'package:get/get.dart';
import 'package:home_cache/config/helper/app_snackbar.dart';
import 'package:home_cache/config/route/route_names.dart';
import 'package:home_cache/model/room.dart';
import 'package:home_cache/model/room_data.dart';
import 'package:home_cache/model/room_field_model.dart';
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
  var availableRoomItem = <RoomItem>[].obs;
  var roomDetails = Rx<Room?>(null);

  var roomFields = <RoomItem>[].obs;
  var userRoomItems = <UserRoomItem>[].obs;
  var roomFieldsData = Rx<RoomField?>(null);

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
      AppSnackbar.show(
        message: 'Room added successfully',
        type: SnackType.success,
      );
      fetchAllRoom();
      Get.back();
    } else {
      AppSnackbar.show(
        message: 'Failed to add room',
        type: SnackType.error,
      );
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

  // ! get available room item
  Future<void> fetchAvailableRoomItem({required String roomTypeId}) async {
    isLoading(true);
    final url = "/view-by-room/available-item/$roomTypeId";
    Response response = await ApiClient.getData(url);

    if (response.statusCode == 200) {
      var responseData = response.body;
      if (responseData['data'] != null) {
        var roomItemData = responseData['data'] as List;
        availableRoomItem.value =
            roomItemData.map<RoomItem>((e) => RoomItem.fromJson(e)).toList();
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

  // !Add the filed fetch
  Future<void> fetchRoomFields(String itemName) async {
    isLoading(true);

    final url = "/view-by-room/get-room-item-fields?item_name=$itemName";

    Response response = await ApiClient.getData(url);

    if (response.statusCode == 200) {
      roomFieldsData.value = RoomField.fromJson(response.body);
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }

// ! add user room item
  Future<void> addUserRoomItem(Map<String, dynamic> data) async {
    isLoading(true);
    try {
      final Map<String, String> stringData =
          data.map((k, v) => MapEntry(k, v?.toString() ?? ''));

      Response response = await ApiClient.postMultipartData(
        ApiConstants.addUserRoomItem,
        stringData,
        multipartBody: selectedFile.value != null
            ? [MultipartBody('file', selectedFile.value!)]
            : [],
      );

      if (response.statusCode == 200) {
        var rawData = response.body['data'];
        UserRoomItem? newItem;
        if (rawData is List && rawData.isNotEmpty) {
          newItem = UserRoomItem.fromJson(rawData[0]);
        } else if (rawData is Map<String, dynamic>) {
          newItem = UserRoomItem.fromJson(rawData);
        }

        if (newItem != null) {
          userRoomItems.add(newItem);
          userRoomItems.refresh(); // Important for GetX UI update
        }

        Get.offAndToNamed(RouteNames.room);
        AppSnackbar.show(
            message: 'Item added successfully', type: SnackType.success);
      }
    } catch (e) {
      print("Add Item Error: $e");
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
      AppSnackbar.show(
        message: 'Item updated successfully',
        type: SnackType.success,
      );
      return true; // success
    } else {
      AppSnackbar.show(
        message: 'Failed to update item',
        type: SnackType.warning,
      );
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
      AppSnackbar.show(
        message: 'Item deleted successfully',
        type: SnackType.success,
      );
      Get.back();
      userRoomItems.removeWhere((item) => item.id == id);
    } else {
      AppSnackbar.show(
        message: 'Failed to delete item',
        type: SnackType.warning,
      );
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }
}
