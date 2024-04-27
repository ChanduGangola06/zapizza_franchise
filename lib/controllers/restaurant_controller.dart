import 'dart:math';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:zapizza/constants/constants.dart';
import 'package:zapizza/models/api_error.dart';
import 'package:zapizza/models/restaurant_response.dart';
import 'package:zapizza/models/success_model.dart';
import 'package:zapizza/views/auth/login_page.dart';

// ignore: camel_case_types'

class RestaurantController extends GetxController {
  final box = GetStorage();
  RestaurantResponse? restaurant;
  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set isLoading(bool value) => _isLoading.value = value;

  int generateId() {
    int min = 0;
    int max = 10000;

    return min + Random().nextInt(max - min);
  }

  RestaurantResponse getRestuarantData() {
    String? id = box.read("restaurantId");

    if (id != null) {
      String data = box.read(id);
      restaurant = restaurantResponseFromJson(data);
    }
    return restaurant!;
  }

  void restaurantRegistration(String data) async {
    String accessToken = box.read('accessToken');
    isLoading = true;

    Uri url = Uri.parse('$appBaseUrl/api/restaurant');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    try {
      var response = await http.post(url, headers: headers, body: data);

      if (response.statusCode == 201) {
        var data = successResponseFromJson(response.body);

        isLoading = false;
        Get.snackbar(
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            data.message,
            'Restaurant Registered Successfully continue to login to the service');

        Get.offAll(() => const Login(),
            transition: kTransition, duration: kDuration);
      } else {
        var error = apiErrorFromJson(response.body);

        Get.snackbar(
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            error.message,
            'Failed to register restaurant please try again');
      }
      isLoading = false;
    } catch (e) {
      isLoading = false;

      Get.snackbar(
          colorText: kLightWhite,
          backgroundColor: kPrimary,
          e.toString(),
          'Failed to register restaurant please try again');
    }
  }
}
