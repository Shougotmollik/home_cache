import 'package:get/get.dart';
import 'package:home_cache/model/material_category.dart';
import 'package:home_cache/model/material_model.dart';
import 'package:home_cache/model/material_type.dart';
import 'package:home_cache/services/api_checker.dart';
import 'package:home_cache/services/api_clients.dart';

class MaterialController extends GetxController {
  var isLoading = false.obs;

  var materialTypeList = <MaterialType>[].obs;
  var materialCategoryList = <MaterialCategory>[].obs;
  var materialsByCategoryList = <MaterialModel>[].obs;

  // ! get appliance types
  Future<void> getMaterialTypes(String id) async {
    isLoading(true);

    Response response = await ApiClient.getData("/view-by-type/material/$id");

    if (response.statusCode == 200) {
      final responseData = response.body;

      if (responseData['data'] != null) {
        materialTypeList.clear();
        for (var item in responseData['data']) {
          materialTypeList.add(MaterialType.fromJson(item));
        }
      }
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }

  // ! get appliance categories
  Future<void> getMaterialCategories() async {
    isLoading(true);

    Response response =
        await ApiClient.getData("/view-by-type/users-all-materials");

    if (response.statusCode == 200) {
      final responseData = response.body;

      if (responseData['data'] != null) {
        materialCategoryList.clear();
        for (var item in responseData['data']) {
          materialCategoryList.add(MaterialCategory.fromJson(item));
        }
      }
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading(false);
  }

// ! get appliances by category
  Future<void> getMaterialByCategory(String categoryId) async {
    try {
      isLoading(true);

      Response response = await ApiClient.getData(
        "/view-by-type/users-single-material-all-details/$categoryId",
      );

      if (response.statusCode == 200) {
        final responseData = response.body;

        materialsByCategoryList.clear();

        if (responseData['data'] != null) {
          final List list = responseData['data'];

          materialsByCategoryList.addAll(
            list.map((e) => MaterialModel.fromJson(e)).toList(),
          );
        }
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      print("getMaterialByCategory error: $e");
    } finally {
      isLoading(false);
    }
  }
}
