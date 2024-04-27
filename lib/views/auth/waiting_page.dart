import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:zapizza/common/app_style.dart';
import 'package:zapizza/common/background_container.dart';
import 'package:zapizza/common/reusable_text.dart';
import 'package:zapizza/constants/constants.dart';
import 'package:zapizza/controllers/restaurant_controller.dart';
import 'package:zapizza/views/auth/login_page.dart';

class WaitingPage extends StatelessWidget {
  const WaitingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurantController = Get.put(RestaurantController());
    restaurantController.restaurant = restaurantController.getRestuarantData();

    return Scaffold(
      body: BackGroundContainer(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 200.h, 24.w, 0),
          child: ListView(
            children: [
              Lottie.asset('assets/anime/delivery.json'),
              ReusableText(
                text: restaurantController.restaurant!.title,
                style: appStyle(18, kPrimary, FontWeight.bold),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReusableText(
                      text:
                          "Status: ${restaurantController.restaurant!.verification}",
                      style: appStyle(14, kGray, FontWeight.bold)),
                  GestureDetector(
                    onTap: () {
                      Get.to(
                        () => const Login(),
                      );
                    },
                    child: ReusableText(
                        text: "Try Login",
                        style: appStyle(14, kTertiary, FontWeight.bold)),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                width: width * 0.8,
                child: Text(
                  restaurantController.restaurant!.verificationMessage,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                    color: kGray,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
