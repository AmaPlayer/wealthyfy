import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meeting/helper/colors.dart';
import 'package:meeting/controller/button_controller/custombuttom.dart';
import 'package:meeting/helper/textview.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../APIs/Api.dart';
import '../APIs/user_data.dart';
import '../Models/usermeeting_details_model.dart';
import '../controller/dashboardcontroller.dart';
import '../helper/ErrorBottomSheet.dart';
import 'edit_meetingdetails_screen.dart';

class PersonDetail extends StatefulWidget {
  final String tbl_meetingID;
  final int tabPosition;
  final DashboardController dController = Get.find<DashboardController>();

 PersonDetail({super.key, required this.tbl_meetingID, required this.tabPosition});

  @override
  State<PersonDetail> createState() => _PersonDetailState();
}

class _PersonDetailState extends State<PersonDetail> {
  bool isLoading = true;
  List<MeetingDetailDatum> userMeetingDetailsList = [];

  @override
  void initState() {
    super.initState();
 print("check tab index${widget.tabPosition}");
    initiateMeetingDeTail();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            appBar: AppBar(
            centerTitle: true,
            title: headingText(title: 'Meeting Detail'),
          ),body: Center(child: CircularProgressIndicator()),)
        : userMeetingDetailsList.isEmpty
            ? Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: headingText(title: 'Meeting Detail'),
                ),
                body: Center(
                  child: headingText(
                    title: 'No meeting details found.',
                    color: ColorConstants.BLACKCOLOR,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : Scaffold(
            appBar: userMeetingDetailsList.first.meetingStatus != 'pending'
                ? AppBar(
                    centerTitle: true,
                    title: headingText(title: 'Meeting Detail'),
                  )
                : AppBar(
                    centerTitle: true,
                    title: headingText(title: 'Meeting Detail'),
                    actions: widget.tabPosition == 0
                        ? [
                            Padding(
                              padding: const EdgeInsets.only(left: 1),
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditMeetingDetailsScreen(
                                                  userMeetingDetailslist: userMeetingDetailsList,
                                                  tbl_meetingid: userMeetingDetailsList.first.tblMeetingId,
                                                )));
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: ColorConstants.WHITECOLOR,
                                  )),
                            )
                          ]
                        : [],
                  ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _container1(),
                          _container2(),
                          _container3(),
                          _container4(),
                        ],
                      ),
                      addPadding(50, 0),
                      widget.tabPosition == 0
                          ? Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: userMeetingDetailsList.first.meetingStatus == "approved"
                                  ? CustomButton(
                                      text: userMeetingDetailsList.first.meetingStatus.capitalizeFirst.toString(),
                                      onPressed: () {
                                        initiateMeetingApprovedRejected("approved");
                                        Navigator.pop(context);
                                      },
                                      color: ColorConstants.GREENCOLOR,
                                    )
                                  : userMeetingDetailsList.first.meetingStatus == "rejected"
                                      ? CustomButton(
                                          text: userMeetingDetailsList.first.meetingStatus.capitalizeFirst.toString(),
                                          onPressed: () {
                                            initiateMeetingApprovedRejected("rejected");
                                            Navigator.pop(context);
                                          },
                                          color: ColorConstants.REDCOLOR,
                                        )
                                      : CustomButton(
                                          text: userMeetingDetailsList.first.meetingStatus.capitalizeFirst.toString(),
                                          color: ColorConstants.GREYCOLOR,
                                          onPressed: () {
                                            print("yessssss");
                                          },
                                        ),
                            )
                          : userMeetingDetailsList.first.meetingStatus != "pending"
                              ? CustomButton(
                                  text: userMeetingDetailsList.first.meetingStatus.capitalizeFirst.toString(),
                                  onPressed: () {
                                  },
                                  color:userMeetingDetailsList.first.meetingStatus == "pending"?ColorConstants.GREYCOLOR: userMeetingDetailsList.first.meetingStatus == "approved"?ColorConstants.GREENCOLOR:ColorConstants.REDCOLOR,
                                ).paddingOnly(bottom: 10)
                                  : Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 20, right: 20),
                                            child: CustomButton(
                                              text: 'Reject',
                                              onPressed: () {
                                                initiateMeetingApprovedRejected("rejected",);
                                                Navigator.pop(context);
                                              },
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 20, right: 20),
                                            child: CustomButton(
                                              text: 'Approve',
                                              onPressed: () {
                                                initiateMeetingApprovedRejected("approved");
                                                Navigator.pop(context);
                                              },
                                              color: Colors.green,
                                            ),
                                          ),
                                        )
                                      ],
                                    ).paddingOnly(bottom: 20)
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  _container1() => Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
            color: ColorConstants.WHITECOLOR,
            border: Border.all(color: ColorConstants.DarkMahroon),
            boxShadow: const [BoxShadow(blurRadius: 1, color: ColorConstants.GREYCOLOR)],
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            addPadding(15, 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                headingText(
                    title: 'Name:', color: ColorConstants.DarkMahroon, fontSize: 14, fontWeight: FontWeight.w500),
                headingText(
                    title: "${userMeetingDetailsList.first.fullName.capitalizeFirst.toString()} (${userMeetingDetailsList.first.designationAbbr.capitalizeFirst.toString()})",
                    color: ColorConstants.BLACKCOLOR,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)
              ],
            ),
            addPadding(15, 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                headingText(
                    title: 'Client Name:', color: ColorConstants.DarkMahroon, fontSize: 14, fontWeight: FontWeight.w500),
                headingText(
                    title: userMeetingDetailsList.first.clientName.capitalizeFirst.toString(),
                    color: ColorConstants.BLACKCOLOR,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)
              ],
            ),
            addPadding(10, 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                headingText(
                    title: 'Email:', color: ColorConstants.DarkMahroon, fontSize: 14, fontWeight: FontWeight.w500),
                headingText(
                    title: userMeetingDetailsList.first.clientEmail,
                    color: ColorConstants.BLACKCOLOR,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)
              ],
            ),
            addPadding(15, 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                headingText(
                    title: 'Status:', color: ColorConstants.DarkMahroon, fontSize: 14, fontWeight: FontWeight.w500),
                headingText(
                    title: userMeetingDetailsList.first.meetingStatus.capitalizeFirst.toString(),
                    color: ColorConstants.BLACKCOLOR,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)
              ],
            ),
            addPadding(10, 0),

            Row(
              children: [
                const Icon(
                  Icons.watch_later,
                  size: 20,
                  color: ColorConstants.GREYCOLOR,
                ),
                addPadding(0, 10),
                SizedBox(
                  width: 280,
                  child: headingFullText(
                      title:"Meeting Slot: ${userMeetingDetailsList.first.meetingTimeSlotFrom}${userMeetingDetailsList.first.meetingTimeSlotTo}".toString(),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.BLACKCOLOR),
                ),

              ],
            ),

            addPadding(10, 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: (){
                    _openMap(userMeetingDetailsList.first.fullAddress);
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 20,
                        color: ColorConstants.GREENCOLOR,
                      ),
                      addPadding(0, 10),
                      SizedBox(
                        width: 280,
                        child: headingFullText(
                            title: "Meeting Location: ${userMeetingDetailsList.first.fullAddress.capitalizeFirst}",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.BLACKCOLOR),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            addPadding(15, 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: (){
                    _openMap(userMeetingDetailsList.first.meetingCheckInFullAddress);
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 20,
                        color: ColorConstants.REDCOLOR,
                      ),
                      addPadding(0, 10),
                      SizedBox(
                        width: 280,
                        child: headingFullText(
                            title: "check-in Location: ${userMeetingDetailsList.first.meetingCheckInFullAddress.capitalizeFirst}",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.BLACKCOLOR),
                      ),

                    ],
                  ),
                ),

              ],
            ),
            addPadding(10, 0),
            Row(
              children: [
                const Icon(
                  Icons.watch_later,
                  size: 20,
                  color: ColorConstants.BLACKCOLOR,
                ),
                addPadding(0, 10),
                SizedBox(
                  width: 280,
                  child: headingFullText(
                      title:"Check-in Timestamp: ${_safeText(userMeetingDetailsList.first.meetingCheckInDateTime)}",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.BLACKCOLOR),
                ),

              ],
            ),
            addPadding(15, 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: (){
                    _openMap(userMeetingDetailsList.first.meetingCheckOutFullAddress);
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 20,
                        color: ColorConstants.GREENCOLOR,
                      ),
                      addPadding(0, 10),
                      SizedBox(
                        width: 280,
                        child: headingFullText(
                            title: "Check-out Location: ${_safeText(userMeetingDetailsList.first.meetingCheckOutFullAddress).capitalizeFirst}",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.BLACKCOLOR),
                      ),

                    ],
                  ),
                ),

              ],
            ),
            addPadding(10, 0),
            Row(
              children: [
                const Icon(
                  Icons.watch_later,
                  size: 20,
                  color: ColorConstants.BLACKCOLOR,
                ),
                addPadding(0, 10),
                SizedBox(
                  width: 280,
                  child: headingFullText(
                      title:"Check-out Timestamp: ${_safeText(userMeetingDetailsList.first.meetingCheckOutDateTime)}",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.BLACKCOLOR),
                ),

              ],
            ),

            addPadding(15, 0),
            Row(
              children: [
                const Icon(
                  Icons.phone,
                  size: 20,
                  color: ColorConstants.GREENCOLOR,
                ),
                addPadding(0, 10),
                headingText(
                    title: userMeetingDetailsList.first.clientMobile,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.BLACKCOLOR)
              ],
            ),
            headingText(title: 'Remark:', color: ColorConstants.DarkMahroon, fontSize: 18, fontWeight: FontWeight.w600),
            headingFullText(
                title: userMeetingDetailsList.first.remark.capitalizeFirst.toString(),
                color: ColorConstants.BLACKCOLOR,
                fontSize: 13,
                fontWeight: FontWeight.w500),
            addPadding(10, 0),
            headingText(title: 'Agenda:', color: ColorConstants.DarkMahroon, fontSize: 18, fontWeight: FontWeight.w600),
            headingFullText(
                title: _safeText(userMeetingDetailsList.first.meetingAgenda).capitalizeFirst.toString(),
                color: ColorConstants.BLACKCOLOR,
                fontSize: 13,
                fontWeight: FontWeight.w500),
            addPadding(10, 0),
          ],
        ),
      );

  _container2() => Container(
        margin: EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
            color: ColorConstants.WHITECOLOR,
            border: Border.all(color: ColorConstants.DarkMahroon),
            boxShadow: const [BoxShadow(blurRadius: 1, color: ColorConstants.GREYCOLOR)],
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.watch_later_outlined,
                        size: 20,
                        color: ColorConstants.GREENCOLOR,
                      ),
                      addPadding(0, 10),
                      headingText(
                          title: userMeetingDetailsList.first.meetingTime,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.BLACKCOLOR),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        size: 20,
                        color: ColorConstants.GREENCOLOR,
                      ),
                      addPadding(0, 10),
                      headingText(
                          title: userMeetingDetailsList.first.meetingDate,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.BLACKCOLOR)
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                headingText(
                    title: 'Family Details:',
                    color: ColorConstants.DarkMahroon,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                Flexible(
                  child: headingFullText(
                      title: userMeetingDetailsList.first.familyDetails.capitalizeFirst.toString(),
                      color: ColorConstants.BLACKCOLOR,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
            addPadding(10, 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                headingText(
                    title: 'Stock Portfolio With us:',
                    color: ColorConstants.DarkMahroon,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                Flexible(
                  child: headingFullText(
                      title: userMeetingDetailsList.first.stockPortfolioWithUs.capitalizeFirst.toString(),
                      color: ColorConstants.BLACKCOLOR,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
            addPadding(10, 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                headingText(
                    title: 'Stock Portfolio With Other Broker: ',
                    color: ColorConstants.DarkMahroon,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                Flexible(
                  child: headingFullText(
                      title: userMeetingDetailsList.first.stockPortfolioWithOtherBroker.capitalizeFirst.toString(),
                      color: ColorConstants.BLACKCOLOR,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
            addPadding(10, 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                headingText(
                    title: 'Mutual Fund Portfolio:',
                    color: ColorConstants.DarkMahroon,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                headingText(
                    title: userMeetingDetailsList.first.mutualFundPortfolio.capitalizeFirst.toString(),
                    color: ColorConstants.BLACKCOLOR,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)
              ],
            ),
            addPadding(10, 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                headingText(
                    title: 'Fixed Deposit:',
                    color: ColorConstants.DarkMahroon,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                headingText(
                    title: userMeetingDetailsList.first.fixedDeposite.capitalizeFirst.toString(),
                    color: ColorConstants.BLACKCOLOR,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)
              ],
            ),
            addPadding(10, 0),
          ],
        ),
      );

  _container4() {
    final meeting = userMeetingDetailsList.first;
    final cp0Lat = _parseCoord(meeting.meetingCheckInLatitude.isNotEmpty ? meeting.meetingCheckInLatitude : meeting.meetingLatitude);
    final cp0Lng = _parseCoord(meeting.meetingCheckInLongitude.isNotEmpty ? meeting.meetingCheckInLongitude : meeting.meetingLongitude);
    final cp1Lat = _parseCoord(meeting.checkpoint1Latitude);
    final cp1Lng = _parseCoord(meeting.checkpoint1Longitude);
    final cp2Lat = _parseCoord(meeting.checkpoint2Latitude);
    final cp2Lng = _parseCoord(meeting.checkpoint2Longitude);

    final cp0ToCp1 = _distanceMeters(cp0Lat, cp0Lng, cp1Lat, cp1Lng);
    final cp1ToCp2 = _distanceMeters(cp1Lat, cp1Lng, cp2Lat, cp2Lng);
    final cp0ToCp2 = _distanceMeters(cp0Lat, cp0Lng, cp2Lat, cp2Lng);

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
          color: ColorConstants.WHITECOLOR,
          border: Border.all(color: ColorConstants.DarkMahroon),
          boxShadow: const [BoxShadow(blurRadius: 1, color: ColorConstants.GREYCOLOR)],
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headingText(title: 'Checkpoints', color: ColorConstants.DarkMahroon, fontSize: 16, fontWeight: FontWeight.w600),
          addPadding(10, 0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              headingText(
                  title: 'Check-in Time:',
                  color: ColorConstants.DarkMahroon,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
              headingText(
                  title: _extractTime(meeting.meetingCheckInDateTime),
                  color: ColorConstants.BLACKCOLOR,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)
            ],
          ),
          addPadding(10, 0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              headingText(
                  title: 'Check-out Time:',
                  color: ColorConstants.DarkMahroon,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
              headingText(
                  title: _extractTime(meeting.meetingCheckOutDateTime),
                  color: ColorConstants.BLACKCOLOR,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)
            ],
          ),
          addPadding(10, 0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              headingText(
                  title: 'CP1 Timestamp:',
                  color: ColorConstants.DarkMahroon,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
              Flexible(
                child: headingFullText(
                    title: _safeText(meeting.checkpoint1DateTime),
                    color: ColorConstants.BLACKCOLOR,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
          addPadding(10, 0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              headingText(
                  title: 'CP2 Timestamp:',
                  color: ColorConstants.DarkMahroon,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
              Flexible(
                child: headingFullText(
                    title: _safeText(meeting.checkpoint2DateTime),
                    color: ColorConstants.BLACKCOLOR,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
          addPadding(10, 0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              headingText(
                  title: 'CP0 → CP1 Distance:',
                  color: ColorConstants.DarkMahroon,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
              headingText(
                  title: _formatDistance(cp0ToCp1),
                  color: ColorConstants.BLACKCOLOR,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)
            ],
          ),
          addPadding(10, 0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              headingText(
                  title: 'CP1 → CP2 Distance:',
                  color: ColorConstants.DarkMahroon,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
              headingText(
                  title: _formatDistance(cp1ToCp2),
                  color: ColorConstants.BLACKCOLOR,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)
            ],
          ),
          addPadding(10, 0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              headingText(
                  title: 'CP0 → CP2 Distance:',
                  color: ColorConstants.DarkMahroon,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
              headingText(
                  title: _formatDistance(cp0ToCp2),
                  color: ColorConstants.BLACKCOLOR,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)
            ],
          ),
        ],
      ),
    );
  }

  String _safeText(String? value) {
    if (value == null) return "--";
    final trimmed = value.trim();
    if (trimmed.isEmpty || trimmed == "--") return "--";
    return trimmed;
  }

  String _extractTime(String value) {
    final safeValue = _safeText(value);
    if (safeValue == "--") return "--";
    try {
      final parsed = DateFormat("dd-MM-yyyy, hh:mm:ss a").parse(safeValue);
      return DateFormat("hh:mm:ss a").format(parsed);
    } catch (_) {
      return safeValue;
    }
  }

  double? _parseCoord(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty || trimmed == "--") return null;
    return double.tryParse(trimmed);
  }

  double? _distanceMeters(double? lat1, double? lon1, double? lat2, double? lon2) {
    if (lat1 == null || lon1 == null || lat2 == null || lon2 == null) return null;
    const earthRadius = 6371000.0;
    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);
    final a = (math.sin(dLat / 2) * math.sin(dLat / 2)) +
        math.cos(_degToRad(lat1)) * math.cos(_degToRad(lat2)) *
            math.sin(dLon / 2) * math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  String _formatDistance(double? meters) {
    if (meters == null) return "--";
    if (meters >= 1000) {
      return "${(meters / 1000).toStringAsFixed(2)} km";
    }
    return "${meters.toStringAsFixed(2)} m";
  }

  double _degToRad(double deg) => deg * (3.141592653589793 / 180.0);

  _container3() => Container(
        margin: EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
            color: ColorConstants.WHITECOLOR,
            border: Border.all(color: ColorConstants.DarkMahroon),
            boxShadow: const [BoxShadow(blurRadius: 1, color: ColorConstants.GREYCOLOR)],
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                headingText(
                    title: 'Loan Details:',
                    color: ColorConstants.DarkMahroon,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                headingText(
                    title: userMeetingDetailsList.first.loanDetails.capitalizeFirst.toString(),
                    color: ColorConstants.BLACKCOLOR,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)
              ],
            ),
            addPadding(10, 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                headingText(
                    title: 'Insurance:', color: ColorConstants.DarkMahroon, fontSize: 14, fontWeight: FontWeight.w500),
                headingText(
                    title: userMeetingDetailsList.first.insurance.capitalizeFirst.toString(),
                    color: ColorConstants.BLACKCOLOR,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)
              ],
            ),
            addPadding(10, 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                headingText(
                    title: 'Reference 1:',
                    color: ColorConstants.DarkMahroon,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                Flexible(
                  child: headingFullText(
                      title: userMeetingDetailsList.first.reference1.capitalizeFirst.toString(),
                      color: ColorConstants.BLACKCOLOR,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
            addPadding(10, 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                headingText(
                    title: 'Reference 2:',
                    color: ColorConstants.DarkMahroon,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                Flexible(
                  child: headingFullText(
                      title: userMeetingDetailsList.first.reference2.capitalizeFirst.toString(),
                      color: ColorConstants.BLACKCOLOR,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
            addPadding(10, 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                headingText(
                    title: 'PMS:', color: ColorConstants.DarkMahroon, fontSize: 14, fontWeight: FontWeight.w500),
                headingText(
                    title: userMeetingDetailsList.first.pms.capitalizeFirst.toString(),
                    color: ColorConstants.BLACKCOLOR,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)
              ],
            ),
            addPadding(10, 0),
          ],
        ),
      );


  initiateMeetingDeTail() {
    //isLoading = true;
    var hashMap = {
      "tbl_user_id": viewLoginDetail!.data.first.tblUserId.toString(),
      "tbl_meeting_id": widget.tbl_meetingID.toString(),
    };
    print("DETAILS_MEETING_API=>$hashMap");
    userMeetingDetailsApi(hashMap).then((onValue) {
      setState(() {
        if (onValue.status) {
          UserMeetingDetailsModel model = onValue.data;
          userMeetingDetailsList = model.data;
          isLoading = false;
          print('SUCCESS=>${userMeetingDetailsList.length}');
        } else {
          isLoading = false;
          userMeetingDetailsList = [];
          print('EXCEPTION=>${onValue.message}');
          showErrorBottomSheet(onValue.message);
        }
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
        userMeetingDetailsList = [];
      });
      print("DETAILS_MEETING_API_ERROR=>$error");
      showErrorBottomSheet("Failed to load meeting details.");
    });
  }

  Future<void> _openMap(String address) async {
    final query = Uri.encodeComponent(address);
    final googleUrl = 'https://www.google.com/maps/search/?api=1&query=$query';

    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open the map.';
    }
  }
  initiateMeetingApprovedRejected(String status) {
    var hashMap = {
      "tbl_user_id": userMeetingDetailsList.first.tblUserId.toString(),
      "tbl_office_id": userMeetingDetailsList.first.tblOfficeId.toString(),
      "tbl_meeting_id": userMeetingDetailsList.first.tblMeetingId.toString(),
      "approved_reject_by_user_id": viewLoginDetail!.data.first.tblUserId.toString(),
      "approved_reject_by_user_type": viewLoginDetail!.data.first.designationType.toString(),
      "meeting_status": status,
    };
    print('MEETING_APPROVED_REJECTED_API=>$hashMap');
    meetingApprovedRejectedApi(hashMap).then((onValue) {
      if (onValue.status) {
        showSuccessBottomSheet(onValue.message);
       //Fluttertoast.showToast(msg: onValue.message,backgroundColor: ColorConstants.GREENCOLOR);
      } else {
        showErrorBottomSheet(onValue.message);
     //Fluttertoast.showToast(msg: onValue.message,backgroundColor: ColorConstants.REDCOLOR);
        print("EXCEPTION=>${onValue.message}");
      }
    });
  }


}
