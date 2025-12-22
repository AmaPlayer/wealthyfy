import 'package:get/get.dart';
import 'package:meeting/controller/HomeTabController.dart';
import 'package:meeting/main.dart';

import '../controller/dashboardcontroller.dart';

class DashBoardBinding extends Bindings{
  @override
  void dependencies() {
   Get.put<DashboardController>(DashboardController());
   Get.put<HomeTabController>(HomeTabController());
  }

}

class WelcomeBinding extends Bindings{
  @override
  void dependencies() {
   Get.put<WelcomeStateController>(WelcomeStateController());

  }

}