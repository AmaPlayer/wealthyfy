
import 'dart:convert';

UserMeetingDetailsModel userMeetingDetailsModelFromJson(String str) => UserMeetingDetailsModel.fromJson(json.decode(str));

String userMeetingDetailsModelToJson(UserMeetingDetailsModel data) => json.encode(data.toJson());

class UserMeetingDetailsModel {
  bool status;
  String message;
  List<MeetingDetailDatum> data;

  UserMeetingDetailsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UserMeetingDetailsModel.fromJson(Map<String, dynamic> json) => UserMeetingDetailsModel(
    status: json["status"],
    message: json["message"],
    data: List<MeetingDetailDatum>.from(json["data"].map((x) => MeetingDetailDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class MeetingDetailDatum {
  String tblMeetingId;
  dynamic tblUserId;
  dynamic tblOfficeId;
  String clientId;
  String fullName;
  String designationAbbr;
  String clientName;
  String clientEmail;
  String clientMobile;
  String meetingCheckInFullAddress;
  String city;
  String state;
  String country;
  String familyDetails;
  String stockPortfolioWithUs;
  String stockPortfolioWithOtherBroker;
  String mutualFundPortfolio;
  String fixedDeposite;
  String loanDetails;
  String insurance;
  String pms;
  String ncd;
  String reference1;
  String reference2;
  String remark;
  String meetingStatus;
  String meetingDate;
  String meetingTime;
  String fullAddress;
  String meetingCheckInStatus;
  String meetingCheckInDateTime;
  String meetingCheckInLatitude;
  String meetingCheckInLongitude;
  String checkpoint1DateTime;
  String checkpoint1Latitude;
  String checkpoint1Longitude;
  String checkpoint2DateTime;
  String checkpoint2Latitude;
  String checkpoint2Longitude;
  String meetingCheckOutStatus;
  String meetingCheckOutDateTime;
  String meetingCheckOutFullAddress;
  String meetingCheckOutLatitude;
  String meetingCheckOutLongitude;
  String meetingMinutes;
  String meetingAgenda;
  String holdingValue;
  String meetingTimeSlotFrom;
  String meetingTimeSlotTo;
  String meetingLatitude;
  String meetingLongitude;

  MeetingDetailDatum({
    required this.tblMeetingId,
    required this.tblUserId,
    required this.tblOfficeId,
    required this.fullName,
    required this.clientId,
    required this.clientName,
    required this.clientEmail,
    required this.clientMobile,
    required this.city,
    required this.state,
    required this.country,
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
    required this.meetingDate,
    required this.meetingTime,
    required this.fullAddress,
    required this.designationAbbr,
    required this.meetingCheckInFullAddress,
    required this.meetingCheckInStatus,
    required this.meetingCheckInDateTime,
    required this.meetingCheckInLatitude,
    required this.meetingCheckInLongitude,
    required this.checkpoint1DateTime,
    required this.checkpoint1Latitude,
    required this.checkpoint1Longitude,
    required this.checkpoint2DateTime,
    required this.checkpoint2Latitude,
    required this.checkpoint2Longitude,
    required this.meetingCheckOutStatus,
    required this.meetingCheckOutDateTime,
    required this.meetingCheckOutFullAddress,
    required this.meetingCheckOutLatitude,
    required this.meetingCheckOutLongitude,
    required this.meetingMinutes,
    required this.meetingAgenda,
    required this.holdingValue,
    required this.meetingTimeSlotFrom,
    required this.meetingTimeSlotTo,
    required this.meetingLatitude,
    required this.meetingLongitude,
  });

  factory MeetingDetailDatum.fromJson(Map<String, dynamic> json) => MeetingDetailDatum(
    tblMeetingId: json["tbl_meeting_id"],
    tblUserId: json["tbl_user_id"],
    tblOfficeId: json["tbl_office_id"],
    clientId: json["client_id"],
    clientName: json["client_name"],
    clientEmail: json["client_email"],
    clientMobile: json["client_mobile"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    familyDetails: json["family_details"],
    stockPortfolioWithUs: json["stock_portfolio_with_us"],
    stockPortfolioWithOtherBroker: json["stock_portfolio_with_other_broker"],
    mutualFundPortfolio: json["mutual_fund_portfolio"],
    fixedDeposite: json["fixed_deposite"],
    loanDetails: json["loan_details"],
    insurance: json["insurance"],
    pms: json["pms"],
    ncd: json["ncd"],
    reference1: json["reference_1"],
    reference2: json["reference_2"],
    remark: json["remark"],
    meetingStatus: json["meeting_status"],
    meetingDate: json["meeting_date"],
    meetingTime: json["meeting_time"],
    fullAddress: json["full_address"],
    fullName: json["full_name"],
    designationAbbr: json["designation_abbr"],
    meetingCheckInFullAddress: json["meeting_check_in_full_address"],
    meetingCheckInStatus: _normalizeStatus(json["meeting_check_in_status"]),
    meetingCheckInDateTime: json["meeting_check_in_date_time"],
    meetingCheckInLatitude: json["meeting_check_in_latitude"]?.toString() ?? "",
    meetingCheckInLongitude: json["meeting_check_in_longitude"]?.toString() ?? "",
    checkpoint1DateTime: json["checkpoint1"]?.toString() ?? "",
    checkpoint1Latitude: json["checkpoint1_latitude"]?.toString() ?? "",
    checkpoint1Longitude: json["checkpoint1_longitude"]?.toString() ?? "",
    checkpoint2DateTime: json["checkpoint2"]?.toString() ?? "",
    checkpoint2Latitude: json["checkpoint2_latitude"]?.toString() ?? "",
    checkpoint2Longitude: json["checkpoint2_longitude"]?.toString() ?? "",
    meetingCheckOutStatus: _normalizeStatus(json["meeting_check_out_status"]),
    meetingCheckOutDateTime: json["meeting_check_out_date_time"] ?? "",
    meetingCheckOutFullAddress: json["meeting_check_out_full_address"] ?? "",
    meetingCheckOutLatitude: json["meeting_check_out_latitude"] ?? "",
    meetingCheckOutLongitude: json["meeting_check_out_longitude"] ?? "",
    meetingMinutes: json["meeting_minutes"] ?? "",
    meetingAgenda: json["meeting_agenda"] ?? json["agenda"] ?? "",
    holdingValue: json["holding_value"]?.toString() ?? "",
    meetingTimeSlotFrom: json["meeting_time_slot_from"],
    meetingTimeSlotTo: json["meeting_time_slot_to"],
    meetingLatitude: json["meeting_latitude"],
    meetingLongitude: json["meeting_longitude"],
  );

  Map<String, dynamic> toJson() => {
    "tbl_meeting_id": tblMeetingId,
    "tbl_user_id": tblUserId,
    "tbl_office_id": tblOfficeId,
    "client_id": clientId,
    "client_name": clientName,
    "client_email": clientEmail,
    "client_mobile": clientMobile,
    "city": city,
    "state": state,
    "country": country,
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
    "meeting_date": meetingDate,
    "meeting_time": meetingTime,
    "full_address": fullAddress,
    "full_name": fullName,
    "designation_abbr": designationAbbr,
    "meeting_check_in_full_address": meetingCheckInFullAddress,
    "meeting_check_in_status": meetingCheckInStatus,
    "meeting_check_in_date_time": meetingCheckInDateTime,
    "meeting_check_in_latitude": meetingCheckInLatitude,
    "meeting_check_in_longitude": meetingCheckInLongitude,
    "checkpoint1": checkpoint1DateTime,
    "checkpoint1_latitude": checkpoint1Latitude,
    "checkpoint1_longitude": checkpoint1Longitude,
    "checkpoint2": checkpoint2DateTime,
    "checkpoint2_latitude": checkpoint2Latitude,
    "checkpoint2_longitude": checkpoint2Longitude,
    "meeting_check_out_status": meetingCheckOutStatus,
    "meeting_check_out_date_time": meetingCheckOutDateTime,
    "meeting_check_out_full_address": meetingCheckOutFullAddress,
    "meeting_check_out_latitude": meetingCheckOutLatitude,
    "meeting_check_out_longitude": meetingCheckOutLongitude,
    "meeting_minutes": meetingMinutes,
    "meeting_agenda": meetingAgenda,
    "holding_value": holdingValue,
    "meeting_time_slot_from": meetingTimeSlotFrom,
    "meeting_time_slot_to": meetingTimeSlotTo,
    "meeting_latitude": meetingLatitude,
    "meeting_longitude": meetingLongitude,
  };
}

String _normalizeStatus(dynamic value) {
  if (value == null) return "";
  final raw = value.toString().toLowerCase();
  if (raw == "1" || raw == "yes" || raw == "true") return "yes";
  return "no";
}
