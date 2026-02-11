
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:wealthyfy/helper/ErrorBottomSheet.dart';
import 'package:wealthyfy/helper/textview.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../APIs/Api.dart';
import '../APIs/user_data.dart';
import '../Models/usermeeting_details_model.dart';
import '../controller/button_controller/custombuttom.dart';
import '../controller/HomeTabController.dart';
import '../helper/colors.dart';
import 'bottom_screen.dart';


class EditMeetingDetailsScreen extends StatefulWidget {
  final dynamic tbl_meetingid;
  final List<MeetingDetailDatum> userMeetingDetailslist;

  EditMeetingDetailsScreen({
    super.key,
    required this.userMeetingDetailslist,
    this.tbl_meetingid,
  });

  @override
  State<EditMeetingDetailsScreen> createState() =>
      _EditMeetingDetailsScreenState();
}

class _EditMeetingDetailsScreenState extends State<EditMeetingDetailsScreen> {
  String selectedLocation = "";

  bool _mutualFundSelected = false;
  bool _fixedDepositSelected = false;
  bool _loanSelected = false;
  bool _insuranceSelected = false;

  void toggleMutualFund() {
    setState(() {
      _mutualFundSelected = !_mutualFundSelected;
    });
  }

  void _toggleFixedDeposit() {
    setState(() {
      _fixedDepositSelected = !_fixedDepositSelected;
    });
  }

  void _toggleLoan() {
    setState(() {
      _loanSelected = !_loanSelected;
    });
  }

  void _toggleInsurance() {
    setState(() {
      _insuranceSelected = !_insuranceSelected;
    });
  }

  TextEditingController customerIdController = TextEditingController();
  TextEditingController clientNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController longController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController selectLocationController = TextEditingController();
  TextEditingController familyDetailsController = TextEditingController();
  TextEditingController stockPortfolioController = TextEditingController();
  TextEditingController stockportfoliothercontroller = TextEditingController();
  TextEditingController pmsController = TextEditingController();
  TextEditingController reference1controller = TextEditingController();
  TextEditingController reference2controller = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController meetingDateController = TextEditingController();
  TextEditingController meetingTimeFromController = TextEditingController();
  TextEditingController meetingTimeToController = TextEditingController();

  @override
  void initState() {
    super.initState();
    customerIdController.text = widget.userMeetingDetailslist.first.clientId;
    clientNameController.text = widget.userMeetingDetailslist.first.clientName;
    cityController.text = widget.userMeetingDetailslist.first.city;
    emailController.text = widget.userMeetingDetailslist.first.clientEmail;
    mobileNumberController.text =
        widget.userMeetingDetailslist.first.clientMobile;
    selectLocationController.text =
        widget.userMeetingDetailslist.first.fullAddress;
    familyDetailsController.text =
        widget.userMeetingDetailslist.first.familyDetails;
    stockPortfolioController.text =
        widget.userMeetingDetailslist.first.stockPortfolioWithUs;
    stockportfoliothercontroller.text =
        widget.userMeetingDetailslist.first.stockPortfolioWithOtherBroker;
    reference1controller.text = widget.userMeetingDetailslist.first.reference1;
    reference2controller.text = widget.userMeetingDetailslist.first.reference2;
    pmsController.text = widget.userMeetingDetailslist.first.pms;
    remarkController.text = widget.userMeetingDetailslist.first.remark;
    meetingDateController.text = widget.userMeetingDetailslist.first.meetingDate;
    meetingTimeFromController.text = widget.userMeetingDetailslist.first.meetingTimeSlotFrom;
    meetingTimeToController.text = widget.userMeetingDetailslist.first.meetingTimeSlotTo;
    _mutualFundSelected =
        widget.userMeetingDetailslist.first.mutualFundPortfolio == "no"
            ? true
            : false;
    _fixedDepositSelected =
        widget.userMeetingDetailslist.first.fixedDeposite == "no"
            ? true
            : false;
    _loanSelected =
        widget.userMeetingDetailslist.first.loanDetails == "personal"
            ? true
            : false;
    _insuranceSelected =
        widget.userMeetingDetailslist.first.insurance == "life" ? true : false;
  }

  bool _isSelected = false;

  Future<void> _pickMeetingDate() async {
    DateTime initialDate;
    try {
      initialDate = DateFormat("dd-MM-yyyy").parse(meetingDateController.text, true);
    } catch (_) {
      initialDate = DateTime.now();
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      meetingDateController.text = DateFormat("dd-MM-yyyy").format(picked);
    }
  }

  Future<void> _pickMeetingTime(TextEditingController controller) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final dt = DateTime(0, 1, 1, picked.hour, picked.minute);
      controller.text = DateFormat("hh:mm a").format(dt);
    }
  }

  void containerselect() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: headingText(title: 'Edit Meeting '),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 8,
          right: 8,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: widget.userMeetingDetailslist.isEmpty
                ? CircularProgressIndicator()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      addPadding(15, 0),
                      headingText(
                        title: 'Customer Information',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.BLACKCOLOR,
                      ),
                      addPadding(15, 0),
                      _customerinformation1(),
                      addPadding(15, 0),
                      Visibility(
                        visible: widget.userMeetingDetailslist.first.meetingCheckInStatus=="yes",
                        child: Column(children: [_customerinformation2(),
                          addPadding(15, 0),
                          addPadding(15, 0),
                          products1(),
                          addPadding(15, 0),
                          products2(),],),
                      ),
                      addPadding(15, 0),
                      _meetingScheduleSection(),
                      addPadding(15, 0),
                      Row(
                        children: [
                          InkWell(
                            onTap: containerselect,
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: _isSelected
                                          ? ColorConstants.GREENCOLOR
                                          : ColorConstants.GREYCOLOR),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                  child: InkWell(
                                      onTap: containerselect,
                                      child: Icon(
                                        Icons.check,
                                        size: 20,
                                        color: _isSelected
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
                        child: CustomButton(
                          text: 'Submit',
                          onPressed: () {
                            if (_formkey.currentState!.validate() &&
                                _isSelected) {
                              initiateUpdateMeetingData();

                            }
                          },
                          width: 150,
                          color: _isSelected
                              ? ColorConstants.DarkMahroon
                              : ColorConstants.GREYCOLOR,
                        ),
                      ),
                      addPadding(15, 0),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  _customerinformation1() => Stack(children: [
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
            padding: EdgeInsets.all(10),
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
                  controller: customerIdController,
                  keyboardType: TextInputType.name,
                  style: const TextStyle(
                      color: ColorConstants.BLACKCOLOR,
                      decorationColor: ColorConstants.WHITECOLOR),
                  cursorColor: ColorConstants.DarkMahroon,
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(),
                    labelText: 'Customer ID',
                    labelStyle: const TextStyle(
                        fontSize: 14, color: ColorConstants.GREYCOLOR),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: ColorConstants.WHITECOLOR),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: ColorConstants.DarkMahroon,
                      ),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
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
                  controller: clientNameController,
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
                      borderSide: BorderSide(color: ColorConstants.WHITECOLOR),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: ColorConstants.DarkMahroon,
                      ),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
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
                  controller: emailController,
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
                  controller: mobileNumberController,
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
                      borderSide: BorderSide(color: ColorConstants.WHITECOLOR),
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
                  controller: selectLocationController,
                  onTap: () async {
                    Prediction? prediction = await PlacesAutocomplete.show(
                      context: context,
                      apiKey: kGoogleApiKey,
                      mode: Mode.fullscreen,
                      // Fullscreen search
                      language: "en",
                      components: [
                        Component(Component.country, "in")
                      ], // Limit to India
                    );

                    if (prediction != null) {
                      await fetchPlaceDetails(prediction.placeId!);
                      selectLocationController.text = userFullAddress!;
                    }
                  },
                  readOnly: true,
                  keyboardType: TextInputType.none,
                  decoration: InputDecoration(
                      hintText: selectedLocation.isEmpty
                          ? 'Select Location'
                          : selectedLocation,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ColorConstants.GREY5COLOR),
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: ColorConstants.DarkMahroon))),
                ),
                addPadding(10, 0),
              ],
            )),
      ]);

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
                  controller: familyDetailsController,
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                addPadding(10, 0),
                TextFormField(
                  controller: stockPortfolioController,
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                addPadding(10, 0),
                TextFormField(
                  controller: stockportfoliothercontroller,
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
              ],
            )),
      ]);

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
            padding: EdgeInsets.all(10),
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
                  controller: pmsController,
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
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
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
                  controller: reference1controller,
                  keyboardType: TextInputType.name,
                  style: const TextStyle(
                      color: ColorConstants.BLACKCOLOR,
                      decorationColor: ColorConstants.WHITECOLOR),
                  cursorColor: ColorConstants.DarkMahroon,
                  decoration: InputDecoration(
                    labelText: 'Reference: 1',
                    labelStyle: const TextStyle(
                        fontSize: 14, color: ColorConstants.BLACKCOLOR),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: ColorConstants.WHITECOLOR),
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
                  controller: reference2controller,
                  style: const TextStyle(
                      color: ColorConstants.BLACKCOLOR,
                      decorationColor: ColorConstants.WHITECOLOR),
                  cursorColor: ColorConstants.DarkMahroon,
                  decoration: InputDecoration(
                    labelText: 'Reference: 2',
                    labelStyle: const TextStyle(
                        fontSize: 14, color: ColorConstants.BLACKCOLOR),
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
                margin: EdgeInsets.only(bottom: 10),
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
                          onTap: toggleMutualFund,
                          child: Container(
                            alignment: Alignment.center,
                            height: 23,
                            width: 22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                width: 2,
                                color: _mutualFundSelected
                                    ? ColorConstants.GREYCOLOR
                                    : ColorConstants.GREENCOLOR,
                              ),
                            ),
                            child: headingText(
                              title: "Y",
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: _mutualFundSelected
                                  ? ColorConstants.GREYCOLOR
                                  : ColorConstants.GREENCOLOR,
                            ),
                          ),
                        ),
                        addPadding(0, 20),
                        // No
                        GestureDetector(
                          onTap: toggleMutualFund,
                          child: Container(
                            alignment: Alignment.center,
                            height: 23,
                            width: 22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                width: 2,
                                color: !_mutualFundSelected
                                    ? ColorConstants.GREYCOLOR
                                    : ColorConstants.REDCOLOR,
                              ),
                            ),
                            child: headingText(
                                title: "N",
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: !_mutualFundSelected
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
                          onTap: _toggleFixedDeposit,
                          child: Container(
                            alignment: Alignment.center,
                            height: 23,
                            width: 22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                width: 2,
                                color: _fixedDepositSelected
                                    ? ColorConstants.GREYCOLOR
                                    : ColorConstants.GREENCOLOR,
                              ),
                            ),
                            child: Center(
                                child: headingText(
                              title: "Y",
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: _fixedDepositSelected
                                  ? ColorConstants.GREYCOLOR
                                  : ColorConstants.GREENCOLOR,
                            )),
                          ),
                        ),
                        addPadding(0, 20),
                        // No
                        GestureDetector(
                          onTap: _toggleFixedDeposit,
                          child: Container(
                            alignment: Alignment.center,
                            height: 23,
                            width: 22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                width: 2,
                                color: !_fixedDepositSelected
                                    ? ColorConstants.GREYCOLOR
                                    : ColorConstants.REDCOLOR,
                              ),
                            ),
                            child: headingText(
                              title: "N",
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: !_fixedDepositSelected
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
                margin: EdgeInsets.only(bottom: 10),
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
                          onTap: _toggleLoan,
                          child: Container(
                            alignment: Alignment.center,
                            height: 23,
                            width: 22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                width: 2,
                                color: _loanSelected
                                    ? ColorConstants.GREYCOLOR
                                    : ColorConstants.GREENCOLOR,
                              ),
                            ),
                            child: headingText(
                              title: "H",
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: _loanSelected
                                  ? ColorConstants.GREYCOLOR
                                  : ColorConstants.GREENCOLOR,
                            ),
                          ),
                        ),
                        addPadding(0, 20),
                        // No
                        GestureDetector(
                          onTap: _toggleLoan,
                          child: Container(
                            alignment: Alignment.center,
                            height: 23,
                            width: 22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                width: 2,
                                color: !_loanSelected
                                    ? ColorConstants.GREYCOLOR
                                    : ColorConstants.GREENCOLOR,
                              ),
                            ),
                            child: headingText(
                              title: "P",
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: !_loanSelected
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
                          onTap: _toggleInsurance,
                          child: Container(
                            alignment: Alignment.center,
                            height: 23,
                            width: 22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                width: 2,
                                color: _insuranceSelected
                                    ? ColorConstants.GREYCOLOR
                                    : ColorConstants.GREENCOLOR,
                              ),
                            ),
                            child: headingText(
                              title: "H",
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: _insuranceSelected
                                  ? ColorConstants.GREYCOLOR
                                  : ColorConstants.GREENCOLOR,
                            ),
                          ),
                        ),
                        addPadding(0, 20),
                        //No
                        GestureDetector(
                          onTap: _toggleInsurance,
                          child: Container(
                            alignment: Alignment.center,
                            height: 23,
                            width: 22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                width: 2,
                                color: !_insuranceSelected
                                    ? ColorConstants.GREYCOLOR
                                    : ColorConstants.GREENCOLOR,
                              ),
                            ),
                            child: headingText(
                              title: "L",
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: !_insuranceSelected
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
            ],
          ),
        ),
      ]);

  _meetingScheduleSection() => Stack(children: [
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
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: meetingDateController,
                      readOnly: true,
                      onTap: _pickMeetingDate,
                      decoration: InputDecoration(
                        labelText: 'Meeting Date',
                        labelStyle: TextStyle(fontSize: 14, color: ColorConstants.GREYCOLOR),
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: ColorConstants.DarkMahroon),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              addPadding(10, 0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: meetingTimeFromController,
                      readOnly: true,
                      onTap: () => _pickMeetingTime(meetingTimeFromController),
                      decoration: InputDecoration(
                        labelText: 'Meeting Time From',
                        labelStyle: TextStyle(fontSize: 14, color: ColorConstants.GREYCOLOR),
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: ColorConstants.DarkMahroon),
                        ),
                      ),
                    ),
                  ),
                  addPadding(0, 10),
                  Expanded(
                    child: TextFormField(
                      controller: meetingTimeToController,
                      readOnly: true,
                      onTap: () => _pickMeetingTime(meetingTimeToController),
                      decoration: InputDecoration(
                        labelText: 'Meeting Time To',
                        labelStyle: TextStyle(fontSize: 14, color: ColorConstants.GREYCOLOR),
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: ColorConstants.DarkMahroon),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              addPadding(10, 0),
              TextFormField(
                controller: remarkController,
                maxLines: 4,
                cursorColor: ColorConstants.GREYCOLOR,
                decoration: InputDecoration(
                  labelText: 'Remark',
                  labelStyle:
                      TextStyle(fontSize: 18, color: ColorConstants.GREYCOLOR),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: ColorConstants.DarkMahroon,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
              )
            ],
          ),
        ),
      ]);

  initiateUpdateMeetingData() {
    final meetingDate = meetingDateController.text.trim();
    final meetingTimeFrom = meetingTimeFromController.text.trim();
    final meetingTimeTo = meetingTimeToController.text.trim();
    final meetingTime = _buildMeetingTime(meetingTimeFrom, meetingTimeTo);
    var hashMap = {
      "tbl_user_id": viewLoginDetail!.data.first.tblUserId.toString(),
      "tbl_meeting_id": widget.tbl_meetingid,
      "client_id": customerIdController.text.trim(),
      "client_name": clientNameController.text.trim(),
      "client_email": emailController.text.trim(),
      "client_mobile": mobileNumberController.text.trim(),
      "city": userCity ?? cityController.text,
      "state": userState ?? widget.userMeetingDetailslist.first.city,
      "country": "india",
      "meeting_latitude": userLat ?? widget.userMeetingDetailslist.first.meetingLatitude,
      "meeting_longitude": userLng ?? widget.userMeetingDetailslist.first.meetingLongitude,
      "mutual_fund_portfolio": _mutualFundSelected ? "no" : "yes",
      "fixed_deposite": _fixedDepositSelected ? "no" : "yes",
      "loan_details": _loanSelected ? "personal" : "home",
      "insurance": _insuranceSelected ? "life" : "health",
      "ncd": "no",
      "family_details": familyDetailsController.text.trim(),
      "stock_portfolio_with_us": stockPortfolioController.text.trim(),
      "stock_portfolio_with_other_broker":
          stockportfoliothercontroller.text.trim(),
      "pms": pmsController.text.trim(),
      "reference_1": reference1controller.text.trim(),
      "reference_2": reference2controller.text.trim(),
      "remark": remarkController.text.trim(),
      "full_address": selectLocationController.text,
      "is_meeting_complete": widget.userMeetingDetailslist.first.meetingCheckInStatus.toString(),
      "meeting_time_slot_from": meetingTimeFrom,
      "meeting_time_slot_to": meetingTimeTo,
      "meeting_time": meetingTime,
      "meeting_date": _formatMeetingDate(meetingDate),
    };
    print("update_meeting_api=>$hashMap");
    updateMeetingApi(hashMap).then((onValue) {
      print("update_meeting=>$onValue");
      setState(() {
        if (onValue.status) {
         showSuccessBottomSheet(onValue.message);
         final homeController = Get.isRegistered<HomeTabController>()
             ? Get.find<HomeTabController>()
             : null;
         homeController?.getUpcomingMeetingData();
         Navigator.push(
             context,
             MaterialPageRoute(
                 builder: (context) => MyBottomBar()));
          //Fluttertoast.showToast(msg: onValue.message);
        } else {
          showErrorBottomSheet(onValue.message);
          print("EXCEPTION=>${onValue.message}");
        }
      });
    });
  }

  String _buildMeetingTime(String from, String to) {
    if (from.isEmpty && to.isEmpty) {
      return "";
    }
    if (from.isEmpty) {
      return to;
    }
    if (to.isEmpty) {
      return from;
    }
    return "$from - $to";
  }

  String _formatMeetingDate(String value) {
    try {
      final parsed = DateFormat("dd-MM-yyyy").parseStrict(value);
      return DateFormat("yyyy-MM-dd").format(parsed);
    } catch (_) {
      return value;
    }
  }
}
