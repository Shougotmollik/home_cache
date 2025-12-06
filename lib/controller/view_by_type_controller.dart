import 'package:get/get.dart';
import 'package:home_cache/model/view_by_type.dart';
import 'package:home_cache/services/api_checker.dart';
import 'package:home_cache/services/api_clients.dart';
import 'package:home_cache/services/api_constants.dart';

class ViewByTypeController extends GetxController {
  var isLoading = false.obs;
  var typeList = <ViewByType>[].obs;

  //! Get view by type
  Future<void> getViewByType() async {
    isLoading(true);

    Response response = await ApiClient.getData(ApiConstants.viewByType);

    if (response.statusCode == 200) {
      final responseData = response.body;

      if (responseData['data'] != null) {
        typeList.clear();
        for (var item in responseData['data']) {
          typeList.add(ViewByType.fromJson(item));
        }
      }
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }
}
