import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:home_cache/constants/data/app_constants.dart';
import 'package:home_cache/services/api_constants.dart';
import 'package:home_cache/services/prefs_helper.dart';
import 'package:http/http.dart' as http;

class ApiClient extends GetxService {
  static var client = http.Client();

  static const String noInternetMessage =
      "Sorry! Something went wrong please try again";
  static const int timeoutInSeconds = 30;
  static String bearerToken = "";

// ?get Request
  static Future<Response> getData(String uri,
      {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);

    final fullUri =
        Uri.parse(ApiConstants.baseUrl + uri).replace(queryParameters: query);

    var mainHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };
    try {
      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');

      http.Response response = await client
          .get(
            fullUri,
            headers: headers ?? mainHeaders,
          )
          .timeout(const Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      debugPrint('------------${e.toString()}');
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

// ?post Request
  static Future<Response> postData(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);

    var mainHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };
    try {
      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
      debugPrint('====> API Body: $body');

      http.Response response = await client
          .post(
            Uri.parse(ApiConstants.baseUrl + uri),
            body: body,
            headers: headers ?? mainHeaders,
          )
          .timeout(const Duration(seconds: timeoutInSeconds));
      debugPrint(
          "==========> Response Post Method :------ : ${response.statusCode}");
      return handleResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

// ?Multipart post Request
  static Future<Response> postMultipartData(
    String uri,
    Map<String, String> body, {
    required List<MultipartBody> multipartBody,
    Map<String, String>? headers,
  }) async {
    try {
      bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);

      // ❗ Multipart MUST NOT use Content-Type: application/json
      var mainHeaders = {
        'Authorization': 'Bearer $bearerToken',
      };

      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
      debugPrint('====> API Body: $body with ${multipartBody.length} picture');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.baseUrl + uri),
      );

      request.headers.addAll(headers ?? mainHeaders);

      // 🔥 Add files WITHOUT MIME TYPE (auto-detect)
      for (MultipartBody fileItem in multipartBody) {
        request.files.add(
          await http.MultipartFile.fromPath(
            fileItem.key,
            fileItem.file.path,
          ),
        );
      }

      // Add normal fields
      request.fields.addAll(body);

      // Send request
      var streamedResponse = await request.send();

      // Convert to http.Response
      http.Response httpResponse =
          await http.Response.fromStream(streamedResponse);

      // Convert http.Response → GetX Response
      return handleResponse(httpResponse, uri);
    } catch (e) {
      debugPrint("Multipart Error: $e");
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  // ? Patch Request

  // ? PATCH Request
  static Future<Response> patchData(String uri, Map<String, dynamic> body,
      {Map<String, String>? headers}) async {
    // Get bearer token
    String? bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);

    if (bearerToken == null || bearerToken.isEmpty) {
      debugPrint("⚠️ Bearer token is null or empty");
      return const Response(statusCode: 401, statusText: "Unauthorized");
    }

    // Remove null fields if your API doesn't accept them
    body.removeWhere((key, value) => value == null);

    // Default headers
    var mainHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };

    try {
      debugPrint(
          '====> PATCH API Call: $uri\nHeader: ${headers ?? mainHeaders}');
      debugPrint('====> PATCH Body: $body');

      // Encode Map to JSON string
      http.Response response = await client
          .patch(
            Uri.parse(ApiConstants.baseUrl + uri),
            body: jsonEncode(body), // encode Map to JSON string
            headers: headers ?? mainHeaders,
          )
          .timeout(const Duration(seconds: timeoutInSeconds));

      debugPrint("==========> PATCH Response Status: ${response.statusCode}");
      return handleResponse(response, uri);
    } catch (e) {
      debugPrint("PATCH Request Error: $e");
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  // static Future<Response> patchData(String uri, dynamic body,
  //     {Map<String, String>? headers}) async {
  //   // Get bearer token
  //   bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);

  //   // Default headers
  //   var mainHeaders = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $bearerToken',
  //   };

  //   try {
  //     debugPrint(
  //         '====> PATCH API Call: $uri\nHeader: ${headers ?? mainHeaders}');
  //     debugPrint('====> PATCH Body: $body');

  //     http.Response response = await client
  //         .patch(
  //           Uri.parse(ApiConstants.baseUrl + uri),
  //           body: body,
  //           headers: headers ?? mainHeaders,
  //         )
  //         .timeout(const Duration(seconds: timeoutInSeconds));

  //     debugPrint("==========> PATCH Response Status: ${response.statusCode}");
  //     return handleResponse(response, uri);
  //   } catch (e) {
  //     debugPrint("PATCH Request Error: $e");
  //     return const Response(statusCode: 1, statusText: noInternetMessage);
  //   }
  // }

//? PATCH with multipart support
  static Future<Response> patchMultipartData(
    String uri,
    Map<String, String> fields, {
    List<MultipartBody>? multipartBody,
    Map<String, String>? headers,
  }) async {
    bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);

    var mainHeaders = {
      'Authorization': 'Bearer $bearerToken',
      // Content-Type will be set automatically by MultipartRequest
    };

    try {
      var fullUri = ApiConstants.baseUrl + uri;
      var request = http.MultipartRequest('PATCH', Uri.parse(fullUri))
        ..fields.addAll(fields)
        ..headers.addAll(headers ?? mainHeaders);

      debugPrint('====> PATCH Multipart API Call=====>> $fullUri');
      // Add files
      if (multipartBody != null) {
        for (var file in multipartBody) {
          request.files
              .add(await http.MultipartFile.fromPath(file.key, file.file.path));
        }
      }

      debugPrint('====> PATCH Multipart API Call: $uri');
      debugPrint('====> Fields: $fields');
      if (multipartBody != null) {
        debugPrint(
            '====> Files: ${multipartBody.map((e) => e.file.path).toList()}');
      }

      var streamedResponse = await request
          .send()
          .timeout(const Duration(seconds: timeoutInSeconds));
      var response = await http.Response.fromStream(streamedResponse);

      debugPrint(
          "==========> PATCH Multipart Response Status: ${response.statusCode}");
      return handleResponse(response, uri);
    } catch (e) {
      debugPrint("PATCH Multipart Request Error: $e");
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> putData(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);

    var mainHeaders = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $bearerToken'
    };
    try {
      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
      debugPrint('====> API Body: $body');

      http.Response response = await http
          .put(
            Uri.parse(ApiConstants.baseUrl + uri),
            body: jsonEncode(body),
            headers: headers ?? mainHeaders,
          )
          .timeout(const Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  static Future<Response> putMultipartData(String uri, Map<String, String> body,
      {required List<MultipartBody> multipartBody,
      Map<String, String>? headers}) async {
    try {
      bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);

      var mainHeaders = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $bearerToken'
      };
      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
      debugPrint('====> API Body: $body with ${multipartBody.length} picture');
      var request =
          http.MultipartRequest('PUT', Uri.parse(ApiConstants.baseUrl + uri));
      request.headers.addAll(headers ?? mainHeaders);
      // ignore: unused_local_variable
      for (MultipartBody element in multipartBody) {
        for (MultipartBody element in multipartBody) {
          request.files.add(await http.MultipartFile.fromPath(
            element.key,
            element.file.path,
          ));
        }
      }

      request.fields.addAll(body);

      http.Response response =
          await http.Response.fromStream(await request.send());
      return handleResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  static Future<Response> deleteData(String uri,
      {Map<String, String>? headers, dynamic body}) async {
    bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);

    var mainHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };
    try {
      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
      debugPrint('====> API Call: $uri\n Body: $body');

      http.Response response = await http
          .delete(Uri.parse(ApiConstants.baseUrl + uri),
              headers: headers ?? mainHeaders, body: body)
          .timeout(const Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  static Response handleResponse(http.Response response, String uri) {
    dynamic body;

    try {
      body = jsonDecode(response.body);
    } catch (e) {
      debugPrint(e.toString());
    }
    Response response0 = Response(
      body: body ?? response.body,
      bodyString: response.body.toString(),
      request: Request(
          headers: response.request!.headers,
          method: response.request!.method,
          url: response.request!.url),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );

    if (response0.statusCode != 200 &&
        response0.body != null &&
        response0.body is! String) {
      debugPrint("response ${response0.body.runtimeType}");

      debugPrint("${response0.statusCode}");
      response0 = Response(
          statusCode: response0.statusCode,
          body: response0.body,
          statusText: response0.statusText);
    } else if (response0.statusCode != 200 && response0.body == null) {
      response0 = const Response(statusCode: 0, statusText: noInternetMessage);
    }
    debugPrint(
        '====> API Response: [${response0.statusCode}] $uri\n${response0.body}');
    return response0;
  }
}

class MultipartBody {
  String key;
  File file;
  MultipartBody(this.key, this.file);
}
