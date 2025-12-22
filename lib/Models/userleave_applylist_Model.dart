
import 'dart:convert';

UserLeaveApplyListModel userLeaveApplyListModelFromJson(String str) => UserLeaveApplyListModel.fromJson(json.decode(str));

String userLeaveApplyListModelToJson(UserLeaveApplyListModel data) => json.encode(data.toJson());

class UserLeaveApplyListModel {
  bool status;
  String message;
  List<UserApplyListDatum> data;

  UserLeaveApplyListModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UserLeaveApplyListModel.fromJson(Map<String, dynamic> json) => UserLeaveApplyListModel(
    status: json["status"],
    message: json["message"],
    data: List<UserApplyListDatum>.from(json["data"].map((x) => UserApplyListDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class UserApplyListDatum {
  String tblUserLeaveId;
  int tblUserId;
  int tblOfficeId;
  String leaveType;
  String fromDate;
  String toDate;
  String leaveApplyDate;
  String leaveApplyTime;
  String status;
  String reason;
  String fullName;
  String designationAbbr;

  UserApplyListDatum({
    required this.tblUserLeaveId,
    required this.tblUserId,
    required this.tblOfficeId,
    required this.leaveType,
    required this.fromDate,
    required this.toDate,
    required this.leaveApplyDate,
    required this.leaveApplyTime,
    required this.status,
    required this.reason,
    required this.fullName,
    required this.designationAbbr,
  });

  factory UserApplyListDatum.fromJson(Map<String, dynamic> json) => UserApplyListDatum(
    tblUserLeaveId: json["tbl_user_leave_id"],
    tblUserId: json["tbl_user_id"],
    tblOfficeId: json["tbl_office_id"],
    leaveType: json["leave_type"],
    fromDate: json["from_date"],
    toDate: json["to_date"],
    leaveApplyDate: json["leave_apply_date"],
    leaveApplyTime: json["leave_apply_time"],
    status: json["status"],
    reason: json["reason"],
    fullName: json["full_name"],
    designationAbbr: json["designation_abbr"],
  );

  Map<String, dynamic> toJson() => {
    "tbl_user_leave_id": tblUserLeaveId,
    "tbl_user_id": tblUserId,
    "tbl_office_id": tblOfficeId,
    "leave_type": leaveType,
    "from_date": fromDate,
    "to_date": toDate,
    "leave_apply_date": leaveApplyDate,
    "leave_apply_time": leaveApplyTime,
    "status": status,
    "reason": reason,
    "full_name": fullName,
    "designation_abbr": designationAbbr,
  };
}
