import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:meeting/APIs/Api.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:workmanager/workmanager.dart'; // Added for background tasks
import '../../APIs/user_data.dart';
import '../../Models/dashboard_approvedmeeting_model.dart';
import '../../Models/yesterday_user_attendance_model.dart';
import '../../controller/dashboardcontroller.dart';
import '../Models/profile_model.dart';
import '../helper/ErrorBottomSheet.dart';
import '../main.dart';

class HomeTabController extends GetxController {
  DashboardController dController = Get.find<DashboardController>();
  var userYesterdayAttendanceList = <UserYesterDayDatum>[].obs;
  var dashboardApprovedMeetingList = <DasApprovedMeetingDatum>[].obs;
  RxBool isSelected = false.obs;
  RxBool isLoading = false.obs;
  RxBool isOutLoading = false.obs;
  RxBool isMeetingCheckLoading = false.obs;
  RxBool isOutSelect = false.obs;
  var upCheckButtonMap = <String, bool>{}.obs;
  var selectedLocation = "".obs;
  RxBool mutualFundSelected = false.obs;
  RxBool fixedDepositSelected = false.obs;
  RxBool loanSelected = false.obs;
  RxBool insuranceSelected = false.obs;
  final formkey = GlobalKey<FormState>();
  TextEditingController customerIdController = TextEditingController();
  TextEditingController clientNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController familyDetailsController = TextEditingController();
  TextEditingController stockPortfolioController = TextEditingController();
  TextEditingController stockPortfolioOtherController = TextEditingController();
  TextEditingController pmsController = TextEditingController();
  TextEditingController reference1controller = TextEditingController();
  TextEditingController reference2controller = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController selectLocationController = TextEditingController();
  var defaultUserLat, defaultUserLong;
  RxList<MyProfileDatum> profileData = <MyProfileDatum>[].obs;
  var meetingLoadingMap = <String, bool>{}.obs;
  RxString selectedSlot = ''.obs;
  RxList<String> timeSlots = <String>[].obs;
  RxString selectedStartTime = ''.obs;
  RxString selectedEndTime = ''.obs;


  void generateTimeSlots({int intervalMinutes = 60}) {
    DateTime now = DateTime.now();
    DateTime start = DateTime(now.year, now.month, now.day, 8);
    DateTime end = DateTime(now.year, now.month, now.day, 20);
    timeSlots.clear();

    while (start.isBefore(end)) {
      DateTime next = start.add(Duration(minutes: intervalMinutes));
      final slot = "${DateFormat.jm().format(start)} - ${DateFormat.jm().format(next)}";
      timeSlots.add(slot);
      start = next;
    }
  }

  @override
  void onInit() {
    super.onInit();
    initiateProfileApi();
    initiatUserAttendanceData();
    getUpcomingMeetingData();
    generateTimeSlots();
    checkForUpdate();
  }
  Future<void> checkForUpdate() async {
    print("Checking for updates...");
    try {
      final context = Get.context; // Access the BuildContext
      if (context == null) {
        print("Context is null. Cannot show update dialog.");
        return;
      }

      final newVersion = NewVersionPlus(
        androidId: "com.lgt.wealthyfy", // Replace with your Android package name
        iOSId: 'com.lgt.wealthyfy',       // Replace with your iOS App Store ID
      );

      final status = await newVersion.getVersionStatus();
      if (status != null) {
        print("Current installed version: ${status.localVersion}");
        print("Current version on store: ${status.storeVersion}");

        if (status.canUpdate) {
          _showUpdateDialog(context, newVersion, status);
        } else {
          print("No update available. You are on the latest version.");
        }
      }
    } catch (e) {
      print("Error checking for updates: $e");
    }
  }


  void _showUpdateDialog(
      BuildContext context, NewVersionPlus newVersion, VersionStatus status) {
    newVersion.showUpdateDialog(
      context: context,
      versionStatus: status,
      dialogTitle: 'Update Available',
      dialogText: 'A newer version of the app is available. Please update!',
      updateButtonText: 'Update Now',
      dismissButtonText: 'Later',
      dismissAction: () {
        Get.back(); // Close the dialog
      },
    );
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

  void initiatCheckInData(defaultUserLatitude, defaultUserLongitude)   {
    print("chhhhhhhhhh");
    var hashMap = {
      "tbl_user_id": viewLoginDetail!.data.first.tblUserId.toString(),
      "tbl_office_id": viewLoginDetail!.data.first.tblOfficeId.toString(),
      "check_in_latitude": defaultUserLatitude,
      "check_in_longitude": defaultUserLongitude,
    };
    print("SUBMIT_APPLY_MAP=>$hashMap");

    checkinAPI(hashMap).then((onValue) {
      if (onValue.status) {
        isLoading.value=false;
        isSelected.value = true;
        showSuccessBottomSheet(onValue.message.toString());

      } else {
        isLoading.value=false;
        showErrorBottomSheet(onValue.message.toString());
        print('EXCEPTION: ${onValue.message.toString()}');
      }
    });
  }

  void initiatCheckOutData(defaultUserLatitude, defaultUserLongitude) {
    var hashMap = {
      "tbl_user_id": viewLoginDetail!.data.first.tblUserId.toString(),
      "tbl_office_id": viewLoginDetail!.data.first.tblOfficeId.toString(),
      "check_out_latitude": defaultUserLatitude,
      "check_out_longitude": defaultUserLongitude,
    };
    print("SUBMIT_APPLY_MAP=>$hashMap");

    checkoutAPI(hashMap).then((onValue) {
      if (onValue.status) {
        isOutLoading.value = false;
        showSuccessBottomSheet(onValue.message.toString());

      } else {
        isOutLoading.value = false;
        showErrorBottomSheet(onValue.message);
      }
    });
  }

  void initiatUserAttendanceData() {
    var hashMap = {
      "tbl_user_id": viewLoginDetail!.data.first.tblUserId.toString(),
    };
    print("SUBMIT_APPLY_MAP=>$hashMap");

    yesterdayUserAttendanceApi(hashMap).then((onValue) {
      if (onValue.status) {
        YesterdayUserAttendanceModel model = onValue.data;
        userYesterdayAttendanceList.value = model.data;
        print('SUCCESS=>${userYesterdayAttendanceList.length}');
      } else {
        print('EXCEPTION=>${onValue.message}');
      }
    });
  }

  void getUpcomingMeetingData() {
    var hashMap = {
      "tbl_user_id": viewLoginDetail!.data.first.tblUserId.toString(),
    };
    print("SUBMIT_APPLY_MAP=>$hashMap");

    dashboardApprovedMeetingApi(hashMap).then((onValue) {
      if (onValue.status) {
        DashboardApprovedMeetingModel model = onValue.data;
        dashboardApprovedMeetingList.value = model.data;
      } else {

        print('EXCEPTION=>${onValue.message}');
      }
    });
  }

  Future<void> initiateCheckMeetingData(String tblMeetingId) async {
    meetingLoadingMap[tblMeetingId] = true;
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      defaultUserLat = position.latitude.toString();
      defaultUserLong = position.longitude.toString();
      //defaultUserLong = position.toString();

      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        userCity = place.locality ?? "Unknown City";
        String country = place.country ?? "Unknown Country";
        String fullAddress =
            "${place.name ?? ''}, "
            "${place.street ?? ''}, "
            "${place.subLocality ?? ''}, "
            "${place.locality ?? ''}, "
            "${place.subAdministrativeArea ?? ''}, "
            "${place.administrativeArea ?? ''}, "
            "${place.postalCode ?? ''}, "
            "${place.country ?? ''}";

        userFullAddress = fullAddress.trim().replaceAll(RegExp(r'\s+,'), '');
        print("City: $userCity, Country: $country");
      }

      var hashMap = {
        "tbl_user_id": viewLoginDetail!.data.first.tblUserId.toString(),
        "tbl_office_id": viewLoginDetail!.data.first.tblOfficeId.toString(),
        "tbl_meeting_id": tblMeetingId.toString(),
        "meeting_check_in_latitude": defaultUserLat,
        "meeting_check_in_longitude": defaultUserLong,
        "meeting_check_in_full_address": userFullAddress,
      };
      print("MEETING_CHECKIN_DATA => $hashMap");
      var onValue = await meetingCheckInApi(hashMap);
      if (onValue.status) {
        showSuccessBottomSheet(onValue.message.toString());
        upCheckButtonMap[tblMeetingId] =
        !(upCheckButtonMap[tblMeetingId] ?? false);

        try {
          final permission = await Geolocator.checkPermission();
          final permissionValue =
              permission == LocationPermission.always ? "always" : "while_in_use";
          await meetingPermissionCheckApi({
            "tbl_user_id": viewLoginDetail!.data.first.tblUserId.toString(),
            "tbl_meeting_id": tblMeetingId.toString(),
            "permission": permissionValue,
          });
        } catch (error) {
          print("permission_check_api failed: $error");
        }

        // Schedule background tasks for fake check-ins
        final userId = viewLoginDetail!.data.first.tblUserId.toString();
        final officeId = viewLoginDetail!.data.first.tblOfficeId.toString();

        if (!kIsWeb) {
          Workmanager().registerOneOffTask(
            "meetingFakeCheckTask_5min_$tblMeetingId",
            "meetingFakeCheck",
            initialDelay: const Duration(minutes: 5),
            inputData: {
              "meeting_id": tblMeetingId,
              "tbl_user_id": userId,
              "tbl_office_id": officeId,
              "checkpoint_number": "1",
              "initial_check_in_timestamp":
                  DateTime.now().millisecondsSinceEpoch.toString(),
            },
          );

          Workmanager().registerOneOffTask(
            "meetingFakeCheckTask_10min_$tblMeetingId",
            "meetingFakeCheck",
            initialDelay: const Duration(minutes: 10),
            inputData: {
              "meeting_id": tblMeetingId,
              "tbl_user_id": userId,
              "tbl_office_id": officeId,
              "checkpoint_number": "2",
              "initial_check_in_timestamp":
                  DateTime.now().millisecondsSinceEpoch.toString(),
            },
          );
        }
      } else {
        showErrorBottomSheet(onValue.message.toString());
      //   Fluttertoast.showToast(
      //       msg: onValue.message.toString(), toastLength: Toast.LENGTH_LONG,backgroundColor: Colors.red);
      //   print(onValue.message);
      }
    } catch (error) {
      print("Error in initiateCheckMeetingData: $error");

    } finally {
      meetingLoadingMap[tblMeetingId] = false;
    }
  }
    void toggleMutualFund() {
    mutualFundSelected.value = !mutualFundSelected.value;
  }
  void toggleFixedDeposit() {
    fixedDepositSelected.value = !fixedDepositSelected.value;
  }
  void toggleLoan() {
    loanSelected.value = !loanSelected.value;
  }
  void toggleInsurance() {
    insuranceSelected.value = !insuranceSelected.value;
  }
  void containerselect() {
    isSelected.value = !isSelected.value;
  }
  void initiateCreateMeetingData() {
    var hashMap = {
      "tbl_user_id": viewLoginDetail!.data.first.tblUserId.toString(),
      "tbl_office_id": viewLoginDetail!.data.first.tblOfficeId.toString(),
      "client_id": customerIdController.text.trim(),
      "client_name": clientNameController.text.trim(),
      "client_email": emailController.text.trim(),
      "client_mobile": mobileNumberController.text.trim(),
      "city": userCity,
      "state": userState,
      "country": "india",
      "meeting_latitude": userLat,
      "meeting_longitude": userLng,
      "mutual_fund_portfolio": mutualFundSelected.value ? "no" : "yes",
      "fixed_deposite": fixedDepositSelected.value ? "no" : "yes",
      "loan_details": loanSelected.value ? "personal" : "home",
      "insurance": insuranceSelected.value ? "life" : "health",
      "family_details": familyDetailsController.text.trim(),
      "stock_portfolio_with_us": stockPortfolioController.text.trim(),
      "stock_portfolio_with_other_broker":
       stockPortfolioOtherController.text.trim(),
      "pms": pmsController.text.trim(),
      "reference_1": reference1controller.text.trim(),
      "reference_2": reference2controller.text.trim(),
      "remark": remarkController.text.trim(),
      "full_address": selectLocationController.text,
      "meeting_time_slot_from": selectedStartTime.toString(),
      "meeting_time_slot_to": selectedEndTime.toString(),
    };
    print("SUBMIT_MEETING_API=>$hashMap");
    createMeetingApi(hashMap).then((onValue) {
      if (onValue.status) {
        emailController.clear();
        mobileNumberController.clear();
        familyDetailsController.clear();
        stockPortfolioController.clear();
        stockPortfolioOtherController.clear();
        remarkController.clear();
        pmsController.clear();
        reference1controller.clear();
        reference2controller.clear();
        clientNameController.clear();
        customerIdController.clear();
        selectLocationController.clear();
        dController.onItemTapped(0);
        showSuccessBottomSheet(onValue.message);

      } else {
        showErrorBottomSheet(onValue.message);

      }
    });
  }

  Future<void> getLocation() async {
    final currentContext = navigatorKey.currentContext;
    if (currentContext == null) {
      print("Context is not available");
      return;
    }

    Prediction? prediction = await PlacesAutocomplete.show(
      context: currentContext,
      apiKey: kGoogleApiKey,
      mode: Mode.fullscreen,
      // Fullscreen search
      language: "en",
      components: [Component(Component.country, "in")], // Limit to India
    );

    if (prediction != null) {
      await fetchPlaceDetails(prediction.placeId!);
      selectLocationController.text = userFullAddress!;
    }
  }

  void getLatLong(String type) async{

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    defaultUserLat= position.latitude.toString();
    defaultUserLong=position.longitude.toString();

    if(type=="check out"){
     // isOutLoading.value = true;
      initiatCheckOutData(defaultUserLat,defaultUserLong);
    }else{

      initiatCheckInData(defaultUserLat,defaultUserLong);
    }
  }


}
