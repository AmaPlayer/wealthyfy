import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:meeting/APIs/Api.dart';
import 'package:meeting/APIs/user_data.dart';
import 'package:meeting/controller/HomeTabController.dart';
import 'package:meeting/controller/button_controller/custombuttom.dart';
import 'package:meeting/controller/dashboardcontroller.dart';
import 'package:meeting/helper/ErrorBottomSheet.dart';
import 'package:meeting/helper/colors.dart';
import 'package:meeting/helper/textview.dart';
import 'package:meeting/screens/bottom_screen.dart';

class MeetingMinutesScreen extends StatefulWidget {
  final String tblMeetingId;
  final String meetingDate;
  final String initialMinutes;

  const MeetingMinutesScreen({
    super.key,
    required this.tblMeetingId,
    required this.meetingDate,
    this.initialMinutes = "",
  });

  @override
  State<MeetingMinutesScreen> createState() => _MeetingMinutesScreenState();
}

class _MeetingMinutesScreenState extends State<MeetingMinutesScreen> {
  final TextEditingController meetingMinutesController = TextEditingController();
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    meetingMinutesController.text = widget.initialMinutes;
  }

  @override
  void dispose() {
    meetingMinutesController.dispose();
    super.dispose();
  }

  bool _isWithinOneMonth(String meetingDate) {
    try {
      final meetingDay = DateFormat('dd-MM-yyyy').parseStrict(meetingDate);
      final now = DateTime.now();
      final diffDays = now.difference(meetingDay).inDays;
      return diffDays >= 0 && diffDays <= 30;
    } catch (_) {
      return false;
    }
  }

  Future<void> _submitMinutes() async {
    if (isSubmitting) {
      return;
    }

    final minutes = meetingMinutesController.text.trim();
    if (minutes.isEmpty) {
      showErrorBottomSheet("Please enter meeting minutes.");
      return;
    }

    if (!_isWithinOneMonth(widget.meetingDate)) {
      showErrorBottomSheet("Minutes can only be added within 1 month.");
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    var hashMap = {
      "tbl_user_id": viewLoginDetail!.data.first.tblUserId.toString(),
      "tbl_meeting_id": widget.tblMeetingId,
      "meeting_minutes": minutes,
    };

    final onValue = await meetingMinutesApi(hashMap);
    if (onValue.status) {
      showSuccessBottomSheet(onValue.message);
      final controller = Get.find<HomeTabController>();
      controller.refreshIncompleteMeetings();
      if (mounted) {
        Get.find<DashboardController>().onItemTapped(0);
        Get.offAll(MyBottomBar());
      }
    } else {
      showErrorBottomSheet(onValue.message);
    }

    if (mounted) {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final withinOneMonth = _isWithinOneMonth(widget.meetingDate);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: headingText(title: 'Meeting Minutes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ColorConstants.GREY4COLOR,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: ColorConstants.GREYCOLOR),
              ),
              child: headingFullText(
                title: "Note: Please fill minutes of meeting/agenda and benefit to company.",
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: ColorConstants.BLACKCOLOR,
              ),
            ),
            addPadding(15, 0),
            TextFormField(
              controller: meetingMinutesController,
              maxLines: 6,
              cursorColor: ColorConstants.GREYCOLOR,
              decoration: InputDecoration(
                labelText: 'Minutes / Agenda',
                labelStyle: const TextStyle(
                  fontSize: 16,
                  color: ColorConstants.GREYCOLOR,
                ),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: ColorConstants.DarkMahroon,
                  ),
                ),
              ),
            ),
            addPadding(15, 0),
            if (!withinOneMonth)
              headingText(
                title: 'Minutes can only be added within 1 month of the meeting.',
                color: ColorConstants.REDCOLOR,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            addPadding(10, 0),
            Center(
              child: CustomButton(
                text: isSubmitting ? 'Submitting...' : 'Submit',
                onPressed: withinOneMonth && !isSubmitting ? _submitMinutes : () {},
                color: withinOneMonth ? ColorConstants.DarkMahroon : ColorConstants.GREYCOLOR,
                width: 150,
                textStyle: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            if (isSubmitting) ...[
              addPadding(10, 0),
              const Center(child: CircularProgressIndicator()),
            ],
          ],
        ),
      ),
    );
  }
}
