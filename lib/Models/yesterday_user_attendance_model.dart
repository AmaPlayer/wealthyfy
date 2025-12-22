
import 'dart:convert';

YesterdayUserAttendanceModel yesterdayUserAttendanceModelFromJson(String str) => YesterdayUserAttendanceModel.fromJson(json.decode(str));

String yesterdayUserAttendanceModelToJson(YesterdayUserAttendanceModel data) => json.encode(data.toJson());

class YesterdayUserAttendanceModel {
  bool status;
  String message;
  List<UserYesterDayDatum> data;

  YesterdayUserAttendanceModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory YesterdayUserAttendanceModel.fromJson(Map<String, dynamic> json) => YesterdayUserAttendanceModel(
    status: json["status"],
    message: json["message"],
    data: List<UserYesterDayDatum>.from(json["data"].map((x) => UserYesterDayDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class UserYesterDayDatum {
  String tblAttendanceId;
  int tblUserId;
  int tblOfficeId;
  String dayNumber;
  String dayName;
  String createdDate;
  String checkInTime;
  String checkOutTime;
  String workingTime;

  UserYesterDayDatum({
    required this.tblAttendanceId,
    required this.tblUserId,
    required this.tblOfficeId,
    required this.dayNumber,
    required this.dayName,
    required this.createdDate,
    required this.checkInTime,
    required this.checkOutTime,
    required this.workingTime,
  });

  factory UserYesterDayDatum.fromJson(Map<String, dynamic> json) => UserYesterDayDatum(
    tblAttendanceId: json["tbl_attendance_id"],
    tblUserId: json["tbl_user_id"],
    tblOfficeId: json["tbl_office_id"],
    dayNumber: json["day_number"],
    dayName: json["day_name"],
    createdDate: json["created_date"],
    checkInTime: json["check_in_time"],
    checkOutTime: json["check_out_time"],
    workingTime: json["working_time"],
  );

  Map<String, dynamic> toJson() => {
    "tbl_attendance_id": tblAttendanceId,
    "tbl_user_id": tblUserId,
    "tbl_office_id": tblOfficeId,
    "day_number": dayNumber,
    "day_name": dayName,
    "created_date": createdDate,
    "check_in_time": checkInTime,
    "check_out_time": checkOutTime,
    "working_time": workingTime,
  };
}
