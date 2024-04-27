import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zapizza/common/app_style.dart';
import 'package:zapizza/common/custom_button.dart';
import 'package:zapizza/common/custom_textfield.dart';
import 'package:zapizza/common/reusable_text.dart';
import 'package:zapizza/constants/constants.dart';
import 'package:zapizza/controllers/food_controller.dart';
import 'package:zapizza/models/add_foods_models.dart';

class AdditivesInfo extends StatelessWidget {
  const AdditivesInfo(
      {super.key,
      required this.additivePrice,
      required this.additiveTitle,
      required this.foodTags,
      required this.back,
      required this.submit});

  final TextEditingController additivePrice;
  final TextEditingController additiveTitle;
  final TextEditingController foodTags;
  final Function back;
  final Function submit;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FoodController());
    return SizedBox(
        height: hieght,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.w, top: 12.h, bottom: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReusableText(
                      text: "Add Addittives Info",
                      style: appStyle(16, kGray, FontWeight.w600)),
                  ReusableText(
                      text:
                          "You are required add addittives info for your product if it has any",
                      style: appStyle(11, kGray, FontWeight.normal)),
                ],
              ),
            ),
            SizedBox(
              height: hieght * 0.3,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15.h,
                    ),
                    CustomTextField(
                        controller: additiveTitle,
                        hintText: "Addittives Title",
                        prefixIcon: const Icon(Icons.keyboard_capslock)),
                    SizedBox(
                      height: 15.h,
                    ),
                    CustomTextField(
                        controller: additivePrice,
                        hintText: "Addittives Price",
                        prefixIcon: const Icon(Icons.keyboard_capslock)),
                    SizedBox(
                      height: 15.h,
                    ),
                    Obx(
                      () => controller.additivesList.isNotEmpty
                          ? Column(
                              children: List.generate(
                                  controller.additivesList.length, (i) {
                                final additive = controller.additivesList[i];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5.w),
                                      decoration: BoxDecoration(
                                          color: kGrayLight.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(8.r)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ReusableText(
                                              text: additive.title,
                                              style: appStyle(11, kDark,
                                                  FontWeight.normal)),
                                          ReusableText(
                                              text:
                                                  "\$ ${additive.price.toString()}",
                                              style: appStyle(11, kDark,
                                                  FontWeight.normal)),
                                        ],
                                      )),
                                );
                              }),
                            )
                          : const SizedBox.shrink(),
                    ),
                    CustomButton(
                        text: "A D D   A D D I T T I V E S",
                        btnWidth: width,
                        btnColor: kSecondary,
                        btnHieght: 35,
                        btnRadius: 9,
                        onTap: () {
                          if (additivePrice.text.isNotEmpty &&
                              additiveTitle.text.isNotEmpty) {
                            Additive additive = Additive(
                                id: controller.generateId(),
                                title: additiveTitle.text,
                                price: additivePrice.text);

                            controller.addAdditive = additive;
                            additivePrice.text = '';
                            additiveTitle.text = '';
                          } else {
                            Get.snackbar(
                                colorText: kLightWhite,
                                backgroundColor: kPrimary,
                                "You need data to add additives",
                                "Please fill all fields");
                          }
                        }),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.w, top: 12.h, bottom: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReusableText(
                      text: "Add Food Tags",
                      style: appStyle(16, kGray, FontWeight.w600)),
                  ReusableText(
                      text:
                          "You are required add food tags for your product if it has any",
                      style: appStyle(11, kGray, FontWeight.normal)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.h),
              child: Column(
                children: [
                  CustomTextField(
                      controller: foodTags,
                      hintText: "Add Food Tags",
                      prefixIcon: const Icon(Icons.keyboard_capslock)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Obx(
                () => controller.tags.isNotEmpty
                    ? Row(
                        children: List.generate(controller.tags.length, (i) {
                          return Container(
                            margin: EdgeInsets.only(right: 5.w),
                            decoration: BoxDecoration(
                                color: kPrimary,
                                borderRadius: BorderRadius.circular(8.r)),
                            child: Center(
                              child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.h),
                                  child: ReusableText(
                                      text: controller.tags[i],
                                      style: appStyle(
                                          9, kLightWhite, FontWeight.normal))),
                            ),
                          );
                        }),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: CustomButton(
                text: "A D D   F O O D   T A G S",
                btnRadius: 6,
                btnHieght: 35,
                btnColor: kSecondary,
                onTap: () {
                  controller.setTags = foodTags.text;
                  foodTags.text = '';
                },
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    text: "Back",
                    btnWidth: width / 2.3,
                    btnRadius: 6,
                    onTap: () {
                      back();
                    },
                  ),
                  CustomButton(
                    text: "Submit",
                    btnWidth: width / 2.3,
                    btnRadius: 6,
                    onTap: () {
                      submit();
                    },
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
