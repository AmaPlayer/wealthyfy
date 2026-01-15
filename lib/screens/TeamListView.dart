import 'dart:io';
import 'package:excel/excel.dart' hide Border;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:meeting/helper/textview.dart';
import 'package:meeting/screens/team_meeting.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../APIs/Api.dart';
import '../APIs/user_data.dart';
import '../Models/MyTeamListModel.dart';
import '../Models/teamDesignationListModel.dart';
import '../helper/colors.dart';
import 'my_leave_screen.dart';

class TeamLisView extends StatefulWidget {
  const TeamLisView({super.key});

  @override
  State<TeamLisView> createState() => _TeamLisViewState();
}

class _TeamLisViewState extends State<TeamLisView> {
  DateTime currentDate = DateTime.now();
  int tabPosition = 0;
  String isSelectedMonth = '';
  bool toDaySelect = true;

  selectedTabPosition(int position) => setState(() {
        //print('check_tab${tabPosition}');
        tabPosition = position;
        isLoading = true;
        initiatMyTeamApi("", "", "", "");
      });

  int? selectedIndex;
  bool isLoading = true;
  List<teamDatum> teamList = [];
  List<teamDatum> teamDownlineList = [];
  List<desDatum> desList = [];
  String isSelectedStatus = '';
  String yearIndexValue = "";
  String monthIndexValue = "";
  String toDaysFilter = "";
  String fromDateValue = "";
  String toDateValue = "";
  var downLineID = "";
  var downLineName = "";
  var downLineDes = "";

// Global date variable
  String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  Future<void> generateMeetingExcel(List<teamDatum> teamList) async {
    try {
      CellValue cellValue(Object? value) =>
          TextCellValue(value?.toString() ?? '');

      // 1. Create a new Excel file
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['My Team Data'];

      // 2. Add headers to the Excel sheet
      List<String> headers = [
        'Employee ID',
        'Office ID',
        'Office Name',
        'Designation Type',
        'Designation Name',
        'Full Name',
        'Email',
        'Mobile',
        'Check-In Status',
        'Check-Out Status',
        'User Image',
        'Created Date',
        'Export Date' // Today's Date
      ];
      sheetObject.appendRow(headers.map(cellValue).toList());

      // 3. Add employee data to the Excel sheet
      for (var teamMember in teamList) {
        sheetObject.appendRow([
          teamMember.empId,
          teamMember.tblOfficeId,
          teamMember.officeName,
          teamMember.designationType,
          teamMember.designationName,
          teamMember.fullName,
          teamMember.email,
          teamMember.mobile,
          teamMember.checkInStatus,
          teamMember.checkOutStatus,
          teamMember.userImage,
          teamMember.createdDate,
          todayDate, // Adding today's date
        ].map(cellValue).toList());
      }

      // 4. Save the Excel file
      var bytes = excel.save();
      if (bytes == null) {
        throw Exception('Failed to generate Excel file');
      }

      // 5. Get the path to store the file
      Directory directory = await getApplicationDocumentsDirectory();
      String filePath = '${directory.path}/TeamData_$todayDate.xlsx';
      File file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);

      // 6. Share or notify user of the file
      SharePlus.instance.share(ShareParams(
        files: [XFile(filePath)],
        text: 'Here is the Team Data',
      ));
      print('File saved at $filePath');
    } catch (e) {
      print('Error generating Excel file: $e');
    }
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
        initiatMyTeamApi("", "", "", "");
      });

  @override
  void initState() {
    isLoading = true;
    initiatMyTeamApi("", "", "", "");
    getDesignationList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      EasyLoading.dismiss();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleSpacing: 0,
        title: teamList.isEmpty
            ? Text(
                'My Team',
                style: TextStyle(
                  fontSize: 16,
                  color: ColorConstants.APPTIRLE,
                  fontWeight: FontWeight.bold,
                ),
              )
            : headingText(title: "$downLineName ($downLineDes)".toUpperCase(), fontSize: 16),
        actions: [
          IconButton(
                  onPressed: () {
                    generateMeetingExcel(teamList);
                  },
                  icon: Icon(Icons.download))
              .paddingOnly(right: 10),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          desList.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: Text(
                        'Filters:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: desList.length,
                          itemBuilder: (BuildContext context, int index) {
                            bool isSelected = selectedIndex == index;
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                                initiatMyTeamApi(desList[index].designationAbbr, "", "", "");
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 5, left: 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey),
                                  color: isSelected ? Colors.black : Colors.white,
                                ),
                                child: headingText(
                                  color: isSelected ? Colors.white : Colors.grey.shade800,
                                  title: desList[index].designationName.toUpperCase(),
                                  fontWeight: FontWeight.bold,
                                ).paddingAll(10),
                              ),
                            );
                          },
                        ),
                      ).paddingAll(5),
                    )
                  ],
                ),
          addPadding(5, 10),
          InkWell(
              onTap: () {
                print("check down type$downLineDes");
                if (downLineDes == "SRM") {
                  callGetbackApi("SRM");
                } else if (downLineDes == "BM") {
                  callGetbackApi("BM");
                } else if (downLineDes == "VP") {
                  callGetbackApi("");
                }
              },
              child: headingText(title: "<<Go Back", color: Colors.blue, fontWeight: FontWeight.w700)
                  .paddingOnly(left: 10, right: 10, bottom: 5)),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: ColorConstants.DarkMahroon,
                  ),
                )
              : teamList.isEmpty
                  ? const Center(child: Text('Data not found'))
                  : Expanded(
                      child: ListView.builder(
                          //physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: teamList.length,
                          itemBuilder: (context, index) {
                            var data = teamList[index];
                            return InkWell(
                              onTap: () {
                                if (teamList[index].designationType != "EMP") {
                                  var hasMap = {
                                    "tbl_user_id": teamList[index].tblUserId,
                                  };
                                  fetchMyTeamList(hasMap);
                                }
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
                                    boxShadow: const [BoxShadow(blurRadius: 1, color: ColorConstants.GREYCOLOR)],
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        ClipOval(
                                            child: SizedBox(
                                          height: 55,
                                          width: 55,
                                          child: Image.network(
                                            data.userImage,
                                            fit: BoxFit.cover,
                                          ),
                                        )),
                                        headingText(title: 'Designation', fontWeight: FontWeight.bold, fontSize: 14),
                                        addPadding(0, 0),
                                        headingText(
                                            title: data.designationType.toUpperCase().toString(),
                                            color: ColorConstants.GREENCOLOR,
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
                                            padding: const EdgeInsets.only(right: 5),
                                            child: Row(
                                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                headingText(title: "Name: ", fontWeight: FontWeight.w700, fontSize: 15),
                                                SizedBox(width: 180,child: headingLongText(title: data.fullName.capitalizeFirst,  fontWeight: FontWeight.w600,
                                                    fontSize: 15,)),

                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              headingText(title: "ID: ", fontWeight: FontWeight.w700, fontSize: 15),
                                              headingText(title: data.empId, fontWeight: FontWeight.w500),
                                            ],
                                          ),
                                          addPadding(5, 0),
                                          Row(
                                            children: [
                                              headingText(title: "Email: ", fontWeight: FontWeight.w700, fontSize: 15),
                                              SizedBox(width: 180,child: headingLongText(title: data.email, fontWeight: FontWeight.w500)),
                                            ],
                                          ),
                                          addPadding(5, 0),
                                          Row(
                                            children: [
                                              headingText(title: "Mobile: ", fontWeight: FontWeight.w700, fontSize: 15),
                                              headingText(title: data.mobile, fontWeight: FontWeight.w500),
                                            ],
                                          ),
                                          addPadding(5, 0),
                                          Row(
                                            children: [
                                              headingText(title: "Office: ", fontWeight: FontWeight.w700, fontSize: 15),
                                              headingText(title: data.officeName, fontWeight: FontWeight.w500),
                                            ],
                                          ),
                                          addPadding(0, 50),
                                          Row(
                                            children: [
                                              headingText(
                                                  title: "Joining Date: ", fontWeight: FontWeight.w700, fontSize: 15),
                                              headingText(title: data.createdDate, fontWeight: FontWeight.w500),
                                            ],
                                          ),
                                          addPadding(5, 0),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Get.to(meetingListView(
                                                    userID: data.tblUserId,
                                                    pageFrom: "team",
                                                    meetingOwner: "${data.fullName} (${data.designationType})",
                                                  ));
                                                },
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        border: Border.all(color: Colors.green)),
                                                    child: headingText(
                                                            title: "Meetings",
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 14,
                                                            color: Colors.green)
                                                        .paddingAll(5)),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Get.to(LeaveScreen(
                                                    userID: data.tblUserId,
                                                    pageFrom: "team",
                                                    meetingOwner: "${data.fullName} (${data.designationType})",
                                                  ));
                                                },
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        border: Border.all(color: Colors.red)),
                                                    child: headingText(
                                                            title: "Leaves",
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 14,
                                                            color: Colors.red)
                                                        .paddingAll(5)),
                                              ),
                                            ],
                                          ),
                                          addPadding(10, 0),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
          addPadding(10, 0),
        ],
      ),
    );
  }

  initiatMyTeamApi(String designationAbbr, String teamUserId, String designationType, String Type) {
    if (Type == "downLine") {
      var hasMap = {
        "tbl_user_id": teamUserId,
        // "designation_abbr":designationType,
      };
      print("Meeting_payload=>$hasMap");
      myTeamListApi(hasMap).then((Onvalue) {
        setState(() {
          if (Onvalue.status) {
            MyTeamListModel mode = Onvalue.data;
            downLineID = mode.tblUserId;
            downLineName = mode.myFullName;
            downLineDes = mode.myDesignation;
            teamList = mode.data;
            print("LIST_LENGTH=>${teamList.length}");
            isLoading = false;
          } else {
            teamList.clear();
            print("EXCEPTION=>${Onvalue.message}");
            isLoading = false;
          }
        });
      });
    } else {
      var hasMap = {
        "tbl_user_id": viewLoginDetail!.data.first.tblUserId.toString(),
        "designation_abbr": designationAbbr == "All" ? "" : designationAbbr,
      };
      print("Meeting_payload=>$hasMap");
      myTeamListApi(hasMap).then((Onvalue) {
        setState(() {
          if (Onvalue.status) {
            MyTeamListModel mode = Onvalue.data;
            downLineID = mode.tblUserId;
            downLineName = mode.myFullName;
            downLineDes = mode.myDesignation;
            teamList = mode.data;
            print("LIST_LENGTH=>${teamList.length}");
            isLoading = false;
          } else {
            teamList.clear();
            print("EXCEPTION=>${Onvalue.message}");
            isLoading = false;
          }
        });
      });
    }
  }

  initiatMyTeamsDownlineApi(String tblUserId, String designationType) {
    var hasMap = {
      "tbl_user_id": tblUserId,
      //"designation_abbr":designationAbbr=="All"?"": designationAbbr,
    };
    print("Meeting_payload=>$hasMap");
    myTeamListApi(hasMap).then((Onvalue) {
      setState(() {
        if (Onvalue.status) {
          MyTeamListModel mode = Onvalue.data;
          teamList = mode.data;
          print("LIST_LENGTH=>${teamList.length}");
          isLoading = false;
        } else {
          teamList.clear();
          print("EXCEPTION=>${Onvalue.message}");
          isLoading = false;
        }
      });
    });
  }

  void handleMyTeamListResponse(Onvalue) {
    setState(() {
      isLoading = false; // Stop loading in both success and failure cases

      if (Onvalue.status) {
        MyTeamListModel mode = Onvalue.data;
        downLineID = mode.tblUserId;
        downLineName = mode.myFullName;
        downLineDes = mode.myDesignation;
        teamList = mode.data;
        print("LIST_LENGTH=>${teamList.length}");
      } else {
        teamList.clear();
        print("EXCEPTION=>${Onvalue.message}");
      }
    });
  }

  void fetchMyTeamList(Map<String, dynamic> hasMap) {
    setState(() => isLoading = true); // Start loading
    myTeamListApi(hasMap).then((Onvalue) {
      handleMyTeamListResponse(Onvalue);
    }).catchError((error) {
      setState(() {
        isLoading = false;
        teamList.clear();
      });
      print("API_ERROR=>$error");
    });
  }
  getDesignationList() {
    var hasMap = {
      "tbl_user_id": viewLoginDetail!.data.first.tblUserId.toString(),
    };
    print("des_payload=>$hasMap");
    teamDesignationListUrlApi(hasMap).then((Onvalue) {
      setState(() {
        if (Onvalue.status) {
          TeamDesignationListModel mode = Onvalue.data;
          desList = mode.data;
          print("LIST_LENGTH=>${desList.length}");
          isLoading = false;
        } else {
          desList.clear();
          print("EXCEPTION=>${Onvalue.message}");
          isLoading = false;
        }
      });
    });
  }

  getTeamFilter(String tblDesignationId) {
    var hasMap = {
      "tbl_user_id": viewLoginDetail!.data.first.tblUserId.toString(),
    };
    print("des_payload=>$hasMap");
    teamDesignationListUrlApi(hasMap).then((Onvalue) {
      setState(() {
        if (Onvalue.status) {
          TeamDesignationListModel mode = Onvalue.data;
          desList = mode.data;
          print("LIST_LENGTH=>${desList.length}");
          isLoading = false;
        } else {
          desList.clear();
          print("EXCEPTION=>${Onvalue.message}");
          isLoading = false;
        }
      });
    });
  }
  callGetbackApi(String TYPE) {
    var hasMap = {
      "tbl_user_id": viewLoginDetail!.data.first.tblUserId.toString(),
      "designation_abbr": TYPE,
    };
    print("Meeting_designation_abbr=>$hasMap");
    myTeamListApi(hasMap).then((Onvalue) {
      setState(() {
        if (Onvalue.status) {
          MyTeamListModel mode = Onvalue.data;
          downLineID = mode.tblUserId;
          downLineName = mode.myFullName;
          downLineDes = mode.myDesignation;
          teamList = mode.data;
          if (kDebugMode) {
            print("LIST_LENGTH=>${teamList.length}");
          }
          isLoading = false;
        } else {
          teamList.clear();
          print("EXCEPTION=>${Onvalue.message}");
          isLoading = false;
        }
      });
    });
  }
}
