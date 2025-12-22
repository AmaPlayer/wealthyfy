
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

  });

  factory DasApprovedMeetingDatum.fromJson(Map<String, dynamic> json) => DasApprovedMeetingDatum(
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
    approvedByUserId: json["approved_by_user_id"],
    approvedByUserName: json["approved_by_user_name"],
    approvedByUserType: json["approved_by_user_type"],
    approvedByUserDate: json["approved_by_user_date"],
    approvedByUserTime: json["approved_by_user_time"],
    meetingCheckInStatus: json["meeting_check_in_status"],
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
  };
}
