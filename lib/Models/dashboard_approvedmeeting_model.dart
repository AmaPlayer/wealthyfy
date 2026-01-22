
import 'dart:convert';

DashboardApprovedMeetingModel dashboardApprovedMeetingModelFromJson(String str) => DashboardApprovedMeetingModel.fromJson(json.decode(str));

String dashboardApprovedMeetingModelToJson(DashboardApprovedMeetingModel data) => json.encode(data.toJson());

class DashboardApprovedMeetingModel {
  bool status;
  String message;
  List<DasApprovedMeetingDatum> data;

  DashboardApprovedMeetingModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DashboardApprovedMeetingModel.fromJson(Map<String, dynamic> json) => DashboardApprovedMeetingModel(
    status: json["status"],
    message: json["message"],
    data: List<DasApprovedMeetingDatum>.from(json["data"].map((x) => DasApprovedMeetingDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DasApprovedMeetingDatum {
  String tblMeetingId;
  int tblUserId;
  int tblOfficeId;
  String clientId;
  String clientName;
  String clientEmail;
  String clientMobile;
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
  int approvedByUserId;
  String approvedByUserName;
  String approvedByUserType;
  String approvedByUserDate;
  String approvedByUserTime;
  String meetingCheckInStatus;
  String meetingCheckOutStatus;
  String meetingCheckOutDateTime;

  DasApprovedMeetingDatum({
    required this.tblMeetingId,
    required this.tblUserId,
    required this.tblOfficeId,
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
    required this.approvedByUserId,
    required this.approvedByUserName,
    required this.approvedByUserType,
    required this.approvedByUserDate,
    required this.approvedByUserTime,
    required this.meetingCheckInStatus,
    required this.meetingCheckOutStatus,
    required this.meetingCheckOutDateTime,

  });

  factory DasApprovedMeetingDatum.fromJson(Map<String, dynamic> json) => DasApprovedMeetingDatum(
    tblMeetingId: _asString(json["tbl_meeting_id"]),
    tblUserId: _asInt(json["tbl_user_id"]),
    tblOfficeId: _asInt(json["tbl_office_id"]),
    clientId: _asString(json["client_id"]),
    clientName: _asString(json["client_name"]),
    clientEmail: _asString(json["client_email"]),
    clientMobile: _asString(json["client_mobile"]),
    city: _asString(json["city"]),
    state: _asString(json["state"]),
    country: _asString(json["country"]),
    familyDetails: _asString(json["family_details"]),
    stockPortfolioWithUs: _asString(json["stock_portfolio_with_us"]),
    stockPortfolioWithOtherBroker: _asString(json["stock_portfolio_with_other_broker"]),
    mutualFundPortfolio: _asString(json["mutual_fund_portfolio"]),
    fixedDeposite: _asString(json["fixed_deposite"]),
    loanDetails: _asString(json["loan_details"]),
    insurance: _asString(json["insurance"]),
    pms: _asString(json["pms"]),
    ncd: _asString(json["ncd"]),
    reference1: _asString(json["reference_1"]),
    reference2: _asString(json["reference_2"]),
    remark: _asString(json["remark"]),
    meetingStatus: _asString(json["meeting_status"]),
    meetingDate: _asString(json["meeting_date"]),
    meetingTime: _asString(json["meeting_time"]),
    approvedByUserId: _asInt(json["approved_by_user_id"]),
    approvedByUserName: _asString(json["approved_by_user_name"]),
    approvedByUserType: _asString(json["approved_by_user_type"]),
    approvedByUserDate: _asString(json["approved_by_user_date"]),
    approvedByUserTime: _asString(json["approved_by_user_time"]),
    meetingCheckInStatus: _normalizeStatus(json["meeting_check_in_status"]),
    meetingCheckOutStatus: _normalizeStatus(json["meeting_check_out_status"]),
    meetingCheckOutDateTime: _asString(json["meeting_check_out_date_time"]),
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
    "approved_by_user_id": approvedByUserId,
    "approved_by_user_name": approvedByUserName,
    "approved_by_user_type": approvedByUserType,
    "approved_by_user_date": approvedByUserDate,
    "approved_by_user_time": approvedByUserTime,
    "meeting_check_in_status": meetingCheckInStatus,
    "meeting_check_out_status": meetingCheckOutStatus,
    "meeting_check_out_date_time": meetingCheckOutDateTime,
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
