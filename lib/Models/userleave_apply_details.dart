
import 'dart:convert';

UserLeaveDetailsModel userLeaveAppDetailsModelFromJson(String str) => UserLeaveDetailsModel.fromJson(json.decode(str));

String userLeaveAppDetailsModelToJson(UserLeaveDetailsModel data) => json.encode(data.toJson());

class UserLeaveDetailsModel {
  bool status;
  String message;
  List<UserLeaveDetailsDatum> data;

  UserLeaveDetailsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UserLeaveDetailsModel.fromJson(Map<String, dynamic> json) => UserLeaveDetailsModel(
    status: json["status"],
    message: json["message"],
    data: List<UserLeaveDetailsDatum>.from(json["data"].map((x) => UserLeaveDetailsDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class UserLeaveDetailsDatum {
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

  UserLeaveDetailsDatum({
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
  });

  factory UserLeaveDetailsDatum.fromJson(Map<String, dynamic> json) => UserLeaveDetailsDatum(
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
  };
}
