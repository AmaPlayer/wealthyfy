import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:meeting/APIs/Api.dart';
import 'package:meeting/helper/colors.dart';
import 'package:meeting/helper/imagees.dart';
import 'package:meeting/helper/textview.dart';
import 'package:meeting/screens/my_leave_details.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../APIs/user_data.dart';
import '../Models/userleave_applylist_Model.dart';
import '../controller/filtercontroller/meetingfilter.dart';
import '../lists/filter_model.dart';
import 'apply_leave.dart';

class LeaveScreen extends StatefulWidget {
  final String userID;
  final String pageFrom;
  final String meetingOwner;
   LeaveScreen({super.key,this.userID = "", this.pageFrom = "", this.meetingOwner = ""});
  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  DateTime currentDate = DateTime.now();
  String isSelectedStatus = '';
  String monthIndexValue = '';
  String fromDateValue = '';
  String toDateValue = '';
  String toDaysFilter = '';
  String yearIndexValue = '';
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
  List<UserApplyListDatum> userLeaveApplyList = [];

  userLeaveApplyListData() {
    var hasMap = {
      "tbl_user_id":widget.pageFrom == "team" ? widget.userID : viewLoginDetail!.data.first.tblUserId.toString(),
      "status": isSelectedStatus.toLowerCase(),
      "type": 'my_leave',
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

  @override
  void initState() {
    super.initState();
    userLeaveApplyListData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      EasyLoading.dismiss();
    });
  }

  bool isLoading = true;
  int? selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: headingText(title:widget.pageFrom == "team" ? widget.meetingOwner.capitalizeFirst : 'My Leave'),
        actions: [
          IconButton(onPressed: (){
            generateMeetingExcel(userLeaveApplyList);
          }, icon:Icon(Icons.download)).paddingOnly(right: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: ColorConstants.WHITECOLOR,
                  boxShadow: [
                    BoxShadow(blurRadius: 4, color: Colors.grey.shade300)
                  ],
                  borderRadius: BorderRadius.circular(10)),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        headingText(
                            title: 'Your Leave',
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                        headingText(
                         title: 'History is here !',
                         fontWeight: FontWeight.bold,
                         fontSize: 20),
                      ],
                    ),
                  ),
                  Image.asset(
                    leaveimage,
                    height: 130,
                  )
                ],
              ),
            ),
            addPadding(0, 0),
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
                padding: const EdgeInsets.only(top: 5, bottom: 10),
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
            addPadding(10, 0),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: ColorConstants.DarkMahroon,
                      ),
                    )
                  : userLeaveApplyList.isEmpty
                      ? const Center(child: Text('data not found'))
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: userLeaveApplyList.length,
                          itemBuilder: (context, index) {
                            var data = userLeaveApplyList[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyLeaveDetails(
                                              tbl_leaveid:
                                                  userLeaveApplyList[index]
                                                      .tblUserLeaveId,
                                            )));
                              },
                              child: Container(
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
                                      children: data.status == "approved"
                                          ? [
                                              headingText(
                                                  title: 'Status',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                              addPadding(10, 0),
                                              headingText(
                                                  title: data
                                                      .status.capitalizeFirst
                                                      .toString(),
                                                  color:
                                                      ColorConstants.GREENCOLOR,
                                                  fontWeight: FontWeight.bold),
                                            ]
                                          : data.status == "rejected"
                                              ? [
                                                  headingText(
                                                      title: 'Status',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                  addPadding(10, 0),
                                                  headingText(
                                                      title: data.status
                                                          .capitalizeFirst
                                                          .toString(),
                                                      color: ColorConstants
                                                          .REDCOLOR,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ]
                                              : [
                                                  headingText(
                                                      title: 'Status',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                  addPadding(10, 0),
                                                  headingText(
                                                      title: data.status
                                                          .capitalizeFirst
                                                          .toString(),
                                                      color: ColorConstants
                                                          .GREYCOLOR,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ],
                                    ),
                                    Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        width: 1,
                                        color: ColorConstants.DarkMahroon,
                                        height: 70),
                                    addPadding(0, 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          headingText(
                                              title: data.leaveType,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  ColorConstants.DarkMahroon),
                                          addPadding(5, 0),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                headingText(
                                                    title: data.toDate,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                headingText(
                                                    title: data.fromDate,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ],
                                            ),
                                          ),
                                          addPadding(5, 0),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                headingText(
                                                    title: data.leaveApplyDate,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                addPadding(0, 20),
                                                headingText(
                                                    title: data.leaveApplyTime,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ],
                                            ),
                                          ),
                                          addPadding(5, 0),
                                          headingText(
                                              title: data.reason,
                                              fontWeight: FontWeight.w500),
                                          addPadding(5, 0),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
            ),
          ],
        ),
      ),
      floatingActionButton: CircleAvatar(
        child: FloatingActionButton(
          backgroundColor: ColorConstants.DarkMahroon,
          child: const Icon(
            Icons.add,
            color: ColorConstants.WHITECOLOR,
          ),
          onPressed: () {
            Get.to(ApplyLeave());
          },
        ),
      ),
    );
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
      print('File saved at $filePath');
    } catch (e) {
      print('Error generating Excel file: $e');
    }
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
              print('CHECK_STATUS=>$value');
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
          print('CHECK_MONTH=>$monthIndex');
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
}
