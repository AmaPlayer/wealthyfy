import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:meeting/controller/HomeTabController.dart';
import 'package:meeting/helper/colors.dart';
import 'package:meeting/screens/notification_sreen.dart';
import '../helper/ErrorBottomSheet.dart';
import '../helper/imagees.dart';
import '../helper/textview.dart';
import '../screens/TeamListView.dart';
import '../screens/team_leave.dart';
import '../screens/team_meeting.dart';
import '../screens/my_leave_screen.dart';
import '../screens/workingsheet_screen.dart';

class HomeTab extends GetView<HomeTabController> {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => PopScope(
          canPop: false,
          onPopInvokedWithResult: (value, other) => onKillApp(context),
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {
                      Get.to(NotificationSreen());
                    },
                    icon: const Icon(Icons.notifications_active)),
              ],
              title: headingText(title: 'Welcome', fontWeight: FontWeight.bold, fontSize: 20),
              automaticallyImplyLeading: false,
              backgroundColor: const Color(0xFF5D0C1D),
            ),
            body: controller.dController.profileData.isEmpty
                ? Center(
                    child: controller.dController.profileError.value.isNotEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              headingText(
                                title: controller.dController.profileError.value,
                                color: ColorConstants.REDCOLOR,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              addPadding(10, 0),
                              TextButton(
                                onPressed: () => controller.dController.initiateProfileApi(),
                                child: headingText(
                                  title: 'Retry',
                                  color: ColorConstants.DarkMahroon,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : const CircularProgressIndicator(
                            color: ColorConstants.DarkMahroon,
                          ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: SingleChildScrollView(
                      child: Column(
                        children: controller.dController.profileData.first.IsMdVpBm == "no"
                            ? [
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                      color: ColorConstants.DarkMahroon,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20), topLeft: Radius.circular(20))),
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      headingText(
                                          title: controller.dController.profileData.first.fullName
                                              .toString()
                                              .capitalizeFirst,
                                          color: ColorConstants.WHITECOLOR,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                      addPadding(10, 0),
                                      headingText(
                                          title: controller
                                              .dController.profileData.first.designationName.capitalizeFirst
                                              .toString(),
                                          color: ColorConstants.AMBERCOLOR,
                                          fontSize: 17)
                                    ],
                                  ),
                                ),
                                _checkInCheckOutUi(),
                                addPadding(15, 0),
                                _teamMeetingUi(),
                                addPadding(15, 0),
                                _todayUpcoming(),
                                addPadding(15, 0),
                                _editableMeetings(),
                                addPadding(15, 0),
                                _myLeaveUi(),
                                addPadding(15, 0),
                                _historyUi(),
                                addPadding(20, 0),
                              ]
                            : [
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                      color: ColorConstants.DarkMahroon,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20), topLeft: Radius.circular(20))),
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      headingText(
                                          title: controller.dController.profileData.first.fullName.capitalizeFirst
                                              .toString(),
                                          color: ColorConstants.WHITECOLOR,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      addPadding(10, 0),
                                      headingText(
                                          title: controller
                                              .dController.profileData.first.designationName.capitalizeFirst
                                              .toString(),
                                          color: ColorConstants.AMBERCOLOR,
                                          fontSize: 17)
                                    ],
                                  ),
                                ),
                                _checkInCheckOutUi(),
                                addPadding(15, 0),
                                 _myTeamUi(),
                                addPadding(15, 0),
                                _teamMeetingUi(),
                                addPadding(15, 0),
                                _todayUpcoming(),
                                addPadding(15, 0),
                                _editableMeetings(),
                                addPadding(15, 0),
                                _myLeaveUi(),
                                addPadding(15, 0),
                                _teamLeaveUi(),
                                addPadding(15, 0),
                                _historyUi(),
                                addPadding(20, 0),
                              ],
                      ),
                    ),
                  ),
          ),
        ));
  }

  _checkInCheckOutUi() => Obx(() => Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            boxShadow: [BoxShadow(blurRadius: 1, color: ColorConstants.GREYCOLOR)],
            color: ColorConstants.WHITECOLOR,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          controller.isLoading.value = true;
                          if(controller.profileData.first.checkInStatus == "yes"){
                            showErrorBottomSheet("Already Checked in");
                            controller.isLoading.value = false;
                          }else{
                            controller.getLatLong('Check In');
                          }
                        },
                        child: Stack(
                          children: [
                            Image.asset(checkingButton, height: 70),
                            controller.isLoading.value
                                ? Positioned(
                                    left: 17,
                                    top: 18,
                                    child: const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(ColorConstants.GREENCOLOR),
                                    ),
                                  )
                                : (controller.isSelected.value
                                    ? Positioned(
                                        left: 21,
                                        top: 20,
                                        child: const Icon(
                                          Icons.check,
                                          color: ColorConstants.GREENCOLOR,
                                        ),
                                      )
                                    : controller.dController.profileData.first.checkInStatus == "yes"
                                        ? Positioned(
                                            left: 21,
                                            top: 20,
                                            child: const Icon(
                                              Icons.check,
                                              color: ColorConstants.GREENCOLOR,
                                            ),
                                          )
                                        : Positioned(
                                            left: 21,
                                            top: 20,
                                            child: Image.asset(
                                              fingerimage,
                                              color: ColorConstants.GREENCOLOR,
                                              height: 25,
                                            ),
                                          ))
                          ],
                        ),
                      ),
                      headingText(
                          title: controller.isSelected.value
                              ? 'Checked In'
                              : controller.dController.profileData.first.checkInStatus == "yes"
                                  ? 'Checked In'
                                  : 'Check In',
                          color: ColorConstants.GREENCOLOR,
                          fontWeight: FontWeight.bold),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, left: 10),
                    child: headingText(
                      title: '08:30 AM -',
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, right: 10),
                    child: headingText(
                      title: '05:00 PM',
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          controller.isOutLoading.value = true;
                          if( controller.dController.profileData.first.checkOutStatus == "yes"){
                            showErrorBottomSheet("Already Checked out");
                            controller.isOutLoading.value = false;
                          }else{
                            controller.getLatLong("check out");
                          }
                        },
                        child: Stack(
                          children: [
                            Image.asset(
                              checkingButton,
                              height: 70,
                            ),
                            controller.isOutLoading.value
                                ? Positioned(
                                    left: 17,
                                    top: 17,
                                    child: const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(ColorConstants.REDCOLOR),
                                    ),
                                  )
                                : Positioned(
                                    left: 18,
                                    top: 22,
                                    child: Icon(Icons.logout,
                                            color: controller.dController.profileData.first.checkOutStatus == "yes"
                                                ? ColorConstants.REDCOLOR
                                                : controller.isOutLoading.value
                                                ? ColorConstants.REDCOLOR
                                                : ColorConstants.REDCOLOR)
                                        .paddingOnly(left: 5),
                                  )
                          ],
                        ),
                      ),
                      headingText(
                          title: controller.isOutLoading.value
                              ? 'Checked Out'
                              : controller.dController.profileData.first.checkOutStatus == "yes"
                                  ? 'Checked Out'
                                  : 'Check Out',
                          color: ColorConstants.REDCOLOR,
                          fontWeight: FontWeight.bold),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ));

  _myTeamUi() => InkWell(
          onTap: () async{
            EasyLoading.show();
            await Future.delayed(Duration(milliseconds: 500)); // Optional: to show animation briefly
            Get.to(TeamLisView());
          },
          child: Stack(children: [
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              height: 10,
              decoration: BoxDecoration(
                  color: ColorConstants.GREY4COLOR,
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
              width: double.infinity,
            ),
            Container(
              margin: const EdgeInsets.only(left: 15, right: 15, top: 5),
              height: 10,
              decoration: const BoxDecoration(
                  color: ColorConstants.GREENCOLOR,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
              width: double.infinity,
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              decoration: BoxDecoration(color: ColorConstants.DarkMahroon, borderRadius: BorderRadius.circular(25)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          headingText(
                              title: 'My Team',
                              fontWeight: FontWeight.bold,
                              color: ColorConstants.WHITECOLOR,
                              fontSize: 15),
                          headingText(title: 'View my all team', color: ColorConstants.WHITECOLOR),
                        ],
                      ),
                      const Icon(
                        Icons.arrow_circle_right_sharp,
                        color: ColorConstants.WHITECOLOR,
                        size: 40,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ]),
        );


  _teamMeetingUi() => controller.dController.profileData.first.IsMdVpBm == "no"
      ? InkWell(
    onTap: () async{
      EasyLoading.show();
      await Future.delayed(Duration(milliseconds: 500)); // Option
      Get.to(meetingListView());
    },
    child: Stack(children: [
      Container(
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        height: 10,
        decoration: BoxDecoration(
            color: ColorConstants.GREY4COLOR,
            borderRadius: const BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
        width: double.infinity,
      ),
      Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 5),
        height: 10,
        decoration: const BoxDecoration(
            color: ColorConstants.GREENCOLOR,
            borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
        width: double.infinity,
      ),
      Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(color: ColorConstants.DarkMahroon, borderRadius: BorderRadius.circular(25)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headingText(
                        title: 'My Meeting',
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.WHITECOLOR,
                        fontSize: 15),
                    headingText(title: 'Discussing the project with the team', color: ColorConstants.WHITECOLOR),
                  ],
                ),
                const Icon(
                  Icons.arrow_circle_right_sharp,
                  color: ColorConstants.WHITECOLOR,
                  size: 40,
                )
              ],
            ),
          ],
        ),
      ),
    ]),
  )
      : InkWell(
    onTap: () {
      Get.to(meetingListView());
    },
    child: Stack(children: [
      Container(
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        height: 10,
        decoration: BoxDecoration(
            color: ColorConstants.GREY4COLOR,
            borderRadius: const BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
        width: double.infinity,
      ),
      Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 5),
        height: 10,
        decoration: const BoxDecoration(
            color: ColorConstants.GREENCOLOR,
            borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
        width: double.infinity,
      ),
      Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(color: ColorConstants.DarkMahroon, borderRadius: BorderRadius.circular(25)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headingText(
                        title: 'Meetings',
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.WHITECOLOR,
                        fontSize: 18),
                    headingText(title: 'Discussing the project with the team', color: ColorConstants.WHITECOLOR),
                  ],
                ),
                const Icon(
                  Icons.arrow_circle_right_sharp,
                  color: ColorConstants.WHITECOLOR,
                  size: 40,
                )
              ],
            ),
          ],
        ),
      ),
    ]),
  );

  _myLeaveUi() => InkWell(
        onTap: () async{
          EasyLoading.show();
          await Future.delayed(Duration(milliseconds: 500)); // Optional: to show animation briefly
          Get.to(LeaveScreen());
        },
        child: Stack(children: [
          Container(
            margin: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            height: 10,
            decoration: BoxDecoration(
                color: ColorConstants.GREY4COLOR,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
            width: double.infinity,
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15, top: 5),
            height: 10,
            decoration: const BoxDecoration(
                color: ColorConstants.GREENCOLOR,
                borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
            width: double.infinity,
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(15),
            width: double.infinity,
            decoration: BoxDecoration(color: ColorConstants.DarkMahroon, borderRadius: BorderRadius.circular(25)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                headingText(
                    title: 'My Leave', fontWeight: FontWeight.bold, color: ColorConstants.WHITECOLOR, fontSize: 16),
                const Icon(
                  Icons.calendar_month_outlined,
                  color: ColorConstants.WHITECOLOR,
                  size: 30,
                )
              ],
            ),
          ),
        ]),
      );

  _historyUi() => controller.userYesterdayAttendanceList.isEmpty
      ? InkWell(
    onTap: () async {
      EasyLoading.show();
      await Future.delayed(Duration(milliseconds: 500)); // Optional: to show animation briefly

      Get.to(WorkingsheetScreen());
    },
        child: Stack(children: [
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              height: 10,
              decoration: BoxDecoration(
                  color: ColorConstants.GREY4COLOR,
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
              width: double.infinity,
            ),
            Container(
              margin: const EdgeInsets.only(left: 15, right: 15, top: 5),
              height: 10,
              decoration: const BoxDecoration(
                  color: ColorConstants.GREENCOLOR,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
              width: double.infinity,
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              decoration: BoxDecoration(color: ColorConstants.DarkMahroon, borderRadius: BorderRadius.circular(25)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      headingText(
                          title: 'N/A', color: ColorConstants.WHITECOLOR, fontWeight: FontWeight.bold, fontSize: 14),
                      headingText(
                          title: 'N/A', color: ColorConstants.WHITECOLOR, fontWeight: FontWeight.bold, fontSize: 14),
                    ],
                  ),
                  addPadding(5, 0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 5, right: 10),
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                    color: ColorConstants.GREENCOLOR, borderRadius: BorderRadius.circular(20)),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  headingText(title: 'Check-in', color: ColorConstants.GREY2COLOR),
                                  headingText(
                                      title: '00:00:00',
                                      color: ColorConstants.WHITECOLOR,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      Container(
                        height: 40,
                        width: 2,
                        decoration:
                            BoxDecoration(color: ColorConstants.WHITECOLOR, borderRadius: BorderRadius.circular(10)),
                      ),
                      Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 5, right: 10),
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                    color: ColorConstants.GREENCOLOR, borderRadius: BorderRadius.circular(20)),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  headingText(title: 'Check-out', color: ColorConstants.GREY2COLOR),
                                  headingText(
                                      title: '00:00:00',
                                      color: ColorConstants.WHITECOLOR,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)
                                ],
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ]),
      )
      : InkWell(
          onTap: () {
            Get.to(WorkingsheetScreen());
          },
          child: Stack(children: [
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              height: 10,
              decoration: BoxDecoration(
                  color: ColorConstants.GREY4COLOR,
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
              width: double.infinity,
            ),
            Container(
              margin: const EdgeInsets.only(left: 15, right: 15, top: 5),
              height: 10,
              decoration: const BoxDecoration(
                  color: ColorConstants.GREENCOLOR,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
              width: double.infinity,
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              decoration: BoxDecoration(color: ColorConstants.DarkMahroon, borderRadius: BorderRadius.circular(25)),
              child: controller.userYesterdayAttendanceList.isEmpty
                  ? headingText(title: 'No Attendance Records', color: Colors.white, fontWeight: FontWeight.bold)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            headingText(
                                title: controller.userYesterdayAttendanceList.first.createdDate,
                                color: ColorConstants.WHITECOLOR,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                            headingText(
                                title: controller.userYesterdayAttendanceList.first.workingTime,
                                color: ColorConstants.WHITECOLOR,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ],
                        ),
                        addPadding(5, 0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 5, right: 10),
                                      height: 10,
                                      width: 10,
                                      decoration: BoxDecoration(
                                          color: ColorConstants.GREENCOLOR, borderRadius: BorderRadius.circular(20)),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        headingText(title: 'Check-in', color: ColorConstants.GREY2COLOR),
                                        headingText(
                                            title: controller.userYesterdayAttendanceList.first.checkInTime,
                                            color: ColorConstants.WHITECOLOR,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              height: 40,
                              width: 2,
                              decoration: BoxDecoration(
                                  color: ColorConstants.WHITECOLOR, borderRadius: BorderRadius.circular(10)),
                            ),
                            Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 5, right: 10),
                                      height: 10,
                                      width: 10,
                                      decoration: BoxDecoration(
                                          color: ColorConstants.GREENCOLOR, borderRadius: BorderRadius.circular(20)),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        headingText(title: 'Check-out', color: ColorConstants.GREY2COLOR),
                                        headingText(
                                            title: controller.userYesterdayAttendanceList.first.checkOutTime,
                                            color: ColorConstants.WHITECOLOR,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
            ),
          ]),
        );

  _teamLeaveUi() => InkWell(
        onTap: () async{
          EasyLoading.show();
          await Future.delayed(Duration(milliseconds: 500)); // Optional: to show animation briefly
          Get.to(TeamLeave());
        },
        child: Stack(children: [
          Container(
            margin: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            height: 10,
            decoration: BoxDecoration(
                color: ColorConstants.GREY4COLOR,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
            width: double.infinity,
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15, top: 5),
            height: 10,
            decoration: const BoxDecoration(
                color: ColorConstants.GREENCOLOR,
                borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
            width: double.infinity,
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            decoration: BoxDecoration(color: ColorConstants.DarkMahroon, borderRadius: BorderRadius.circular(25)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                headingText(
                    title: 'Team Leave', fontWeight: FontWeight.bold, color: ColorConstants.WHITECOLOR, fontSize: 16),
                const Icon(
                  Icons.arrow_circle_right_sharp,
                  color: ColorConstants.WHITECOLOR,
                  size: 30,
                )
              ],
            ),
          ),
        ]),
      );

  _todayUpcoming() => controller.dashboardApprovedMeetingList.isEmpty
      ? InkWell(
          onTap: () async{
            EasyLoading.show();
            await Future.delayed(Duration(milliseconds: 500));
            EasyLoading.dismiss();
            controller.dController.onItemTapped(1);
          },
          child: Stack(children: [
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              height: 10,
              decoration: BoxDecoration(
                  color: ColorConstants.GREY4COLOR,
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
              width: double.infinity,
            ),
            Container(
              margin: const EdgeInsets.only(left: 15, right: 15, top: 5),
              height: 10,
              decoration: const BoxDecoration(
                  color: ColorConstants.GREENCOLOR,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
              width: double.infinity,
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.only(top: 25, bottom: 25, right: 15, left: 15),
              width: double.infinity,
              decoration: BoxDecoration(color: ColorConstants.DarkMahroon, borderRadius: BorderRadius.circular(25)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  headingText(
                      title: 'No Meetings Available',
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.WHITECOLOR,
                      fontSize: 15),
                  headingText(
                      title: 'Create Meetings',
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.WHITECOLOR,
                      fontSize: 15),
                ],
              ),
            ),
          ]),
        )
      : Stack(children: [
          Container(
            margin: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            height: 10,
            decoration: BoxDecoration(
                color: ColorConstants.GREY4COLOR,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
            width: double.infinity,
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15, top: 5),
            height: 10,
            decoration: const BoxDecoration(
                color: ColorConstants.GREENCOLOR,
                borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
            width: double.infinity,
          ),
          Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.only(top: 0, bottom: 10),
              width: double.infinity,
              decoration: BoxDecoration(color: ColorConstants.DarkMahroon, borderRadius: BorderRadius.circular(25)),
              child: Column(children: [
                Obx(() => ExpansionTile(
                        key: Key(controller.dashboardApprovedMeetingList.first.tblMeetingId),
                        iconColor: ColorConstants.WHITECOLOR,
                        collapsedIconColor: ColorConstants.WHITECOLOR,
                        shape: const UnderlineInputBorder(borderSide: BorderSide.none),
                        title: Row(
                          children: [
                            headingText(
                              title: 'Upcoming meetings',
                              fontWeight: FontWeight.bold,
                              color: ColorConstants.WHITECOLOR,
                              fontSize: 16,
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_drop_down_circle_outlined,
                              color: ColorConstants.APPTIRLE,
                            ),
                          ],
                        ),
                        subtitle: Builder(
                          builder: (_) {
                            final meetingId = controller.dashboardApprovedMeetingList.first.tblMeetingId;
                            final hasCheckedIn =
                                controller.upCheckButtonMap[meetingId] == true ||
                                controller.dashboardApprovedMeetingList.first.meetingCheckInStatus == "yes";
                            final hasCheckedOut =
                                controller.meetingCheckOutButtonMap[meetingId] == true ||
                                controller.dashboardApprovedMeetingList.first.meetingCheckOutStatus == "yes";

                            return Row(
                              children: [
                                headingFullText(
                                  title: '${controller.dashboardApprovedMeetingList.first.clientName} \n'
                                      '${controller.dashboardApprovedMeetingList.first.meetingDate} \n'
                                      '${controller.dashboardApprovedMeetingList.first.meetingTime}',
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                Spacer(),
                                if (!hasCheckedIn)
                                  IconButton(
                                    onPressed: () async {
                                      await controller.openEditMeeting(meetingId);
                                    },
                                    icon: const Icon(Icons.edit, color: ColorConstants.WHITECOLOR),
                                  ),
                                !hasCheckedIn
                                    ? InkWell(
                                        onTap: () {
                                          controller.meetingLoadingMap[meetingId] = true;
                                          controller.initiateCheckMeetingData(meetingId);
                                        },
                                        child: Obx(
                                          () => controller.meetingLoadingMap[meetingId] == true
                                              ? SizedBox(
                                                  height: 50,
                                                  width: 50,
                                                  child: CircularProgressIndicator(
                                                    valueColor: AlwaysStoppedAnimation<Color>(
                                                      ColorConstants.GREENCOLOR,
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  alignment: Alignment.center,
                                                  padding: const EdgeInsets.all(5),
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    color: ColorConstants.WHITECOLOR,
                                                    boxShadow: const [
                                                      BoxShadow(blurRadius: 5, color: Colors.white),
                                                    ],
                                                    borderRadius: BorderRadius.circular(30),
                                                  ),
                                                  child: headingFullText(
                                                    title: 'Check\n in',
                                                    align: TextAlign.center,
                                                    color: ColorConstants.DarkMahroon,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ).paddingOnly(right: 0),
                                        ),
                                      )
                                    : !hasCheckedOut
                                        ? InkWell(
                                            onTap: () {
                                              controller.meetingCheckOutLoadingMap[meetingId] = true;
                                              controller.initiateMeetingCheckOutData(meetingId);
                                            },
                                            child: Obx(
                                              () => controller.meetingCheckOutLoadingMap[meetingId] == true
                                                  ? SizedBox(
                                                      height: 50,
                                                      width: 50,
                                                      child: CircularProgressIndicator(
                                                        valueColor: AlwaysStoppedAnimation<Color>(
                                                          ColorConstants.REDCOLOR,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      alignment: Alignment.center,
                                                      padding: const EdgeInsets.all(5),
                                                      height: 50,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        color: ColorConstants.WHITECOLOR,
                                                        boxShadow: const [
                                                          BoxShadow(blurRadius: 5, color: Colors.white),
                                                        ],
                                                        borderRadius: BorderRadius.circular(30),
                                                      ),
                                                      child: headingFullText(
                                                        title: 'Check\n out',
                                                        align: TextAlign.center,
                                                        color: ColorConstants.REDCOLOR,
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                            ),
                                          )
                                        : Icon(
                                            Icons.check_circle,
                                            color: ColorConstants.REDCOLOR,
                                            size: 50,
                                          ).paddingOnly(right: 10),
                              ],
                            ).paddingOnly(top: 20);
                          },
                        ),
      showTrailingIcon: false,
      children: [
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: controller.dashboardApprovedMeetingList.length,
                                  itemBuilder: (context, index) {
                                    var data = controller.dashboardApprovedMeetingList[index];

                                    if (controller.dashboardApprovedMeetingList.first.tblMeetingId ==
                                        data.tblMeetingId) {
                                      return SizedBox();
                                    }

                                    return Obx(() {
                                      final meetingId = data.tblMeetingId;
                                      final hasCheckedIn = controller.upCheckButtonMap[meetingId] == true || data.meetingCheckInStatus == "yes";
                                      final hasCheckedOut =
                                          controller.meetingCheckOutButtonMap[meetingId] == true || data.meetingCheckOutStatus == "yes";

                                      return Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                headingText(
                                                  title: data.clientName,
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorConstants.WHITECOLOR,
                                                  fontSize: 14,
                                                ),
                                                addPadding(3, 0),
                                                headingText(
                                                  title: data.meetingDate,
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorConstants.WHITECOLOR,
                                                  fontSize: 14,
                                                ),
                                                addPadding(3, 0),
                                                headingText(
                                                  title: data.meetingTime,
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorConstants.WHITECOLOR,
                                                  fontSize: 14,
                                                ),
                                                addPadding(3, 0),
                                              ],
                                            ),
                                            if (!hasCheckedIn)
                                              IconButton(
                                                onPressed: () async {
                                                  await controller.openEditMeeting(meetingId);
                                                },
                                                icon: const Icon(Icons.edit, color: ColorConstants.WHITECOLOR),
                                              ),
                                            !hasCheckedIn
                                                ? InkWell(
                                                    onTap: () {
                                                      controller.meetingLoadingMap[meetingId] = true;
                                                      controller.initiateCheckMeetingData(meetingId);
                                                    },
                                                    child: controller.meetingLoadingMap[meetingId] == true
                                                        ? SizedBox(
                                                            height: 40,
                                                            width: 40,
                                                            child: CircularProgressIndicator(
                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                ColorConstants.WHITECOLOR,
                                                              ),
                                                            ),
                                                          )
                                                        : Container(
                                                            alignment: Alignment.center,
                                                            padding: const EdgeInsets.all(5),
                                                            height: 50,
                                                            width: 50,
                                                            decoration: BoxDecoration(
                                                              color: ColorConstants.WHITECOLOR,
                                                              boxShadow: const [
                                                                BoxShadow(blurRadius: 5, color: Colors.white),
                                                              ],
                                                              borderRadius: BorderRadius.circular(30),
                                                            ),
                                                            child: headingFullText(
                                                              title: 'Check\n in',
                                                              align: TextAlign.center,
                                                              color: ColorConstants.DarkMahroon,
                                                              fontSize: 10,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                  )
                                                : !hasCheckedOut
                                                    ? InkWell(
                                                        onTap: () {
                                                          controller.meetingCheckOutLoadingMap[meetingId] = true;
                                                          controller.initiateMeetingCheckOutData(meetingId);
                                                        },
                                                        child: controller.meetingCheckOutLoadingMap[meetingId] == true
                                                            ? SizedBox(
                                                                height: 40,
                                                                width: 40,
                                                                child: CircularProgressIndicator(
                                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                                    ColorConstants.REDCOLOR,
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(
                                                                alignment: Alignment.center,
                                                                padding: const EdgeInsets.all(5),
                                                                height: 50,
                                                                width: 50,
                                                                decoration: BoxDecoration(
                                                                  color: ColorConstants.WHITECOLOR,
                                                                  boxShadow: const [
                                                                    BoxShadow(blurRadius: 5, color: Colors.white),
                                                                  ],
                                                                  borderRadius: BorderRadius.circular(30),
                                                                ),
                                                                child: headingFullText(
                                                                  title: 'Check\n out',
                                                                  align: TextAlign.center,
                                                                  color: ColorConstants.REDCOLOR,
                                                                  fontSize: 10,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                      )
                                                    : Icon(
                                                        Icons.check_circle,
                                                        color: ColorConstants.REDCOLOR,
                                                        size: 40,
                                                      ),
                                          ],
                                        ).paddingOnly(top: 10, left: 10, right: 10);
                                    });
                                  })),
      ]))
              ])),
        ]);

  _editableMeetings() => Obx(() {
        if (controller.isEditableMeetingLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: ColorConstants.DarkMahroon,
            ),
          );
        }

        if (controller.editableMeetingList.isEmpty) {
          return Container(
            margin: const EdgeInsets.only(top: 5),
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            decoration: BoxDecoration(color: ColorConstants.WHITECOLOR, borderRadius: BorderRadius.circular(15)),
            child: headingText(
              title: 'No editable meetings',
              color: ColorConstants.GREYCOLOR,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(color: ColorConstants.WHITECOLOR, borderRadius: BorderRadius.circular(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headingText(
                title: 'Editable meetings (last 1 day)',
                fontWeight: FontWeight.bold,
                color: ColorConstants.DarkMahroon,
                fontSize: 16,
              ),
              addPadding(10, 0),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.editableMeetingList.length,
                itemBuilder: (context, index) {
                  final meeting = controller.editableMeetingList[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ColorConstants.WHITECOLOR,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ColorConstants.GREYCOLOR),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: headingFullText(
                            title: '${meeting.clientName}\n${meeting.meetingDate} ${meeting.meetingTime}',
                            color: ColorConstants.BLACKCOLOR,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await controller.openEditMeeting(meeting.tblMeetingId);
                          },
                          icon: const Icon(Icons.edit, color: ColorConstants.DarkMahroon),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      });

  onKillApp(BuildContext context) {
    if (controller.dController.selectedIndex == 0) {
      showDialog(context: context, builder: (BuildContext context) => exitConfirmation(context));
    } else {
      controller.dController.onItemTapped(0);
    }
  }
}
