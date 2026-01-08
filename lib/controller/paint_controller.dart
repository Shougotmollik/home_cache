import 'package:get/get.dart';
import 'package:home_cache/model/room_with_paint.dart';
import 'package:home_cache/services/api_clients.dart';
import 'package:home_cache/services/api_constants.dart';

class PaintController extends GetxController {
  var isLoading = false.obs;

  var roomWithPaintList = <RoomWithPaint>[].obs;

  // ! Fetch room with paint data

  Future<void> fetchRoomWithPaint() async {
    isLoading(true);
    final Response response =
        await ApiClient.getData(ApiConstants.fetchRoomWithPaint);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = response.body;

      final List<dynamic> dataList = data['data'];
      roomWithPaintList.value =
          dataList.map((json) => RoomWithPaint.fromJson(json)).toList();
    } else {
      print('Error fetching room with paint data: ${response.statusCode}');
    }
    isLoading(false);
  }
}
