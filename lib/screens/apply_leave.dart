import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthyfy/APIs/Api.dart';
import 'package:wealthyfy/APIs/user_data.dart';
import 'package:wealthyfy/helper/ErrorBottomSheet.dart';
import 'package:wealthyfy/helper/colors.dart';
import 'package:wealthyfy/controller/button_controller/custombuttom.dart';
import 'package:wealthyfy/helper/imagees.dart';
import 'package:wealthyfy/helper/textview.dart';
import '../Models/leavetype_model.dart';
import '../helper/from_and_to_date_selection_screen.dart';

class ApplyLeave extends StatefulWidget {
  const ApplyLeave({super.key});

  @override
  State<ApplyLeave> createState() => _ApplyLeaveState();
}

class _ApplyLeaveState extends State<ApplyLeave> {
  List<LeaveDatum> leaveModel = <LeaveDatum>[];
  TextEditingController reasonController = TextEditingController();
  LeaveTypeModel? leaveTypeModel;
  String fromDate = '';
  String toDate = '';
  bool isLoading = true;
  TextEditingController fromdatecontroller = TextEditingController();
  TextEditingController todatecontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    leaveTypeData();
    fromdatecontroller.clear();
    todatecontroller.clear();
  }

  DateTime currentDate = DateTime.now();

  String? leaveDropdownValue;

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.WHITECOLOR,
      appBar: AppBar(
        centerTitle: true,
        title: headingText(title: 'Apply Leave'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      headingText(
                          title: 'Apply for Leave',
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                      Image.asset(
                        loginimage,
                        height: 100,
                      )
                    ],
                  ),
                ),
                addPadding(15, 0),
                _dateField(),
                addPadding(15, 0),
                headingText(
                    title: 'Leave Type',
                    color: ColorConstants.DarkMahroon,
                    fontWeight: FontWeight.bold,
                    fontSize: 19),
                addPadding(15, 0),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: ColorConstants.GREY5COLOR),
                      color: ColorConstants.WHITECOLOR,
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15.0,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: headingText(
                              title: "Select Leave Type",
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: ColorConstants.GREY7COLOR),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 20),
                        child: SizedBox(
                          height: 35,
                          child: DropdownButton(
                            borderRadius: BorderRadius.circular(5),
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              size: 16,
                            ),
                            dropdownColor: ColorConstants.WHITECOLOR,
                            isExpanded: true,
                            value: leaveDropdownValue,
                            items: leaveModel.map((e) {
                              return DropdownMenuItem(
                                value: e.leaveType.toString(),
                                child: headingText(
                                    title: e.leaveType, fontSize: 15),
                              );
                            }).toList(),
                            onChanged: (Object? value) {
                              setState(() {
                                leaveDropdownValue = value.toString();
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                addPadding(20, 0),
                Container(
                  margin: const EdgeInsets.only(bottom: 80),
                  child: TextFormField(
                    controller: reasonController,
                    cursorColor: ColorConstants.DarkMahroon,
                    maxLines: 5,
                    decoration: const InputDecoration(
                        labelText: 'Enter Reason',
                        border: OutlineInputBorder()),

                  ),
                ),
                // addPadding(80, 0),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: CustomButton(
            text: 'SUBMIT ',
            onPressed: () {
              if (_formkey.currentState!.validate()) {
                initiatUserLeaveApply();

              }
            }),
      ),
    );
  }

  initiatUserLeaveApply() {
    var hashMap = {
      "tbl_user_id": viewLoginDetail!.data.first.tblUserId.toString(),
      "tbl_office_id": viewLoginDetail!.data.first.tblOfficeId.toString(),
      "leave_type": leaveDropdownValue.toString(),
      "from_date": fromdatecontroller.text,
      "to_date": todatecontroller.text,
      "reason": reasonController.text
    };
    print("SUBMIT_APPLY_MAP=>$hashMap");

    userLeaveApplyApi(hashMap).then((val) {
      print("CHECK_API     ${val.status}");

      setState(() {
        // Just update the UI state here if needed
      });

      if (val.status) {
        Get.back();
        showSuccessBottomSheet(val.message);

      } else {
        showErrorBottomSheet(val.message);
        print('EXCEPTION=>${val.message}');
      }
    });
  }


  leaveTypeData() {
    leaveTypeApi().then((onValue) {
      setState(() {
        if (onValue.status) {
          LeaveTypeModel model = onValue.data;
          List<LeaveDatum> modellist = model.data;
          leaveModel = modellist;
        } else {
          print(onValue.message);
        }
      });
    });
  }
  _dateField() => FromAndToDateSelectionScreen(
        dateManager: (DateType value) {
          if(value.type==DateTypeEnum.from){
            fromdatecontroller.text=value.date;
            print("check this what is this${fromdatecontroller.text}");
          }else{
            todatecontroller.text=value.date;
            print("check this what is this${todatecontroller.text}");
          }
          print("check this what is this${value.date} ${value.type}");
        },
  );
}
