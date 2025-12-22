import 'dart:io';
import 'package:get/get.dart';
import 'package:meeting/controller/HomeTabController.dart';
import '../APIs/Api.dart';
import '../APIs/user_data.dart';
import '../Models/profile_model.dart';
import '../helper/NotificationServices.dart';
class DashboardController extends GetxController {
  RxList<MyProfileDatum> profileData = <MyProfileDatum>[].obs;
  RxList levelList = [].obs;
  final selectedIndex = 0.obs;

  void onItemTapped(int index) {
    Get.find<HomeTabController>().getUpcomingMeetingData();
    Get.find<HomeTabController>().checkForUpdate();

    selectedIndex.value = index;
  }
  File? _image;
  final firstTimeOpenProDialog = false.obs;
  @override
  void onInit() {
    super.onInit();
    NotificationServices.requestNotificationPermission();
    NotificationServices.forgroundMessage();
    NotificationServices.firebaseInit();
    NotificationServices.setupInteractMessage();


    String? token = viewLoginDetail?.data.first.jwtToken.toString();
    if (token != null) {
      initiateProfileApi();
    }
  }
  Future<void> initiateProfileApi({String? bToken}) async {
    var value = await myProfileAPI(bToken: bToken);
    if (value.status) {
      MyProfileModel myModel = value.data;
      profileData.value = myModel.data;
    } else {
      print("PROFILE_API_EXCEPTION => ${value.message}");
    }
  }


}

