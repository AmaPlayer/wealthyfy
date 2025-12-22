
import 'dart:convert';

LeaveTypeModel leaveTypeModelFromJson(String str) => LeaveTypeModel.fromJson(json.decode(str));

String leaveTypeModelToJson(LeaveTypeModel data) => json.encode(data.toJson());

class LeaveTypeModel {
  bool status;
  String message;
  List<LeaveDatum> data;

  LeaveTypeModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LeaveTypeModel.fromJson(Map<String, dynamic> json) => LeaveTypeModel(
    status: json["status"],
    message: json["message"],
    data: List<LeaveDatum>.from(json["data"].map((x) => LeaveDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class LeaveDatum {
  String tblLeaveTypeId;
  String leaveType;

  LeaveDatum({
    required this.tblLeaveTypeId,
    required this.leaveType,
  });

  factory LeaveDatum.fromJson(Map<String, dynamic> json) => LeaveDatum(
    tblLeaveTypeId: json["tbl_leave_type_id"],
    leaveType: json["leave_type"],
  );

  Map<String, dynamic> toJson() => {
    "tbl_leave_type_id": tblLeaveTypeId,
    "leave_type": leaveType,
  };
}
