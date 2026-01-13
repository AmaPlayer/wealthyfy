import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:meeting/helper/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../APIs/Api.dart';
import '../APIs/user_data.dart';
import '../Models/userleave_applylist_Model.dart';
import '../controller/filtercontroller/meetingfilter.dart';
import '../helper/textview.dart';
import '../lists/filter_model.dart';
import 'package:excel/excel.dart' hide Border;



class TeamLeave extends StatefulWidget {
  const TeamLeave({super.key});
  @override
  State<TeamLeave> createState() => _TeamLeaveState();
}

class _TeamLeaveState extends State<TeamLeave> {
  String? leaveDropdownValue;
  DateTime currentDate = DateTime.now();
  int tabPosition = 0;
  String isSelectedMonth = '';
  bool toDaySelect = true;
  selectedTabPosition(int position) => setState(() {
        // print('check_tab${tabPosition}');
        tabPosition = position;
        isLoading = true;
        userLeaveApplyListData();
      });
  int? selectedIndex;
  bool isLoading = true;

  String isSelectedStatus = '';
  String yearIndexValue = "";
  String monthIndexValue = "";
  String toDaysFilter = "";
  String fromDateValue = "";
  String toDateValue = "";
  List<UserApplyListDatum> userLeaveApplyList = [];



  selectedFilter(int position, String filterType) => setState(() {
        selectedIndex = position;
        toDaysFilter = '';
        if (filterType == 'Today') {
          toDaysFilter =
              "${currentDate.year}-${currentDate.month}-${currentDate.day}";
        }
        isLoading = true;
        userLeaveApplyListData();
      });
  @override
  void initState() {
    isLoading = true;
    userLeaveApplyListData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      EasyLoading.dismiss();
    });
    super.initState();
  }

  Future<void> generateMeetingExcel(List<UserApplyListDatum> userLeaveApplyList) async {
    try {
      // 1. Create a new Excel file
      var excel = Excel.createExcel(); // Creates an empty Excel file
      Sheet sheetObject = excel['Team Leave'];

      // 2. Add headers to the Excel sheet
      List<String> headers = [
        'Office ID',
        'Full Name',
        'Leave Type',
        'From Date',
        'To Date',
        'Leave Apply Date',
        'Leave Apply Time',
        'Status',
        'Reason',
      ];
      sheetObject.appendRow(headers);

      // 3. Add meeting data to the Excel sheet
      for (var leave in userLeaveApplyList) {
        sheetObject.appendRow([
          leave.tblOfficeId,
          leave.fullName,
          leave.leaveType,
          leave.fromDate,
          leave.toDate,
          leave.leaveApplyDate,
          leave.leaveApplyTime,
          leave.status,
          leave.reason,
        ]);
      }


      for (var row in sheetObject.rows) {
        print(row.map((cell) => cell?.value).toList());
      }


      var bytes = excel.save();
      if (bytes == null) {
        throw Exception('Failed to generate Excel file');
      }

      Directory directory = await getApplicationDocumentsDirectory();
      String filePath = '${directory.path}/TeamLeave.xlsx';


      File file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);


      Share.shareXFiles([XFile(filePath)], text: 'Here is the Team Leave Data');

      // Show success message
      print('File saved at $filePath');
    } catch (e) {
      // Handle errors
      print('Error generating Excel file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleSpacing: 0,
        title: Text(
          'Team Leave',
          style: TextStyle(
            fontSize: 16,
            color: ColorConstants.APPTIRLE,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(onPressed: (){
            generateMeetingExcel(userLeaveApplyList);
          }, icon:Icon(Icons.download)).paddingOnly(right: 10),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(alignment: Alignment.topRight           ,
            child: TextButton(
              onPressed: () {
                setState(() {
                  toDaysFilter="";
                  monthIndexValue="";
                  yearIndexValue="";
                  toDateValue="";
                  fromDateValue="";
                  isSelectedStatus="";
                  userLeaveApplyList.clear();
                  userLeaveApplyListData();
                  selectedIndex = null;
                });
              },
              child: const Text(
                'CLEAR ALL',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
            ),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Filters:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(filter.length, (index) {
                        bool isSelected = selectedIndex == index;
                        var data = filter[index];
                        return InkWell(
                          onTap: () => selectedFilter(index, data),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected
                                    ? Colors.black
                                    : Colors.grey.shade400,
                              ),
                              borderRadius: BorderRadius.circular(5),
                              color: isSelected ? Colors.black : Colors.white,
                            ),
                            child: Text(
                              data.toString(),
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey.shade800,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ))
                ],
              ),
            ),
          ),
          if (selectedIndex == 1)
            statusFilter()
          else if (selectedIndex == 2)
            monthFilter()
          else if (selectedIndex == 3)
            dateFilter()
          else if (selectedIndex == 4)
            yearsFilter(),
          addPadding(5, 0),
          Expanded(
            child: userLeaveApplyList.isEmpty
                ? const Center(child: Text('data not found'))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: userLeaveApplyList.length,
                    itemBuilder: (context, index) {
                      var data = userLeaveApplyList[index];
                      return Container(
                        padding: const EdgeInsets.only(
                          left: 5,
                          right: 5,
                          top: 5,
                        ),
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: ColorConstants.WHITECOLOR,
                            boxShadow: const [
                              BoxShadow(
                                  blurRadius: 1,
                                  color: ColorConstants.GREYCOLOR)
                            ],
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          children: [
                            Column(
                              children: data.status == "pending"
                                  ? [
                                      headingText(
                                          title: 'Status',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                      addPadding(30, 0),
                                      headingText(
                                          title: data.status.capitalizeFirst
                                              .toString(),
                                          color: ColorConstants.GREYCOLOR,
                                          fontWeight: FontWeight.bold),
                                    ]
                                  : data.status == "rejected"
                                      ? [
                                          headingText(
                                              title: 'Status',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                          addPadding(30, 0),
                                          headingText(
                                              title: data.status.capitalizeFirst
                                                  .toString(),
                                              color: ColorConstants.REDCOLOR,
                                              fontWeight: FontWeight.bold),
                                        ]
                                      : [
                                          headingText(
                                              title: 'Status',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                          addPadding(30, 0),
                                          headingText(
                                              title: data.status.capitalizeFirst
                                                  .toString(),
                                              color: ColorConstants.GREENCOLOR,
                                              fontWeight: FontWeight.bold),
                                        ],
                            ),
                            Container(
                                margin:
                                    const EdgeInsets.only(left: 10, right: 10),
                                width: 1,
                                //height: double.infinity,
                                color: ColorConstants.DarkMahroon,
                                height: 100),
                            addPadding(0, 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5,top: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        headingText(
                                          fontSize: 16,
                                            title: data.fullName,
                                            fontWeight: FontWeight.w600),
                                        headingText(
                                            title: data.designationAbbr,
                                            fontWeight: FontWeight.w600),
                                      ],
                                    ),
                                  ),
                                  headingText(
                                    fontSize: 16,
                                      title: data.leaveType,
                                      fontWeight: FontWeight.bold,
                                      color: ColorConstants.DarkMahroon),
                                  addPadding(5, 0),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        headingText(
                                            title: data.fromDate,
                                            fontWeight: FontWeight.w500),
                                        headingText(
                                            title: data.toDate,
                                            fontWeight: FontWeight.w500),
                                      ],
                                    ),
                                  ),
                                  addPadding(5, 0),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        headingText(
                                            title: data.leaveApplyDate,
                                            fontWeight: FontWeight.w500),
                                        headingText(
                                            title: data.leaveApplyTime,
                                            fontWeight: FontWeight.w500),
                                      ],
                                    ),
                                  ),
                                  addPadding(5, 0),
                                  headingText(
                                      title: data.reason,
                                      fontWeight: FontWeight.w500),
                                  addPadding(5, 0),
                                  Row(
                                    children: data.status == "approved"
                                        ? []
                                        : data.status == "rejected"
                                            ? []
                                            : [
                                                TextButton(
                                                    onPressed: () {
                                                      initiateLeaveApproveRejectApi(
                                                          'rejected',data.tblOfficeId.toString(),data.tblUserLeaveId,data.tblUserId.toString());
                                                      print("checkkkkkkkk");
                                               //       Navigator.pop(context);
                                                    },
                                                    child: headingText(
                                                        title: 'Reject',
                                                        color: ColorConstants
                                                            .REDCOLOR,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                addPadding(0, 60),
                                                TextButton(
                                                    onPressed: () {
                                                      initiateLeaveApproveRejectApi(
                                                          'approved',
                                                      data.tblOfficeId.toString(),data.tblUserLeaveId.toString(),data.tblUserId.toString());
                                                     // Navigator.pop(context);
                                                    },
                                                    child: headingText(
                                                        title: 'Approve',
                                                        color: ColorConstants
                                                            .GREENCOLOR,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
          ),
        ],
      ),
    );
  }

  initiateLeaveApproveRejectApi(String status, String officeId, String leaveID, String tblUserId,) {
    var hashMap = {
      "tbl_user_id": tblUserId.toString(),
      "tbl_office_id": officeId.toString(),
      "tbl_user_leave_id": leaveID.toString(),
      "leave_approved_reject_by_user_id":
          viewLoginDetail!.data.first.tblUserId.toString(),
      "leave_approved_reject_by_user_type":
          viewLoginDetail!.data.first.designationType.toString(),
      "status": status,
    };
    print('CHECK_APPROVED_REJECTED_API=>$hashMap');
    leaveApproveRejectApi(hashMap).then((onValue) {
      setState(() {
        if (onValue.status) {
          userLeaveApplyList.clear();
          userLeaveApplyListData();
          Fluttertoast.showToast(msg: onValue.message);
        } else {
          print("EXCEPTION=>${onValue.message}");
        }
      });
    });
  }

  statusFilter() => MeetingStatus(
      onTapDownload: () {
        print("CHECK_STATUS_DOWNLOAD");
      },
      statusChanged: (String value) => setState(
            () {
              isSelectedStatus = value;
              isLoading = true;
              userLeaveApplyListData();
            },
          ));
  monthFilter() => MeetingMonth(
        onTapDownload: () {
          print("CHECK_MONTH_DOWNLOAD");
        },
        monthChanged: (String value) {},
        selectedMonthChanged: (String monthIndex) {
          monthIndexValue = monthIndex.toString();
          userLeaveApplyListData();
          monthIndexValue = monthIndex.toString();
          monthIndexValue = monthIndex.toString();
        },
      );
  dateFilter() => MeetingDate(
        onTapDownload: () {
          print("CHECK_DATE_DOWNLOAD");
        },
        fromDateChanged: (String value) {
          fromDateValue = value.toString();
          userLeaveApplyListData();
          print("CHECK_FROM_DATE=>$value");
        },
        toDateChanged: (String value) {
          toDateValue = value.toString();
          userLeaveApplyListData();
          print("CHECK_TO_DATE=>$value");
        },
      );
  todayFilter() => MeetingToday(
        onTapDownload: () {
          print("CHECK_TODAY_DOWNLOAD");
        },
        todayChanged: (String value) {
          userLeaveApplyListData();
          print("CHECK_MEETING_TODAY=>$value");
        },
      );
  yearsFilter() => MeetingYears(
        onTapDownload: () {
          print("CHECK_YEARS_DOWNLOAD");
        },
        yearsChanged: (String value) {
          yearIndexValue = value.toString();
          userLeaveApplyListData();
          print("CHECK_MEETING_YEARS=>$value");
        },
      );
  userLeaveApplyListData() {
    var hasMap = {
      "tbl_user_id": viewLoginDetail!.data.first.tblUserId.toString(),
      "status": isSelectedStatus.toLowerCase(),
      "type": 'team_leave',
      "month_wise": monthIndexValue,
      "year_wise": yearIndexValue,
      "today": toDaysFilter,
      "to_date": toDateValue,
      "from_date": fromDateValue,
    };
    print("LEAVE_APPLY_DATA$hasMap");
    userLeaveApplyListApi(hasMap).then((onValue) {
      setState(() {
        if (onValue.status) {
          isLoading = false;
          UserLeaveApplyListModel model = onValue.data;
          userLeaveApplyList = model.data;
          print('LIST_LENGTH=>${userLeaveApplyList.length}');
        } else {
          userLeaveApplyList.clear();
          isLoading = false;
          print('EXCEPTION=>${onValue.message}');
        }
      });
    });
  }
}
