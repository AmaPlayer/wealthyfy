import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:meeting/helper/colors.dart';
import 'package:meeting/helper/textview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../APIs/Api.dart';
import '../APIs/user_data.dart';
import '../Models/TeamAttendaceModelList.dart';
import '../Models/attendancelist_model.dart';
import '../controller/dashboardcontroller.dart';

class WorkingsheetScreen extends StatefulWidget {
  const WorkingsheetScreen({super.key});

  @override
  State<WorkingsheetScreen> createState() => _WorkingsheetScreenState();
}

class _WorkingsheetScreenState extends State<WorkingsheetScreen> {
  String monthIndexValue = "";
  bool isLoading = true;
  List<DatumAttendance> attendanceList = [];
  List<teamAttDatum> teamAttendanceList = [];
  DashboardController dController = Get.find<DashboardController>();
  final now = DateTime.now();
  ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;
  int page = 1;
  bool hasMoreData = true;
  String userAttandanceStatus="";
  String currentStartDate = "";
  String currentEndDate = "";

  attendanceData(String startDate, String endDate){
    print("AttendanceApiSuccess");
    attendanceApi(startDate,endDate,userAttandanceStatus).then((onValue){
      EasyLoading.dismiss();
      setState(() {
        if(onValue.status){
          isLoading =false;
          AttendanceListModel mu = onValue.data;
          attendanceList = mu.data;


          // List<DatumAttendance> filtered = [];
          // List<teamAttDatum> tFiltered = [];
          //
          //
          //
          // attendanceList.addAll(filtered);
          // teamAttendanceList.addAll(tFiltered);


          print('SUCCESS=>${attendanceList.length}');
        }else{
          print('EXCEPTION=>${onValue.message}');
        }
      });
    });
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    attendanceList.clear();
    teamAttendanceList.clear();
    attendanceData("","");
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 &&
          !isLoadingMore &&
          hasMoreData) {
        isLoadingMore = true;
        page++;
        teamAttendanceData(defaultStartDate, defaultEndDate, pageNumber: page, isPagination: true);
      }
    });

    // Initial API call
    teamAttendanceData("", "");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      EasyLoading.dismiss();
    });
  }
  Future<void> generateAttendanceExcel(List<teamAttDatum> teamAttendanceList) async {
    try {
      // 1. Create a new Excel file
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Team Attendance'];
      // 2. Add headers to the Excel sheet
      List<String> headers = [
        'Employee ID',
        'Full Name',
        'Designation',
        'Date',
        'Check-In Time',
        'Check-Out Time',
        'Working Hour',
        'Late',
        'Status',
      ];
      sheetObject.appendRow(headers);

       // Group by Employee ID to handle missing dates per employee
      Map<String, List<teamAttDatum>> employeeMap = {};
      for (var attendance in teamAttendanceList) {
        if (attendance.empId != null) {
          if (!employeeMap.containsKey(attendance.empId)) {
            employeeMap[attendance.empId] = [];
          }
          employeeMap[attendance.empId]!.add(attendance);
        }
      }

      // Generate full date list
      List<DateTime> dates = [];
      if (currentStartDate.isNotEmpty && currentEndDate.isNotEmpty) {
        DateTime start = DateFormat('yyyy-MM-dd').parse(currentStartDate);
        DateTime end = DateFormat('yyyy-MM-dd').parse(currentEndDate);
        for (int i = 0; i <= end.difference(start).inDays; i++) {
          dates.add(start.add(Duration(days: i)));
        }
      } else {
        // Fallback if dates are missing (should not happen if flow is correct)
         DateTime now = DateTime.now();
         DateTime start = now.subtract(const Duration(days: 30));
         for (int i = 0; i <= now.difference(start).inDays; i++) {
          dates.add(start.add(Duration(days: i)));
        }
      }

      // Iterate through each employee and each date
      for (var empId in employeeMap.keys) {
        var records = employeeMap[empId]!;
        // Use the first record to get static employee details
        var empInfo = records.first; 

        for (var date in dates) {
          String dateStr = DateFormat('yyyy-MM-dd').format(date);
          
          // Find if a record exists for this date
          var record = records.firstWhereOrNull((element) => 
            element.createdDate != null && element.createdDate.toString().contains(dateStr));

          if (record != null) {
             sheetObject.appendRow([
              record.empId ?? 'N/A',
              record.fullName,
              record.designationAbbr ?? 'N/A',
              record.createdDate ?? 'N/A',
              record.checkInTime ?? 'N/A',
              record.checkOutTime ?? 'N/A',
              record.workingTime ?? 'N/A',
              record.isLate ?? 'N/A',
              record.status ?? 'N/A',
            ]);
          } else {
            // Add Absent row
             sheetObject.appendRow([
              empInfo.empId ?? 'N/A',
              empInfo.fullName,
              empInfo.designationAbbr ?? 'N/A',
              dateStr,
              'Absent',
              'Absent',
              '00:00',
              'N/A',
              'Absent',
            ]);
          }
        }
      }

      // DEBUG: Print rows to ensure data is added
      for (var row in sheetObject.rows) {
        print(row.map((cell) => cell?.value).toList());
      }

      // 4. Save the Excel file
      var bytes = excel.save();
      if (bytes == null) {
        throw Exception('Failed to generate Excel file');
      }

      // 5. Get the path to store the file
      Directory directory = await getApplicationDocumentsDirectory();
      String filePath = '${directory.path}/Team Attendance.xlsx';

      // Write the file to disk
      File file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);

      // 6. Share or notify user of the file
      Share.shareXFiles([XFile(filePath)], text: 'Here is the Team Attendance Data');

      // Show success message
      print('File saved at $filePath');
    } catch (e) {
      // Handle errors
      print('Error generating Excel file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ColorConstants.WHITECOLOR,
        appBar: AppBar(
          centerTitle: true,
          title: headingText(title: 'Attendance'),
          bottom: PreferredSize(
              preferredSize: dController.profileData.first.IsMdVpBm == "no"?Size.fromHeight(20):Size.fromHeight(80),
            child: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              tabs:dController.profileData.first.IsMdVpBm == "no"
                  ? [
                 const Text('',style: TextStyle(fontSize: 0),),
                // //Center(child: Tab(text: 'My Attendance',)),
                const Text('',style: TextStyle(fontSize: 0),),
              ] : [
                Tab(text: 'My Attendance',),
                Tab(text: 'My Team Attendance'),
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                IconButton(icon: Icon(Icons.filter_alt_outlined).paddingOnly(right: 0), onPressed: () {
                  _showDateFilterPopup(context);

                },),
                IconButton(icon: Icon(Icons.sort).paddingOnly(right: 10), onPressed: () {
                  _showStatusPopup(context);
                },),
                dController.profileData.first.IsMdVpBm == "no"?SizedBox(): IconButton(
                    onPressed: () {
                      generateAttendanceExcel(teamAttendanceList);
                    },
                    icon: Icon(Icons.download)).paddingOnly(right: 10),
              ],
            )
          ],
        ),
        body: TabBarView(
      children: [
      // My Attendance Widget
        SingleChildScrollView(
          child: Column(
              children: [
                attendanceList.isEmpty?Center(child: Column(crossAxisAlignment: CrossAxisAlignment.center,children:[headingText(title: "No Attendance Found")] )): attendanceUi(),
                addPadding(10, 0),
              ]
          ),
        ),
      // My Team Attendance Widget
        SingleChildScrollView(
          child: Column(
              children: [
                teamAttendanceList.isEmpty?Center(child: headingText(title: "No Attendance Found")): teamAttendanceUi()
              ]
          ),
        ),
      ],
      ),
         ),
    );
  }

  Widget attendanceUi() {
    return
      ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: attendanceList.length,
          itemBuilder: (context, index) {
            var data = attendanceList[index];
            return
              InkWell(
                onTap: () {
                },
                child: Container(
                  //      height: 90,
                  padding:
                  EdgeInsets.only(left: 10, right: 25, top: 10, bottom: 0),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: ColorConstants.GREY2COLOR,
                      boxShadow:  [
                        BoxShadow(blurRadius: 1, color: ColorConstants.GREYCOLOR)
                      ],
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 80,
                            width: 60,
                            decoration: BoxDecoration(
                                color: ColorConstants.WHITECOLOR,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                headingText(
                                    title: data.dayNumber,
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstants.GREY9COLOR),
                                addPadding(10, 0),
                                headingText(
                                    title: data.dayName,
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstants.GREYCOLOR)
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              headingText(
                                  title: 'Check in',
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstants.GREY9COLOR),
                              addPadding(10, 0),
                              headingText(
                                  title: data.checkInTime,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: ColorConstants.GREY7COLOR),
                            ],
                          ),
                          Container(
                            width: 2,
                            height: 40,
                            color: ColorConstants.GREY7COLOR,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              headingText(
                                  title: 'Check out',
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstants.GREY9COLOR),
                              addPadding(10, 0),
                              headingText(
                                  title: data.checkOutTime,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstants.GREY7COLOR),
                            ],
                          ),
                        ],
                      ),
                      addPadding(15, 0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          headingText(
                              title: 'Total Timing', fontWeight: FontWeight.bold),
                          headingText(
                              title: data.workingTime,
                              fontWeight: FontWeight.bold,
                              color: ColorConstants.GREY7COLOR)
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          headingText(
                              title:data.status=="off"?"OFF/HOLIDAY": data.status.toString().toUpperCase(),
                              fontWeight: FontWeight.bold,
                              color: data.status=="absent"?Colors.red:ColorConstants.GREENCOLOR)

                        ],
                      ),
                      addPadding(10, 0),
                      headingText(
                          title: data.createdDate,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.GREY7COLOR),
                      addPadding(10, 0)
                    ],
                  ),
                ),
              );
          }).paddingOnly(bottom: 15);
  }
  Widget teamAttendanceUi() {
    return
        SizedBox(
         // height: 900,
          child: ListView.builder(
            shrinkWrap: true,
           physics: NeverScrollableScrollPhysics(),
              itemCount: teamAttendanceList.length,
              itemBuilder: (context, index) {
                var data = teamAttendanceList[index];
              return
                InkWell(
                  onTap: () {
                  },
                  child: Container(
                    //      height: 90,
                    padding:
                    EdgeInsets.only(left: 10, right: 25, top: 10, bottom: 10),
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: ColorConstants.GREY2COLOR,
                        boxShadow:  [
                          BoxShadow(blurRadius: 1, color: ColorConstants.GREYCOLOR)
                        ],
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 80,
                              width: 60,
                              decoration: BoxDecoration(
                                  color: ColorConstants.WHITECOLOR,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  headingText(
                                      title: data.dayNumber,
                                      fontWeight: FontWeight.bold,
                                      color: ColorConstants.GREY9COLOR),
                                  addPadding(10, 0),
                                  headingText(
                                      title: data.dayName,
                                      fontWeight: FontWeight.bold,
                                      color: ColorConstants.GREYCOLOR)
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                headingText(
                                    title: data.fullName.capitalizeFirst,
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstants.DarkMahroon),
                                addPadding(5, 0),
                                headingText(
                                    title: 'Check in',
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstants.GREY9COLOR),
                                addPadding(10, 0),
                                headingText(
                                    title: data.checkInTime,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: ColorConstants.GREY7COLOR),
                              ],
                            ),
                            Container(
                              width: 2,
                              height: 40,
                              color: ColorConstants.GREY7COLOR,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                headingText(
                                    title: data.designationAbbr,
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstants.GREY9COLOR),
                                addPadding(5, 0),
                                headingText(
                                    title: 'Check out',
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstants.GREY9COLOR),
                                addPadding(10, 0),
                                headingText(
                                    title: data.checkOutTime,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstants.GREY7COLOR),
                              ],
                            ),
                          ],
                        ),
                        addPadding(15, 0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            headingText(
                                title: 'Total Timing', fontWeight: FontWeight.bold),
                            headingText(
                                title: data.workingTime,
                                fontWeight: FontWeight.bold,
                                color: ColorConstants.GREY7COLOR)
                          ],
                        ),
                        addPadding(5, 0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            headingText(
                                title:data.status=="off"?"OFF/HOLIDAY": data.status.toString().toUpperCase(),
                                fontWeight: FontWeight.bold,
                                color: data.status=="absent"?Colors.red:ColorConstants.GREENCOLOR),
                            headingText(
                              fontSize: 16,
                                title:"Late: ${ data.isLate}".toUpperCase(),
                                fontWeight: FontWeight.bold,
                                color:data.isLate=="yes"? ColorConstants.REDCOLOR:ColorConstants.GREYCOLOR),
                          ],
                        ),
                        addPadding(10, 0),
                        headingText(
                            title: data.createdDate,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.BLACKCOLOR),
                        addPadding(5, 0)
                      ],
                    ),
                  ),
                );
            }),
        );
  }

  void _showStatusPopup(BuildContext context) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 10, 10),
      // Adjust position as needed
      items: [
        const PopupMenuItem(
          value: 'off',
          child: Text('Off'),
        ),
        const PopupMenuItem(
          value: 'absent',
          child: Text('Absent'),
        ),
        const PopupMenuItem(
          value: 'present',
          child: Text('Present'),
        ),
        const PopupMenuItem(
          value: 'leave',
          child: Text('Leave'),
        ),
   const PopupMenuItem(
          value: 'early',
          child: Text('Early'),
        ),
      const PopupMenuItem(
          value: 'late',
          child: Text('Late'),
        ),
      ],
    ).then((value) {
      if (value != null) {
        EasyLoading.show();
        attendanceList.clear();
        teamAttendanceList.clear();
        userAttandanceStatus=value;
        teamAttendanceData("","");
        attendanceData("","");
        print("check status $userAttandanceStatus");

      }
    });
  }
  void _showDateFilterPopup(BuildContext context) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 10, 10),
      // Adjust position as needed
      items: [
        const PopupMenuItem(
          value: 'Today',
          child: Text('Today'),
        ),
        const PopupMenuItem(
          value: 'Last week',
          child: Text('Last week'),
        ),
        const PopupMenuItem(
          value: 'Last month',
          child: Text('Last month'),
        ),
        const PopupMenuItem(
          value: 'Last 3 months',
          child: Text('Last 3 months'),
        ),
        const PopupMenuItem(
          value: 'Custom period',
          child: Text('Custom period'),
        ),

      ],
    ).then((value) {
      if (value != null) {
        EasyLoading.show();
        attendanceList.clear();
        teamAttendanceList.clear();
        _handleDateFilterSelection(context, value);
      }
    });
  }

  void _handleDateFilterSelection(BuildContext context, String filter) async {
    DateTimeRange? dateRange;

    switch (filter) {
      case 'Today':
        dateRange = DateTimeRange(start: now, end: now);
        break;
      case 'Last week':
        dateRange = DateTimeRange(
          start: now.subtract(const Duration(days: 7)),
          end: now,
        );
        break;
      case 'Last month':
        dateRange = DateTimeRange(
          start: now.subtract(const Duration(days: 30)),
          end: now,
        );
        break;
      case 'Last 3 months':
        dateRange = DateTimeRange(
          start: now.subtract(const Duration(days: 90)),
          end: now,
        );
        break;
      case 'Custom period':
        dateRange = await _selectCustomDateRange(context);
        break;
    }

    if (dateRange != null) {
      String startDate = DateFormat('yyyy-MM-dd').format(dateRange.start);
      String endDate = DateFormat('yyyy-MM-dd').format(dateRange.end);
      attendanceList.clear();
      attendanceData(startDate,endDate);
      teamAttendanceData(startDate,endDate);
      print("$startDate - $endDate");
      // Use startDate and endDate as needed
    }
  }
  Future<DateTimeRange?> _selectCustomDateRange(BuildContext context) async {
    final now = DateTime.now();
    return showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: now,
      initialDateRange: DateTimeRange(
        start: now.subtract(const Duration(days: 7)),
        end: now,
      ),
    );
  }
  void teamAttendanceData(String startDate, String endDate, {int pageNumber = 1, bool isPagination = false}) {
    final now = DateTime.now();
    DateTimeRange? dateRange;
    dateRange = DateTimeRange(
      start: now.subtract(const Duration(days: 30)),
      end: now,
    );

    defaultStartDate = DateFormat('yyyy-MM-dd').format(dateRange.start);
    defaultEndDate = DateFormat('yyyy-MM-dd').format(dateRange.end);

    var hashMap = {
      "tbl_user_id": viewLoginDetail!.data.first.tblUserId.toString(),
      "from_date": startDate.isEmpty ? defaultStartDate : startDate,
      "to_date": endDate.isEmpty ? defaultEndDate : endDate,
      "status": userAttandanceStatus,
      "pagenumber": pageNumber.toString(),
      "pagesize": "150"

    };
   print("cgwerrrrr $hashMap");
    if (!isPagination) EasyLoading.show(status: "Loading...");

    teamAttendanceUlrApi(hashMap).then((value) {
      if (value.status) {
        setState(() {
          TeamAttendaceModelList model = value.data;
          teamAttendanceList = model.data;
          isLoading = false;
          isLoadingMore = false;
        });
      } else {
        setState(() {
          isLoading = false;
          isLoadingMore = false;
        });
        print('API ERROR: ${value.message}');
      }
    });
  }

}
