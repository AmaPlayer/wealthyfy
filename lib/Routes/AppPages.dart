
import 'package:get/get.dart';

import '../main.dart';
import '../screens/bottom_screen.dart';
import 'AppRoutes.dart';
import 'bindings.dart';

class AppPages{
  AppPages(_);
static const INITIAL = Routes.WELCOME;

  static final routes=[
  GetPage(name: Routes.DASHBOARD, page:()=> const MyBottomBar(),binding: DashBoardBinding()) ,
    GetPage(name: Routes.WELCOME, page:()=> const WelcomeState(),binding: WelcomeBinding()) ,
    GetPage(name: Routes.WELCOME, page:()=> const WelcomeState(),binding: WelcomeBinding()) ,

  ];

}

