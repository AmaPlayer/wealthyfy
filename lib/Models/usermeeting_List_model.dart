// To parse this JSON data, do
//
//     final userMeetingListModel = userMeetingListModelFromJson(jsonString);

import 'dart:convert';

UserMeetingListModel userMeetingListModelFromJson(String str) => UserMeetingListModel.fromJson(json.decode(str));

String userMeetingListModelToJson(UserMeetingListModel data) => json.encode(data.toJson());

class UserMeetingListModel {
  bool status;
  String message;
  List<MeetingDatum> data;

  UserMeetingListModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UserMeetingListModel.fromJson(Map<String, dynamic> json) => UserMeetingListModel(
    status: json["status"],
    message: json["message"],
    data: List<MeetingDatum>.from(json["data"].map((x) => MeetingDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class MeetingDatum {
  String tblMeetingId;
  int tblUserId;
  dynamic empId;
  dynamic fullName;
  dynamic designationAbbr;
  int tblOfficeId;
  String clientId;
  String clientName;
  String clientEmail;
  String clientMobile;
  String city;
  String state;
  String country;
  String fullAddress;
  String familyDetails;
  String stockPortfolioWithUs;
  String stockPortfolioWithOtherBroker;
  dynamic mutualFundPortfolio;
  dynamic fixedDeposite;
  String loanDetails;
  String insurance;
  String pms;
  dynamic ncd;
  String reference1;
  String reference2;
  String remark;
  String meetingStatus;
  String approvedRejectByUserName;
  String approvedRejectByUserType;
  String approvedRejectByUserDate;
  String meetingCheckInDateTime;
  String meetingCheckInFullAddress;
  String meetingTimeSlotFrom;
  String meetingTimeSlotTo;
  String meetingDate;
  String meetingTime;
  String meetingCheckInStatus;
  String meetingCheckOutStatus;
  String meetingCheckOutDateTime;
  String meetingCheckOutFullAddress;
  String meetingMinutes;

  MeetingDatum({
    required this.tblMeetingId,
    required this.tblUserId,
    required this.empId,
    required this.fullName,
    required this.designationAbbr,
    required this.tblOfficeId,
    required this.clientId,
    required this.clientName,
    required this.clientEmail,
    required this.clientMobile,
    required this.city,
    required this.state,
    required this.country,
    required this.fullAddress,
    required this.familyDetails,
    required this.stockPortfolioWithUs,
    required this.stockPortfolioWithOtherBroker,
    required this.mutualFundPortfolio,
    required this.fixedDeposite,
    required this.loanDetails,
    required this.insurance,
    required this.pms,
    required this.ncd,
    required this.reference1,
    required this.reference2,
    required this.remark,
    required this.meetingStatus,
    required this.approvedRejectByUserName,
    required this.approvedRejectByUserType,
    required this.approvedRejectByUserDate,
    required this.meetingCheckInDateTime,
    required this.meetingCheckInFullAddress,
    required this.meetingTimeSlotFrom,
    required this.meetingTimeSlotTo,
    required this.meetingDate,
    required this.meetingTime,
    required this.meetingCheckInStatus,
    required this.meetingCheckOutStatus,
    required this.meetingCheckOutDateTime,
    required this.meetingCheckOutFullAddress,
    required this.meetingMinutes,
  });

  factory MeetingDatum.fromJson(Map<String, dynamic> json) => MeetingDatum(
    tblMeetingId: json["tbl_meeting_id"],
    tblUserId: json["tbl_user_id"],
    empId: json["emp_id"],
    fullName: json["full_name"],
    designationAbbr: json["designation_abbr"],
    tblOfficeId: json["tbl_office_id"],
    clientId: json["client_id"],
    clientName: json["client_name"],
    clientEmail: json["client_email"],
    clientMobile: json["client_mobile"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    fullAddress: json["full_address"],
    familyDetails: json["family_details"],
    stockPortfolioWithUs: json["stock_portfolio_with_us"],
    stockPortfolioWithOtherBroker: json["stock_portfolio_with_other_broker"],
    mutualFundPortfolio: json["mutual_fund_portfolio"]!,
    fixedDeposite: json["fixed_deposite"],
    loanDetails: json["loan_details"],
    insurance: json["insurance"]!,
    pms: json["pms"],
    ncd: json["ncd"]!,
    reference1: json["reference_1"],
    reference2: json["reference_2"],
    remark: json["remark"],
    meetingStatus: json["meeting_status"]!,
    approvedRejectByUserName: json["approved_reject_by_user_name"],
    approvedRejectByUserType: json["approved_reject_by_user_type"],
    approvedRejectByUserDate: json["approved_reject_by_user_date"],
    meetingCheckInDateTime: json["meeting_check_in_date_time"],
    meetingCheckInFullAddress: json["meeting_check_in_full_address"],
    meetingTimeSlotFrom: json["meeting_time_slot_from"]!,
    meetingTimeSlotTo: json["meeting_time_slot_to"]!,
    meetingDate: json["meeting_date"],
    meetingTime: json["meeting_time"],
    meetingCheckInStatus: json["meeting_check_in_status"]?.toString() ?? "",
    meetingCheckOutStatus: json["meeting_check_out_status"]?.toString() ?? "",
    meetingCheckOutDateTime: json["meeting_check_out_date_time"] ?? "",
    meetingCheckOutFullAddress: json["meeting_check_out_full_address"] ?? "",
    meetingMinutes: json["meeting_minutes"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "tbl_meeting_id": tblMeetingId,
    "tbl_user_id": tblUserId,
    "emp_id": empId,
    "full_name": fullName,
    "designation_abbr": designationAbbr,
    "tbl_office_id": tblOfficeId,
    "client_id": clientId,
    "client_name": clientName,
    "client_email": clientEmail,
    "client_mobile": clientMobile,
    "city": city,
    "state": state,
    "country": country,
    "full_address": fullAddress,
    "family_details": familyDetails,
    "stock_portfolio_with_us": stockPortfolioWithUs,
    "stock_portfolio_with_other_broker": stockPortfolioWithOtherBroker,
    "mutual_fund_portfolio": mutualFundPortfolio,
    "fixed_deposite": fixedDeposite,
    "loan_details": loanDetails,
    "insurance": insurance,
    "pms": pms,
    "ncd": ncd,
    "reference_1": reference1,
    "reference_2": reference2,
    "remark": remark,
    "meeting_status": meetingStatus,
    "approved_reject_by_user_name": approvedRejectByUserName,
    "approved_reject_by_user_type": approvedRejectByUserType,
    "approved_reject_by_user_date": approvedRejectByUserDate,
    "meeting_check_in_date_time": meetingCheckInDateTime,
    "meeting_check_in_full_address": meetingCheckInFullAddress,
    "meeting_time_slot_from": meetingTimeSlotFrom,
    "meeting_time_slot_to": meetingTimeSlotTo,
    "meeting_date": meetingDate,
    "meeting_time": meetingTime,
    "meeting_check_in_status": meetingCheckInStatus,
    "meeting_check_out_status": meetingCheckOutStatus,
    "meeting_check_out_date_time": meetingCheckOutDateTime,
    "meeting_check_out_full_address": meetingCheckOutFullAddress,
    "meeting_minutes": meetingMinutes,
  };
}
