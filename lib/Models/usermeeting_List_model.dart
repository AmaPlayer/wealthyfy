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
  String meetingCheckInLatitude;
  String meetingCheckInLongitude;
  String checkpoint1DateTime;
  String checkpoint1Latitude;
  String checkpoint1Longitude;
  String checkpoint2DateTime;
  String checkpoint2Latitude;
  String checkpoint2Longitude;
  String meetingTimeSlotFrom;
  String meetingTimeSlotTo;
  String meetingDate;
  String meetingTime;
  String meetingCheckInStatus;
  String meetingCheckOutStatus;
  String meetingCheckOutDateTime;
  String meetingCheckOutFullAddress;
  String meetingMinutes;
  String meetingAgenda;
  String holdingValue;

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
    required this.meetingCheckInLatitude,
    required this.meetingCheckInLongitude,
    required this.checkpoint1DateTime,
    required this.checkpoint1Latitude,
    required this.checkpoint1Longitude,
    required this.checkpoint2DateTime,
    required this.checkpoint2Latitude,
    required this.checkpoint2Longitude,
    required this.meetingTimeSlotFrom,
    required this.meetingTimeSlotTo,
    required this.meetingDate,
    required this.meetingTime,
    required this.meetingCheckInStatus,
    required this.meetingCheckOutStatus,
    required this.meetingCheckOutDateTime,
    required this.meetingCheckOutFullAddress,
    required this.meetingMinutes,
    required this.meetingAgenda,
    required this.holdingValue,
  });

  factory MeetingDatum.fromJson(Map<String, dynamic> json) => MeetingDatum(
    tblMeetingId: _asString(json["tbl_meeting_id"]),
    tblUserId: _asInt(json["tbl_user_id"]),
    empId: json["emp_id"],
    fullName: json["full_name"],
    designationAbbr: json["designation_abbr"],
    tblOfficeId: _asInt(json["tbl_office_id"]),
    clientId: _asString(json["client_id"]),
    clientName: _asString(json["client_name"]),
    clientEmail: _asString(json["client_email"]),
    clientMobile: _asString(json["client_mobile"]),
    city: _asString(json["city"]),
    state: _asString(json["state"]),
    country: _asString(json["country"]),
    fullAddress: _asString(json["full_address"]),
    familyDetails: _asString(json["family_details"]),
    stockPortfolioWithUs: _asString(json["stock_portfolio_with_us"]),
    stockPortfolioWithOtherBroker: _asString(json["stock_portfolio_with_other_broker"]),
    mutualFundPortfolio: json["mutual_fund_portfolio"]!,
    fixedDeposite: json["fixed_deposite"],
    loanDetails: _asString(json["loan_details"]),
    insurance: _asString(json["insurance"]),
    pms: _asString(json["pms"]),
    ncd: json["ncd"]!,
    reference1: _asString(json["reference_1"]),
    reference2: _asString(json["reference_2"]),
    remark: _asString(json["remark"]),
    meetingStatus: _asString(json["meeting_status"]),
    approvedRejectByUserName: _asString(json["approved_reject_by_user_name"]),
    approvedRejectByUserType: _asString(json["approved_reject_by_user_type"]),
    approvedRejectByUserDate: _asString(json["approved_reject_by_user_date"]),
    meetingCheckInDateTime: _asString(json["meeting_check_in_date_time"]),
    meetingCheckInFullAddress: _asString(json["meeting_check_in_full_address"]),
    meetingCheckInLatitude: json["meeting_check_in_latitude"]?.toString() ?? "",
    meetingCheckInLongitude: json["meeting_check_in_longitude"]?.toString() ?? "",
    checkpoint1DateTime: json["checkpoint1"]?.toString() ?? "",
    checkpoint1Latitude: json["checkpoint1_latitude"]?.toString() ?? "",
    checkpoint1Longitude: json["checkpoint1_longitude"]?.toString() ?? "",
    checkpoint2DateTime: json["checkpoint2"]?.toString() ?? "",
    checkpoint2Latitude: json["checkpoint2_latitude"]?.toString() ?? "",
    checkpoint2Longitude: json["checkpoint2_longitude"]?.toString() ?? "",
    meetingTimeSlotFrom: _asString(json["meeting_time_slot_from"]),
    meetingTimeSlotTo: _asString(json["meeting_time_slot_to"]),
    meetingDate: _asString(json["meeting_date"]),
    meetingTime: _asString(json["meeting_time"]),
    meetingCheckInStatus: _normalizeStatus(json["meeting_check_in_status"]),
    meetingCheckOutStatus: _normalizeStatus(json["meeting_check_out_status"]),
    meetingCheckOutDateTime: json["meeting_check_out_date_time"] ?? "",
    meetingCheckOutFullAddress: json["meeting_check_out_full_address"] ?? "",
    meetingMinutes: json["meeting_minutes"] ?? "",
    meetingAgenda: json["meeting_agenda"] ?? json["agenda"] ?? "",
    holdingValue: json["holding_value"]?.toString() ?? "",
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
    "meeting_check_in_latitude": meetingCheckInLatitude,
    "meeting_check_in_longitude": meetingCheckInLongitude,
    "checkpoint1": checkpoint1DateTime,
    "checkpoint1_latitude": checkpoint1Latitude,
    "checkpoint1_longitude": checkpoint1Longitude,
    "checkpoint2": checkpoint2DateTime,
    "checkpoint2_latitude": checkpoint2Latitude,
    "checkpoint2_longitude": checkpoint2Longitude,
    "meeting_time_slot_from": meetingTimeSlotFrom,
    "meeting_time_slot_to": meetingTimeSlotTo,
    "meeting_date": meetingDate,
    "meeting_time": meetingTime,
    "meeting_check_in_status": meetingCheckInStatus,
    "meeting_check_out_status": meetingCheckOutStatus,
    "meeting_check_out_date_time": meetingCheckOutDateTime,
    "meeting_check_out_full_address": meetingCheckOutFullAddress,
    "meeting_minutes": meetingMinutes,
    "meeting_agenda": meetingAgenda,
    "holding_value": holdingValue,
  };
}

String _normalizeStatus(dynamic value) {
  if (value == null) return "";
  final raw = value.toString().toLowerCase();
  if (raw == "1" || raw == "yes" || raw == "true") return "yes";
  return "no";
}

String _asString(dynamic value) {
  if (value == null) return "";
  return value.toString();
}

int _asInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  return int.tryParse(value.toString()) ?? 0;
}
