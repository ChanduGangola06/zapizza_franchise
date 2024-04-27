import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:otp_text_field_v2/otp_text_field_v2.dart';
import 'package:zapizza/common/app_style.dart';
import 'package:zapizza/common/custom_button.dart';
import 'package:zapizza/common/reusable_text.dart';
import 'package:zapizza/constants/constants.dart';
import 'package:zapizza/controllers/email_veication_controller.dart';
import 'package:zapizza/controllers/login_controller.dart';
import 'package:zapizza/models/login_response.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  OtpFieldControllerV2 otpController = OtpFieldControllerV2();
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmailVerificationController());
    final userController = Get.put(LoginController());
    LoginResponse? user = userController.getUserData();

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        children: [
          SizedBox(
            height: 100.h,
          ),
          Lottie.asset('assets/anime/delivery.json'),
          SizedBox(
            height: 30.h,
          ),
          ReusableText(
            text: "Verify Your Account",
            style: appStyle(20, kPrimary, FontWeight.bold),
          ),
          Text(
            "Enter the code sent to your email, if you did not send recieve the code, click resend",
            style: appStyle(10, kGrayLight, FontWeight.normal),
          ),
          SizedBox(
            height: 20.h,
          ),
          OTPTextFieldV2(
              controller: otpController,
              length: 6,
              autoFocus: true,
              width: MediaQuery.of(context).size.width,
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldWidth: 45,
              outlineBorderRadius: 15,
              style: const TextStyle(fontSize: 17),
              onCompleted: (pin) {
                controller.setCode(pin);
                controller.verifyEmail(pin);
              }),
          SizedBox(
            height: 20.h,
          ),
          CustomButton(
            onTap: () {
              controller.verifyEmail(controller.code);
            },
            btnColor: kPrimary,
            text: "Verify Account",
            btnHieght: 40.h,
          ),
          SizedBox(
            height: 30.h,
          ),
          Text(
              "The email has been sent to ${user!.email}. If the email is not correct, please delete this account and create a new one with the correct email. Alternatively, you can logout and browser the app without an account.",
              textAlign: TextAlign.justify,
              style: appStyle(10, kGray, FontWeight.normal)),
          SizedBox(
            height: 15.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: () {
                    userController.logout();
                  },
                  child: ReusableText(
                      text: "Logout",
                      style: appStyle(12, kSecondary, FontWeight.w600))),
              GestureDetector(
                onTap: () {
                  // userController.deleteAccount();
                },
                child: ReusableText(
                    text: "Delete account",
                    style: appStyle(12, kRed, FontWeight.w600)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
