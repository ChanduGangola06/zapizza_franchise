// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zapizza/firebase_options.dart';
import 'package:zapizza/views/auth/login_page.dart';
import 'package:zapizza/views/auth/verification_page.dart';
import 'package:zapizza/views/auth/waiting_page.dart';
import 'package:zapizza/views/home/home_page.dart';

Widget defaultHome = const Login();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();

    String? accessToken = box.read('accessToken');
    String? restaurantId = box.read('restaurantId');
    String? verification = box.read('verification');
    bool? everification = box.read('e-verification') ?? false;

    if (accessToken == null) {
      defaultHome = const Login();
    } else if (accessToken != null && everification == false) {
      defaultHome = const VerificationPage();
    } else if (accessToken != null &&
        restaurantId != null &&
        verification == "Verified") {
      defaultHome = const HomePage();
    } else if (accessToken != null &&
        restaurantId != null &&
        verification != "Verified") {
      defaultHome = const WaitingPage();
    }

    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: const Size(428, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: defaultHome,
        );
      },
    );
  }
}
