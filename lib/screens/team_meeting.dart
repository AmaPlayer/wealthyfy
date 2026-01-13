import 'dart:io';

import 'package:excel/excel.dart' hide Border;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:meeting/APIs/Api.dart';
import 'package:meeting/APIs/user_data.dart';
import 'package:meeting/Models/usermeeting_List_model.dart';
import 'package:meeting/controller/filtercontroller/meetingfilter.dart';
import 'package:meeting/helper/colors.dart';
import 'package:meeting/screens/teammeeting_detail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../controller/dashboardcontroller.dart';
import '../helper/textview.dart';
import '../lists/filter_model.dart';

class meetingListView extends StatefulWidget {
  final String userID;
  final String pageFrom;
  final String meetingOwner;

  meetingListView({super.key, this.userID = "", this.pageFrom = "", this.meetingOwner = ""});

  @override
  State<meetingListView> createState() => _meetingListViewState();
}

class _meetingListViewState extends State<meetingListView> {
  DateTime currentDate = DateTime.now();
  int tabPosition = 0;
  String isSelectedMonth = '';
  bool toDaySelect = true;
  DashboardController dController = Get.find<DashboardController>();
  selectedTabPosition(int position) => setState(() {
        // print('check_tab${tabPosition}');
        tabPosition = position;
        isLoading = true;
        initiatMeetingApi();
      });

  int? selectedIndex;
  bool isLoading = true;
  List<MeetingDatum> meetingList = [];
  String isSelectedStatus = '';
  String yearIndexValue = "";
  String monthIndexValue = "";
  String toDaysFilter = "";
  String fromDateValue = "";
  String toDateValue = "";

  Future<void> generateMeetingExcel(List<MeetingDatum> meetingList) async {
    try {
      // 1. Create a new Excel file
      var excel = Excel.createExcel(); // Creates an empty Excel file
      Sheet sheetObject = excel['Meeting Data'];

      // 2. Add headers to the Excel sheet
      List<String> headers = [
        'Meeting ID',
        'User ID',
        'Employee ID',
        'Full Name',
        'Designation',
        'Office ID',
        'Client ID',
        'Client Name',
        'Email',
        'Mobile',
        'City',
        'State',
        'Country',
        'Full Address',
        'Family Details',
        'Stock Portfolio With Us',
        'Stock Portfolio With Other Broker',
        'Mutual Fund Portfolio',
        'Fixed Deposit',
        'Loan Details',
        'Insurance',
        'PMS',
        'NCD',
        'Reference 1',
        'Reference 2',
        'Remark',
        'Meeting Status',
        'Approved/Rejected By',
        'Approver Type',
        'Approval Date',
        'Check-In DateTime',
        'Check-In Address',
        'Meeting Slot From',
        'Meeting Slot To',
        'Meeting Date',
        'Meeting Time',
        'Check-In Status',
      ];
      sheetObject.appendRow(headers);

// Add data rows
      for (var meeting in meetingList) {
        sheetObject.appendRow([
          meeting.tblMeetingId,
          meeting.tblUserId,
          meeting.empId,
          meeting.fullName,
          meeting.designationAbbr,
          meeting.tblOfficeId,
          meeting.clientId,
          meeting.clientName,
          meeting.clientEmail,
          meeting.clientMobile,
          meeting.city,
          meeting.state,
          meeting.country,
          meeting.fullAddress,
          meeting.familyDetails,
          meeting.stockPortfolioWithUs,
          meeting.stockPortfolioWithOtherBroker,
          meeting.mutualFundPortfolio,
          meeting.fixedDeposite,
          meeting.loanDetails,
          meeting.insurance,
          meeting.pms,
          meeting.ncd,
          meeting.reference1,
          meeting.reference2,
          meeting.remark,
          meeting.meetingStatus,
          meeting.approvedRejectByUserName,
          meeting.approvedRejectByUserType,
          meeting.approvedRejectByUserDate,
          meeting.meetingCheckInDateTime,
          meeting.meetingCheckInFullAddress,
          meeting.meetingTimeSlotFrom,
          meeting.meetingTimeSlotTo,
          meeting.meetingDate,
          meeting.meetingTime,
          meeting.meetingCheckInStatus,
        ]);
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
      String filePath = '${directory.path}/MeetingData.xlsx';

      // Write the file to disk
      File file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);

      // 6. Share or notify user of the file
      Share.shareXFiles([XFile(filePath)], text: 'Here is the Meeting Data');

      // Show success message
      print('File saved at $filePath');
    } catch (e) {
      // Handle errors
      print('Error generating Excel file: $e');
    }
  }

  initiatMeetingApi() {
    var hasMap = {
      "tbl_user_id": widget.pageFrom == "team" ? widget.userID : viewLoginDetail!.data.first.tblUserId.toString(),
      "status": isSelectedStatus.toLowerCase(),
      "type": widget.pageFrom == "team"
          ? "my_meeting"
          : tabPosition == 0
              ? "my_meeting"
              : "children",
      "month_wise": monthIndexValue,
      "year_wise": yearIndexValue,
      "today": toDaysFilter,
      "to_date": toDateValue,
      "from_date": fromDateValue,
    };
    print("Meeting_payload=>$hasMap");
    createMeetingListApi(hasMap).then((Onvalue) {
      setState(() {
        if (Onvalue.status) {
          UserMeetingListModel mode = Onvalue.data;
          meetingList = mode.data;
          print("LIST_LENGTH=>${meetingList.length}");
          isLoading = false;
        } else {
          meetingList.clear();
          print("EXCEPTION=>${Onvalue.message}");
          isLoading = false;
        }
      });
    });
  }

  selectedFilter(int position, String filterType) => setState(() {
        selectedIndex = position;
        toDaysFilter = '';
        if (filterType == 'Today') {
          toDaysFilter = "${currentDate.year}-${currentDate.month}-${currentDate.day}";
        }
        if (filterType == 'Status') {
          isSelectedStatus = 'Pending';
        }
        isLoading = true;
        initiatMeetingApi();
      });

  @override
  void initState() {
    isLoading = true;
    initiatMeetingApi();
    super.initState();
    print(widget.pageFrom);
    print(widget.meetingOwner);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      EasyLoading.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleSpacing: 0,
        title: dController.profileData.first.IsMdVpBm == "no"
            ? Text(
                'My Meeting',
                style: TextStyle(
                  fontSize: 16,
                  color: ColorConstants.APPTIRLE,
                  fontWeight: FontWeight.bold,
                ),
              )
            : widget.pageFrom == "team"
                ? Text(
                    widget.meetingOwner.capitalizeFirst.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorConstants.APPTIRLE,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(
                    'Meeting List',
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorConstants.APPTIRLE,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
        actions: [
          IconButton(
                  onPressed: () {
                    generateMeetingExcel(meetingList);
                  },
                  icon: Icon(Icons.download))
              .paddingOnly(right: 10),
        ],
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: SizedBox(
              height: 35,
              width: 100,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    toDaysFilter = "";
                    monthIndexValue = "";
                    yearIndexValue = "";
                    toDateValue = "";
                    fromDateValue = "";
                    isSelectedStatus = "";
                    meetingList.clear();
                    initiatMeetingApi();
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
          ),
          Expanded(
            child: SizedBox(
              child: DefaultTabController(
                length:  2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          // color: Colors.grey.shade100,
                          ),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 0),
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
                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: isSelected ? Colors.black : Colors.grey.shade400,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                        color: isSelected ? Colors.black : Colors.white,
                                      ),
                                      child: Text(
                                        data.toString(),
                                        style: TextStyle(
                                          color: isSelected ? Colors.white : Colors.grey.shade800,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
                    TabBar(
                        labelPadding: dController.profileData.first.IsMdVpBm == "no"
                            ? EdgeInsets.only(top: 0, right: 0, bottom: 0)
                            : EdgeInsets.only(top: 10, right: 20, bottom: 5),
                        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                        unselectedLabelColor: Colors.grey,
                        dividerColor: Colors.white,
                        indicatorColor: ColorConstants.DarkMahroon,
                        labelColor: ColorConstants.DarkMahroon,
                        onTap: (int position) => selectedTabPosition(position),
                        tabs: dController.profileData.first.IsMdVpBm == "no"
                            ? [
                                const Text(''),
                                const Text(''),
                              ]
                            : widget.pageFrom == "team"
                                ? [
                                    const Text(''),
                                    const Text(''),
                                  ]
                                : [
                                    const Text('My Meeting'),
                                    const Text('Team Meeting'),
                                  ]),
                    addPadding(0, 0),
                    Expanded(
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: ColorConstants.DarkMahroon,
                                ),
                              )
                            : meetingList.isEmpty
                                ? const Center(child: Text('Data not found'))
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: meetingList.length,
                                    itemBuilder: (context, index) {
                                      var data = meetingList[index];
                                      return InkWell(
                                        onTap: () {
                                          Get.to(PersonDetail(
                                            tbl_meetingID: meetingList[index].tblMeetingId,
                                            tabPosition:widget.pageFrom=="team"?1: tabPosition,
                                          ))?.then((onValue){
                                            initiatMeetingApi();
                                          });

                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            left: 5,
                                            right: 5,
                                            top: 5,
                                          ),
                                          margin: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: ColorConstants.WHITECOLOR,
                                              boxShadow: const [
                                                BoxShadow(blurRadius: 1, color: ColorConstants.GREYCOLOR)
                                              ],
                                              borderRadius: BorderRadius.circular(5)),
                                          child: Row(
                                            children: [
                                              Column(
                                                children: data.meetingStatus == "approved"
                                                    ? [
                                                        headingText(
                                                            title: 'Status', fontWeight: FontWeight.bold, fontSize: 14),
                                                        addPadding(10, 0),
                                                        headingText(
                                                            title: data.meetingStatus.capitalizeFirst.toString(),
                                                            color: ColorConstants.GREENCOLOR,
                                                            fontWeight: FontWeight.bold),
                                                      ]
                                                    : data.meetingStatus == "rejected"
                                                        ? [
                                                            headingText(
                                                                title: 'Status',
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 14),
                                                            addPadding(10, 0),
                                                            headingText(
                                                                title: data.meetingStatus.capitalizeFirst.toString(),
                                                                color: ColorConstants.REDCOLOR,
                                                                fontWeight: FontWeight.bold),
                                                          ]
                                                        : [
                                                            headingText(
                                                                title: 'Status',
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 14),
                                                            addPadding(10, 0),
                                                            headingText(
                                                                title: data.meetingStatus.capitalizeFirst.toString(),
                                                                color: ColorConstants.GREYCOLOR,
                                                                fontWeight: FontWeight.bold),
                                                          ],
                                              ),
                                              Container(
                                                  margin: const EdgeInsets.only(left: 10, right: 5),
                                                  width: 1,
                                                  color: ColorConstants.DarkMahroon,
                                                  height: 80),
                                              addPadding(0, 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(right: 5,top: 5),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          headingText(
                                                              title: "${data.fullName} (${data.designationAbbr})",
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 16,
                                                              color: ColorConstants.BLACKCOLOR),

                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(right: 5,top: 5),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          headingText(
                                                              title: data.clientName,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 15,
                                                              color: ColorConstants.DarkMahroon),

                                                        ],
                                                      ),
                                                    ),

                                                    addPadding(5, 0),
                                                    headingText(
                                                      title: data.clientEmail,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    addPadding(5, 0),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        headingText(
                                                            title: data.clientMobile, fontWeight: FontWeight.w500),
                                                        headingText(
                                                            title: "${data.city} ${data.state}",
                                                            fontWeight: FontWeight.w500),
                                                      ],
                                                    ),
                                                    addPadding(5, 0),
                                                    Row(
                                                      children: [
                                                        headingText(
                                                            title: data.meetingTime, fontWeight: FontWeight.w500),
                                                        headingText(
                                                            title: data.meetingDate, fontWeight: FontWeight.w500),
                                                      ],
                                                    ),
                                                    addPadding(5, 0),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    })),
                    addPadding(10, 0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  statusFilter() => MeetingStatus(
      onTapDownload: () {
        print("CHECK_STATUS_DOWNLOAD");
      },
      statusChanged: (String value) => setState(
            () {
              isSelectedStatus = value;
              isLoading = true;

              initiatMeetingApi();
            },
          ));

  monthFilter() => MeetingMonth(
        onTapDownload: () {},
        monthChanged: (String value) {},
        selectedMonthChanged: (String monthIndex) {
          monthIndexValue = monthIndex.toString();
          initiatMeetingApi();
        },
      );

  dateFilter() => MeetingDate(
        onTapDownload: () {
          print("CHECK_DATE_DOWNLOAD");
        },
        fromDateChanged: (String value) {
          fromDateValue = value.toString();
          initiatMeetingApi();
          print("CHECK_FROM_DATE=>$value");
        },
        toDateChanged: (String value) {
          toDateValue = value.toString();
          initiatMeetingApi();
          print("CHECK_TO_DATE=>$value");
        },
      );

  todayFilter() => MeetingToday(
        onTapDownload: () {
          print("CHECK_TODAY_DOWNLOAD");
        },
        todayChanged: (String value) {
          initiatMeetingApi();
          print("CHECK_MEETING_TODAY=>$value");
        },
      );

  yearsFilter() => MeetingYears(
        onTapDownload: () {
          print("CHECK_YEARS_DOWNLOAD");
        },
        yearsChanged: (String value) {
          yearIndexValue = value.toString();
          initiatMeetingApi();
          print("CHECK_MEETING_YEARS=>$value");
        },
      );
}
