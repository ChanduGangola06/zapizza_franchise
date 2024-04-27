import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:zapizza/constants/constants.dart';
import 'package:zapizza/models/login_response.dart';
import 'package:zapizza/models/success_model.dart';
import 'package:zapizza/views/auth/login_page.dart';
import 'package:zapizza/views/auth/restaurant_registaration.dart';

// ignore: camel_case_types'

class EmailVerificationController extends GetxController {
  final box = GetStorage();
  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set isLoading(bool value) => _isLoading.value = value;

  RxString _code = ''.obs;

  String get code => _code.value;

  void setCode(String value) => _code.value = value;

  void verifyEmail(String code) async {
    isLoading = true;
    String accessToken = box.read('accessToken');

    var url = Uri.parse("$appBaseUrl/api/users/verify/$code");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    try {
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        LoginResponse data = loginResponseFromJson(response.body);

        box.write(data.id, json.encode(data));
        box.write('accessToken', data.userToken);
        box.write('e-verification', data.verification);

        Get.snackbar(
          "Sucessfully verified your account",
          "Enjoy your awesome experience",
          backgroundColor: kPrimary,
          colorText: kLightWhite,
        );

        if (data.userType == 'Client') {
          Get.offAll(() => const RestaurantRegistration(),
              transition: kTransition, duration: kDuration);
        } else {
          Get.offAll(() => const Login(),
              transition: kTransition, duration: kDuration);
        }
        isLoading = false;
      } else {
        var data = successResponseFromJson(response.body);
        Get.snackbar(
          "Failed to verify account",
          data.message,
          backgroundColor: kPrimary,
          colorText: kLightWhite,
        );
        isLoading = false;
      }
    } catch (e) {
      Get.snackbar(
        "Failed to verify account",
        e.toString(),
        backgroundColor: kPrimary,
        colorText: kLightWhite,
      );
      isLoading = false;
    }
  }
}

// 466010
