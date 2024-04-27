import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zapizza/common/background_container.dart';
import 'package:zapizza/common/custom_appbar.dart';
import 'package:zapizza/constants/constants.dart';
import 'package:zapizza/views/home/widget/home_tabs.dart';
import 'package:zapizza/views/home/widget/home_tiles.dart';
import 'package:zapizza/views/home/widget/orders/cancelled_orders.dart';
import 'package:zapizza/views/home/widget/orders/delivered_orders.dart';
import 'package:zapizza/views/home/widget/orders/new_orders.dart';
import 'package:zapizza/views/home/widget/orders/picked_orders.dart';
import 'package:zapizza/views/home/widget/orders/preparing.dart';
import 'package:zapizza/views/home/widget/orders/ready_orders.dart';
import 'package:zapizza/views/home/widget/orders/seld_deliveries.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: orderList.length,
    vsync: this,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimary,
        flexibleSpace: const CustomAppBar(),
      ),
      body: BackGroundContainer(
          child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 15.h,
          ),
          const HomeTiles(),
          SizedBox(
            height: 15.h,
          ),
          HomeTabs(tabController: _tabController),
          SizedBox(
            height: 15.h,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            height: hieght * 0.7,
            color: Colors.transparent,
            child: TabBarView(
              controller: _tabController,
              children: const [
                NewOrders(),
                Preparing(),
                ReadyOrders(),
                PickedOrders(),
                SelfDeliveries(),
                DeliveredOrders(),
                CancelledOrders()
              ],
            ),
          )
        ],
      )),
    );
  }
}
