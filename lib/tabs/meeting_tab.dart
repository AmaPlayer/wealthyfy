import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:meeting/controller/HomeTabController.dart';
import 'package:meeting/helper/ErrorBottomSheet.dart';
import 'package:meeting/helper/colors.dart';
import 'package:meeting/controller/button_controller/custombuttom.dart';
import 'package:meeting/helper/textview.dart';
import 'package:meeting/screens/notification_sreen.dart';
import 'package:meeting/screens/meeting_minutes_screen.dart';

class MeetingTab extends GetView<HomeTabController> {
  const MeetingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(()=>PopScope(
      canPop: false,
      onPopInvokedWithResult: (value, other){
        if (controller.dController.selectedIndex.value != 0) {
          controller.dController.selectedIndex.value = 0; // Navigate to the first tab// Prevent exiting the app
        }
        //Allow the default back button behavior
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: headingText(title: 'Meetings'),
            bottom: TabBar(
              onTap: (index) {
                if (index == 1) {
                  controller.refreshIncompleteMeetings();
                }
              },
              tabs: const [
                Tab(text: 'Create'),
                Tab(text: 'Incomplete'),
              ],
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Get.to(NotificationSreen());
                  },
                  icon: const Icon(Icons.notifications_active)),
            ],
          ),
          body: TabBarView(
            children: [
              _createMeetingTab(context),
              _incompleteMeetingsTab(),
            ],
          ),
        ),
      ),
    ));
  }

  void showTimeSlotDialog({
    required BuildContext context,
    required RxList<String> slots,
    required RxString selectedStartTime,
    required RxString selectedEndTime,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Select Time Slot'),
        content: SizedBox(
          width: double.maxFinite,
          child: Obx(() => ListView.builder(
            shrinkWrap: true,
            itemCount: slots.length,
            itemBuilder: (context, index) {
              final slot = slots[index];
              final parts = slot.split(' - ');
              final isSelected = (parts[0] == selectedStartTime.value && parts[1] == selectedEndTime.value);

              return GestureDetector(
                onTap: () {
                  Get.back();
                  selectedStartTime.value = parts[0];
                  selectedEndTime.value = parts[1];
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isSelected ? Colors.blue.shade100 : Colors.white,
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey.shade300,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(slot, style: const TextStyle(fontSize: 16)),
                      if (isSelected) const Icon(Icons.check_circle, color: Colors.blue),
                    ],
                  ),
                ),
              );
            },
          )),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  products1() => Stack(children: [
        Container(
          margin: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          height: 10,
          decoration: const BoxDecoration(
              color: ColorConstants.GREENCOLOR,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20))),
          width: double.infinity,
        ),
        Container(
          margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
          height: 10,
          decoration: const BoxDecoration(
              color: ColorConstants.DarkMahroon,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20))),
          width: double.infinity,
        ),
        Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
                color: ColorConstants.WHITECOLOR,
                border: const Border(
                    left: BorderSide(color: ColorConstants.DarkMahroon),
                    right: BorderSide(color: ColorConstants.DarkMahroon),
                    bottom: BorderSide(color: ColorConstants.DarkMahroon)),
                boxShadow: const [
                  BoxShadow(blurRadius: 1, color: ColorConstants.GREYCOLOR)
                ],
            borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                TextFormField(
                  controller: controller.pmsController,
                  keyboardType: TextInputType.name,
                  style: const TextStyle(
                  color: ColorConstants.BLACKCOLOR,
                  decorationColor: ColorConstants.WHITECOLOR),
                  cursorColor: ColorConstants.DarkMahroon,
                  decoration: InputDecoration(
                    labelText: 'PMS:',
                    labelStyle: const TextStyle(
                        fontSize: 14, color: ColorConstants.GREYCOLOR),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: ColorConstants.WHITECOLOR),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: ColorConstants.DarkMahroon,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 12.0),
                    isDense: true,
                  ),
                ),
                addPadding(10, 0),
                TextFormField(
                  controller: controller.reference1controller,
                  keyboardType: TextInputType.name,
                  style: const TextStyle(
                      color: ColorConstants.BLACKCOLOR,
                      decorationColor: ColorConstants.WHITECOLOR),
                  cursorColor: ColorConstants.DarkMahroon,
                  decoration: InputDecoration(
                    labelText: 'Reference: 1',
                    labelStyle: const TextStyle(
                        fontSize: 14, color: ColorConstants.GREYCOLOR),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: ColorConstants.WHITECOLOR),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: ColorConstants.DarkMahroon,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 12.0),
                    isDense: true,
                  ),
                ),
                addPadding(10, 0),
                TextFormField(
                  controller: controller.reference2controller,
                  style: const TextStyle(
                      color: ColorConstants.BLACKCOLOR,
                      decorationColor: ColorConstants.WHITECOLOR),
                  cursorColor: ColorConstants.DarkMahroon,
                  decoration: InputDecoration(
                    labelText: 'Reference: 2',
                    labelStyle: const TextStyle(
                        fontSize: 14, color: ColorConstants.GREYCOLOR),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: ColorConstants.WHITECOLOR),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: ColorConstants.DarkMahroon,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 12.0),
                    isDense: true,
                  ),
                ),
                addPadding(10, 0),
              ],
            )),
      ]);

  products2() => Stack(children: [
        Container(
          margin: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          height: 10,
          decoration: const BoxDecoration(
              color: ColorConstants.GREENCOLOR,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20))),
          width: double.infinity,
        ),
        Container(
          margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
          height: 10,
          decoration: const BoxDecoration(
              color: ColorConstants.DarkMahroon,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20))),
          width: double.infinity,
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              border: const Border(
                  left: BorderSide(color: ColorConstants.DarkMahroon),
                  right: BorderSide(color: ColorConstants.DarkMahroon),
                  bottom: BorderSide(color: ColorConstants.DarkMahroon)),
              boxShadow: const [
                BoxShadow(blurRadius: 1, color: ColorConstants.GREYCOLOR)
              ],
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: ColorConstants.GREYCOLOR),
                ),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    headingText(
                      title: 'Mutual Fund Portfolio',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: ColorConstants.GREYCOLOR,
                    ),
                    Row(
                      children: [
                        // Yes
                        GestureDetector(
                          onTap: controller.toggleMutualFund,
                          child: Container(
                            alignment: Alignment.center,
                            height: 23,
                            width: 22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                width: 2,
                                color: controller.mutualFundSelected.value
                                    ? ColorConstants.GREYCOLOR
                                    : ColorConstants.GREENCOLOR,
                              ),
                            ),
                            child: headingText(
                              title: "Y",
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: controller.mutualFundSelected.value
                                  ? ColorConstants.GREYCOLOR
                                  : ColorConstants.GREENCOLOR,
                            ),
                          ),
                        ),
                        addPadding(0, 20),
                        // No
                        GestureDetector(
                          onTap: controller.toggleMutualFund,
                          child: Container(
                            alignment: Alignment.center,
                            height: 23,
                            width: 22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                width: 2,
                                color: !controller.mutualFundSelected.value
                                    ? ColorConstants.GREYCOLOR
                                    : ColorConstants.REDCOLOR,
                              ),
                            ),
                            child: headingText(
                                title: "N",
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: !controller.mutualFundSelected.value
                                    ? ColorConstants.GREYCOLOR
                                    : ColorConstants.REDCOLOR,
                                align: TextAlign.center),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: ColorConstants.GREYCOLOR),
                ),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    headingText(
                      title: 'Fixed Deposit',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: ColorConstants.GREYCOLOR,
                    ),
                    Row(
                      children: [
                        // Yes
                        GestureDetector(
                          onTap: controller.toggleFixedDeposit,
                          child: Container(
                            alignment: Alignment.center,
                            height: 23,
                            width: 22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                width: 2,
                                color: controller.fixedDepositSelected.value
                                    ? ColorConstants.GREYCOLOR
                                    : ColorConstants.GREENCOLOR,
                              ),
                            ),
                            child: Center(
                                child: headingText(
                              title: "Y",
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: controller.fixedDepositSelected.value
                                  ? ColorConstants.GREYCOLOR
                                  : ColorConstants.GREENCOLOR,
                            )),
                          ),
                        ),
                        addPadding(0, 20),
                        // No
                        GestureDetector(
                          onTap: controller.toggleFixedDeposit,
                          child: Container(
                            alignment: Alignment.center,
                            height: 23,
                            width: 22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                width: 2,
                                color: !controller.fixedDepositSelected.value
                                    ? ColorConstants.GREYCOLOR
                                    : ColorConstants.REDCOLOR,
                              ),
                            ),
                            child: headingText(
                              title: "N",
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: !controller.fixedDepositSelected.value
                                  ? ColorConstants.GREYCOLOR
                                  : ColorConstants.REDCOLOR,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: ColorConstants.GREYCOLOR),
                ),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    headingText(
                      title: 'Loan Details: Home/Personal',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: ColorConstants.GREYCOLOR,
                    ),
                    Row(
                      children: [
                        // Yes
                        GestureDetector(
                          onTap: controller.toggleLoan,
                          child: Container(
                            alignment: Alignment.center,
                            height: 23,
                            width: 22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                width: 2,
                                color: controller.loanSelected.value
                                    ? ColorConstants.GREYCOLOR
                                    : ColorConstants.GREENCOLOR,
                              ),
                            ),
                            child: headingText(
                              title: "H",
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: controller.loanSelected.value
                                  ? ColorConstants.GREYCOLOR
                                  : ColorConstants.GREENCOLOR,
                            ),
                          ),
                        ),
                        addPadding(0, 20),
                        // No
                        GestureDetector(
                          onTap: controller.toggleLoan,
                          child: Container(
                            alignment: Alignment.center,
                            height: 23,
                            width: 22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                width: 2,
                                color: !controller.loanSelected.value
                                    ? ColorConstants.GREYCOLOR
                                    : ColorConstants.GREENCOLOR,
                              ),
                            ),
                            child: headingText(
                              title: "P",
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: !controller.loanSelected.value
                                  ? ColorConstants.GREYCOLOR
                                  : ColorConstants.GREENCOLOR,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: ColorConstants.GREYCOLOR),
                ),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    headingText(
                      title: 'Insurance:Health/Life',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: ColorConstants.GREYCOLOR,
                    ),
                    Row(
                      children: [
                        // Yes
                        GestureDetector(
                          onTap: controller.toggleInsurance,
                          child: Container(
                            alignment: Alignment.center,
                            height: 23,
                            width: 22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                width: 2,
                                color: controller.insuranceSelected.value
                                    ? ColorConstants.GREYCOLOR
                                    : ColorConstants.GREENCOLOR,
                              ),
                            ),
                            child: headingText(
                              title: "H",
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: controller.insuranceSelected.value
                                  ? ColorConstants.GREYCOLOR
                                  : ColorConstants.GREENCOLOR,
                            ),
                          ),
                        ),
                        addPadding(0, 20),
                        //No
                        GestureDetector(
                          onTap: controller.toggleInsurance,
                          child: Container(
                            alignment: Alignment.center,
                            height: 23,
                            width: 22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                width: 2,
                                color: !controller.insuranceSelected.value
                                    ? ColorConstants.GREYCOLOR
                                    : ColorConstants.GREENCOLOR,
                              ),
                            ),
                            child: headingText(
                              title: "L",
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: !controller.insuranceSelected.value
                                  ? ColorConstants.GREYCOLOR
                                  : ColorConstants.GREENCOLOR,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              addPadding(10, 0),
              TextFormField(
                controller: controller.remarkController,
                maxLines: 4,
                cursorColor: ColorConstants.GREYCOLOR,
                decoration: InputDecoration(
                  labelText: 'Remark',
                  labelStyle: const TextStyle(
                      fontSize: 18, color: ColorConstants.GREYCOLOR),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: ColorConstants.DarkMahroon,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ]);

  _customerinformation1(BuildContext context) => Obx(()=> Stack(children: [
    Container(
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      height: 10,
      decoration: const BoxDecoration(
          color: ColorConstants.GREENCOLOR,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20))),
      width: double.infinity,
    ),
    Container(
      margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
      height: 10,
      decoration: const BoxDecoration(
          color: ColorConstants.DarkMahroon,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20))),
      width: double.infinity,
    ),
    Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
            color: ColorConstants.WHITECOLOR,
            border: const Border(
                left: BorderSide(color: ColorConstants.DarkMahroon),
                right: BorderSide(color: ColorConstants.DarkMahroon),
                bottom: BorderSide(color: ColorConstants.DarkMahroon)),
            boxShadow: const [
              BoxShadow(blurRadius: 1, color: ColorConstants.GREYCOLOR)
            ],
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            TextFormField(
              controller: controller.customerIdController,
              keyboardType: TextInputType.name,
              style: const TextStyle(
                  color: ColorConstants.BLACKCOLOR,
                  decorationColor: ColorConstants.WHITECOLOR),
              cursorColor: ColorConstants.DarkMahroon,
              decoration: InputDecoration(
                labelText: 'Customer ID',
                labelStyle: const TextStyle(
                    fontSize: 14, color: ColorConstants.GREYCOLOR),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                  const BorderSide(color: ColorConstants.WHITECOLOR),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: ColorConstants.DarkMahroon,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 12.0),
                isDense: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
            ),
            addPadding(10, 0),
            TextFormField(
              controller: controller.clientNameController,
              keyboardType: TextInputType.name,
              style: const TextStyle(
                  color: ColorConstants.BLACKCOLOR,
                  decorationColor: ColorConstants.WHITECOLOR),
              cursorColor: ColorConstants.DarkMahroon,
              decoration: InputDecoration(
                labelText: 'Client Name',
                labelStyle: const TextStyle(
                    fontSize: 14, color: ColorConstants.GREYCOLOR),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                  const BorderSide(color: ColorConstants.WHITECOLOR),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: ColorConstants.DarkMahroon,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 12.0),
                isDense: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
            ),
            addPadding(10, 0),
            TextFormField(
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress, // Set keyboard for email
              style: const TextStyle(
                  color: ColorConstants.BLACKCOLOR,
                  decorationColor: ColorConstants.WHITECOLOR),
              cursorColor: ColorConstants.DarkMahroon,
              decoration: InputDecoration(
                labelText: 'Email Address',
                labelStyle: const TextStyle(
                    fontSize: 14, color: ColorConstants.GREYCOLOR),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: ColorConstants.WHITECOLOR),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: ColorConstants.DarkMahroon,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 12.0),
                isDense: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                if (!emailRegex.hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),

            addPadding(10, 0),
            TextFormField(
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10)
              ],
              controller: controller.mobileNumberController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                  color: ColorConstants.BLACKCOLOR,
                  decorationColor: ColorConstants.WHITECOLOR),
              cursorColor: ColorConstants.DarkMahroon,
              decoration: InputDecoration(
                labelText: 'Mobile No:',
                labelStyle: const TextStyle(
                    fontSize: 14, color: ColorConstants.GREYCOLOR),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                  const BorderSide(color: ColorConstants.WHITECOLOR),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: ColorConstants.DarkMahroon,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 12.0),
                isDense: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid mobile number';
                }
                if (value.length != 10) {
                  return 'Mobile number must be 10 digits';
                }
                return null;
              },
            ),
            addPadding(10, 0),
            TextFormField(
              controller: controller.selectLocationController,
              onTap: () async {
                controller.getLocation();
              },
              readOnly: true,
              keyboardType: TextInputType.none,
              decoration: InputDecoration(
                  hintText: controller.selectedLocation.isEmpty
                      ? 'Select Location'
                      : controller.selectedLocation.value,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  border: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: ColorConstants.GREY5COLOR),
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: ColorConstants.DarkMahroon))),
            ),
            addPadding(10, 0),
            ElevatedButton(
              onPressed: () {
                showTimeSlotDialog(
                  context: context,
                  slots: controller.timeSlots,
                  selectedStartTime: controller.selectedStartTime,
                  selectedEndTime: controller.selectedEndTime,
                );
              },
              child: const Text("Pick Slot"),
            )

          ],
        )),
  ]));


  _customerinformation2() => Stack(children: [
        Container(
          margin: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          height: 10,
          decoration: const BoxDecoration(
              color: ColorConstants.GREENCOLOR,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20))),
          width: double.infinity,
        ),
        Container(
          margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
          height: 10,
          decoration: const BoxDecoration(
              color: ColorConstants.DarkMahroon,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20))),
          width: double.infinity,
        ),
        Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
                color: ColorConstants.WHITECOLOR,
                border: const Border(
                    left: BorderSide(color: ColorConstants.DarkMahroon),
                    right: BorderSide(color: ColorConstants.DarkMahroon),
                    bottom: BorderSide(color: ColorConstants.DarkMahroon)),
                boxShadow: const [
                  BoxShadow(blurRadius: 1, color: ColorConstants.GREYCOLOR)
                ],
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                TextFormField(
                  controller: controller.familyDetailsController,
                  keyboardType: TextInputType.name,
                  style: const TextStyle(
                      color: ColorConstants.BLACKCOLOR,
                      decorationColor: ColorConstants.WHITECOLOR),
                  cursorColor: ColorConstants.DarkMahroon,
                  decoration: InputDecoration(
                    labelText: 'Family Details:',
                    labelStyle: const TextStyle(
                        fontSize: 14, color: ColorConstants.GREYCOLOR),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: ColorConstants.WHITECOLOR),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: ColorConstants.DarkMahroon,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 12.0),
                    isDense: true,
                  ),
                ),
                addPadding(10, 0),
                TextFormField(
                  controller: controller.stockPortfolioController,
                  keyboardType: TextInputType.name,
                  style: const TextStyle(
                      color: ColorConstants.BLACKCOLOR,
                      decorationColor: ColorConstants.WHITECOLOR),
                  cursorColor: ColorConstants.DarkMahroon,
                  decoration: InputDecoration(
                    labelText: 'Stock Portfolio with us:',
                    labelStyle: const TextStyle(
                        fontSize: 14, color: ColorConstants.GREYCOLOR),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: ColorConstants.WHITECOLOR),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: ColorConstants.DarkMahroon,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 12.0),
                    isDense: true,
                  ),
                ),
                addPadding(10, 0),
                TextFormField(
                  controller: controller.stockPortfolioOtherController,
                  keyboardType: TextInputType.name,
                  style: const TextStyle(
                      color: ColorConstants.BLACKCOLOR,
                      decorationColor: ColorConstants.WHITECOLOR),
                  cursorColor: ColorConstants.DarkMahroon,
                  decoration: InputDecoration(
                    labelText: 'Stock Portfolio with other Broker:',
                    labelStyle: const TextStyle(
                        fontSize: 14, color: ColorConstants.GREYCOLOR),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: ColorConstants.WHITECOLOR),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: ColorConstants.DarkMahroon,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 12.0),
                    isDense: true,
                  ),
                ),
              ],
            )),
      ]);

  Widget _createMeetingTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: controller.formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addPadding(15, 0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ColorConstants.GREY4COLOR,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ColorConstants.GREYCOLOR),
                ),
                child: headingFullText(
                  title: "Note: Please allow location permission as 'always allow' before check-in to ensure meeting approval.",
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.BLACKCOLOR,
                ),
              ),
              addPadding(10, 0),
              headingText(
                title: 'Customer Information',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ColorConstants.BLACKCOLOR,
              ),
              addPadding(15, 0),
              _customerinformation1(context),
              addPadding(15, 0),
              _customerinformation2(),
              addPadding(15, 0),
              headingText(
                title: 'products',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ColorConstants.BLACKCOLOR,
              ),
              addPadding(15, 0),
              products1(),
              addPadding(15, 0),
              products2(),
              addPadding(15, 0),
              Row(
                children: [
                  InkWell(
                    onTap: controller.containerselect,
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: controller.isSelected.value
                                  ? ColorConstants.GREENCOLOR
                                  : ColorConstants.GREYCOLOR),
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                          child: InkWell(
                              onTap: controller.containerselect,
                              child: Icon(
                                Icons.check,
                                size: 20,
                                color: controller.isSelected.value
                                    ? ColorConstants.GREENCOLOR
                                    : ColorConstants.WHITECOLOR,
                              ))),
                    ),
                  ),
                  Flexible(
                      child: headingFullText(
                        title: 'Disclaimer: I have checked the ledger'
                            ' details and answer of transactions shown',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.BLACKCOLOR,
                      )),
                ],
              ),
              addPadding(15, 0),
              Center(
                child: Obx(() => CustomButton(
                      text: controller.isCreateMeetingLoading.value ? 'Submitting...' : 'Submit',
                      onPressed: controller.isCreateMeetingLoading.value
                          ? () {}
                          : () {
                              if (controller.formkey.currentState!.validate() && controller.isSelected.value) {
                                if (controller.selectedStartTime.toString() != "") {
                                  controller.initiateCreateMeetingData();
                                } else {
                                  showErrorBottomSheet("Please select slot");
                                }
                              }
                            },
                      width: 150,
                      color: controller.isSelected.value
                          ? ColorConstants.DarkMahroon
                          : ColorConstants.GREYCOLOR,
                      textStyle: const TextStyle(color: Colors.white, fontSize: 16),
                    )),
              ),
              addPadding(15, 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _incompleteMeetingsTab() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
      child: Obx(() {
        if (controller.isIncompleteMeetingLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.incompleteMeetingList.isEmpty) {
          return Center(
            child: headingText(
              title: 'No incomplete meetings found.',
              color: ColorConstants.GREYCOLOR,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.incompleteMeetingList.length,
          itemBuilder: (context, index) {
            final meeting = controller.incompleteMeetingList[index];
            final hasCheckedOut = meeting.meetingCheckOutStatus == "yes";
            final hasCheckedIn = meeting.meetingCheckInStatus == "yes";

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColorConstants.WHITECOLOR,
                border: Border.all(color: ColorConstants.DarkMahroon),
                boxShadow: const [BoxShadow(blurRadius: 1, color: ColorConstants.GREYCOLOR)],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headingText(
                    title: meeting.clientName,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.BLACKCOLOR,
                  ),
                  addPadding(5, 0),
                  headingText(
                    title: '${meeting.meetingDate}  ${meeting.meetingTime}',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: ColorConstants.GREYCOLOR,
                  ),
                  addPadding(10, 0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 110,
                      height: 40,
                      child: hasCheckedOut
                          ? CustomButton(
                              text: 'Complete',
                              onPressed: () {
                                Get.to(MeetingMinutesScreen(
                                  tblMeetingId: meeting.tblMeetingId,
                                  meetingDate: meeting.meetingDate,
                                  initialMinutes: meeting.meetingMinutes,
                                ));
                              },
                              color: ColorConstants.DarkMahroon,
                              textStyle: const TextStyle(color: Colors.white, fontSize: 14),
                            )
                          : CustomButton(
                              text: 'Check Out',
                              onPressed: () {
                                if (!hasCheckedIn) {
                                  showErrorBottomSheet("Please check in before check out.");
                                  return;
                                }
                                controller.initiateMeetingCheckOutData(meeting.tblMeetingId);
                              },
                              color: ColorConstants.REDCOLOR,
                              textStyle: const TextStyle(color: Colors.white, fontSize: 14),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
