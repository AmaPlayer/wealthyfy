// To parse this JSON data, do
//
//     final attendanceListModel = attendanceListModelFromJson(jsonString);

import 'dart:convert';

AttendanceListModel attendanceListModelFromJson(String str) => AttendanceListModel.fromJson(json.decode(str));

String attendanceListModelToJson(AttendanceListModel data) => json.encode(data.toJson());

class AttendanceListModel {
  bool status;
  String message;
  List<DatumAttendance> data;

  AttendanceListModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AttendanceListModel.fromJson(Map<String, dynamic> json) => AttendanceListModel(
    status: json["status"],
    message: json["message"],
    data: List<DatumAttendance>.from(json["data"].map((x) => DatumAttendance.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DatumAttendance {
  dynamic tblAttendanceId;
  dynamic tblUserId;
  dynamic tblOfficeId;
  dynamic dayNumber;
  dynamic dayName;
  dynamic createdDate;
  dynamic checkInTime;
  dynamic checkOutTime;
  dynamic workingTime;
  dynamic status;
  dynamic isEarly;
  dynamic isLate;
  DatumAttendance({
    required this.tblAttendanceId,
    required this.tblUserId,
    required this.tblOfficeId,
    required this.dayNumber,
    required this.dayName,
    required this.createdDate,
    required this.checkInTime,
    required this.checkOutTime,
    required this.workingTime,
    required this.status,
    required this.isEarly,
    required this.isLate,
  });

  factory DatumAttendance.fromJson(Map<String, dynamic> json) => DatumAttendance(
    tblAttendanceId: json["tbl_attendance_id"],
    tblUserId: json["tbl_user_id"],
    tblOfficeId: json["tbl_office_id"],
    dayNumber: json["day_number"],
    dayName: json["day_name"],
    createdDate: json["created_date"],
    checkInTime: json["check_in_time"],
    checkOutTime:json["check_out_time"]!,
    workingTime: json["working_time"]!,
    status: json["status"]!,
    isEarly: json["isEarly"]!,
    isLate: json["isLate"]!,
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
    "status": status,
    "isEarly": isEarly,
    "isLate": isLate,
  };
}
