import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthyfy/controller/HomeTabController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../APIs/Api.dart';
import '../APIs/user_data.dart';
import '../Models/profile_model.dart';
import '../Models/faq_model.dart';
import '../Models/announcement_model.dart';
import '../helper/NotificationServices.dart';
import '../helper/colors.dart';
class DashboardController extends GetxController {
  RxList<MyProfileDatum> profileData = <MyProfileDatum>[].obs;
  RxString profileError = "".obs;
  RxList levelList = [].obs;
  final selectedIndex = 0.obs;
  final Rxn<FaqModel> faqData = Rxn<FaqModel>();
  final RxBool isFaqLoading = false.obs;
  final Rxn<AnnouncementModel> announcementData = Rxn<AnnouncementModel>();
  final RxBool isAnnouncementLoading = false.obs;
  bool _announcementPopupChecked = false;

  void onItemTapped(int index) {
    Get.find<HomeTabController>().getUpcomingMeetingData();
    Get.find<HomeTabController>().checkForUpdate();

    selectedIndex.value = index;
  }
  final firstTimeOpenProDialog = false.obs;
  @override
  void onInit() {
    super.onInit();
    NotificationServices.requestNotificationPermission();
    NotificationServices.forgroundMessage();
    NotificationServices.firebaseInit();
    NotificationServices.setupInteractMessage();

    fetchFaqData();
    fetchAnnouncements();

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
      profileError.value = "";
    } else {
      profileError.value = value.message.toString();
      print("PROFILE_API_EXCEPTION => ${value.message}");
    }
  }

  Future<void> fetchFaqData() async {
    isFaqLoading.value = true;
    var value = await faqApi();
    if (value.status) {
      faqData.value = value.data as FaqModel;
    } else {
      print("FAQ_API_EXCEPTION => ${value.message}");
    }
    isFaqLoading.value = false;
  }

  Future<void> fetchAnnouncements() async {
    isAnnouncementLoading.value = true;
    var value = await announcementApi();
    if (value.status) {
      announcementData.value = value.data as AnnouncementModel;
      await _maybeShowAnnouncementPopup();
    } else {
      print("ANNOUNCEMENT_API_EXCEPTION => ${value.message}");
    }
    isAnnouncementLoading.value = false;
  }

  Future<void> _maybeShowAnnouncementPopup() async {
    if (_announcementPopupChecked) return;
    _announcementPopupChecked = true;

    final model = announcementData.value;
    if (model == null || !model.isNew) return;

    final prefs = await SharedPreferences.getInstance();
    final dismissed = prefs.getBool('announcement_viewed') ?? false;
    if (dismissed) return;

    Get.snackbar(
      'Announcement',
      'You have a new announcement.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: ColorConstants.DarkMahroon,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      mainButton: TextButton(
        onPressed: () async {
          await prefs.setBool('announcement_viewed', true);
          Get.closeAllSnackbars();
          selectedIndex.value = 2;
        },
        child: Text(
          'View',
          style: TextStyle(
            color: ColorConstants.APPTIRLE,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

}
