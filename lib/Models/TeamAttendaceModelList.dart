// To parse this JSON data, do
//
//     final teamAttendaceModelList = teamAttendaceModelListFromJson(jsonString);

import 'dart:convert';

TeamAttendaceModelList teamAttendaceModelListFromJson(String str) => TeamAttendaceModelList.fromJson(json.decode(str));

String teamAttendaceModelListToJson(TeamAttendaceModelList data) => json.encode(data.toJson());

class TeamAttendaceModelList {
  bool status;
  String message;
  int totalRecords;
  String pagenumber;
  int totalPages;
  List<teamAttDatum> data;

  TeamAttendaceModelList({
    required this.status,
    required this.message,
    required this.totalRecords,
    required this.pagenumber,
    required this.totalPages,
    required this.data,
  });

  factory TeamAttendaceModelList.fromJson(Map<String, dynamic> json) => TeamAttendaceModelList(
    status: json["status"],
    message: json["message"],
    totalRecords: json["total_records"],
    pagenumber: json["pagenumber"],
    totalPages: json["total_pages"],
    data: List<teamAttDatum>.from(json["data"].map((x) => teamAttDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "total_records": totalRecords,
    "pagenumber": pagenumber,
    "total_pages": totalPages,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class teamAttDatum {
  dynamic tblAttendanceId;
  dynamic tblUserId;
  dynamic empId;
  String fullName;
  dynamic designationAbbr;
  dynamic tblOfficeId;
  String dayNumber;
  dynamic dayName;
  dynamic createdDate;
  dynamic checkInTime;
  dynamic checkOutTime;
  dynamic workingTime;
  dynamic status;
  dynamic isLate;
  dynamic isEarly;

  teamAttDatum({
    required this.tblAttendanceId,
    required this.tblUserId,
    required this.empId,
    required this.fullName,
    required this.designationAbbr,
    required this.tblOfficeId,
    required this.dayNumber,
    required this.dayName,
    required this.createdDate,
    required this.checkInTime,
    required this.checkOutTime,
    required this.workingTime,
    required this.status,
    required this.isLate,
    required this.isEarly,
  });

  factory teamAttDatum.fromJson(Map<String, dynamic> json) => teamAttDatum(
    tblAttendanceId: json["tbl_attendance_id"],
    tblUserId: json["tbl_user_id"],
    empId: json["emp_id"]!,
    fullName: json["full_name"]!,
    designationAbbr: json["designation_abbr"]!,
    tblOfficeId: json["tbl_office_id"],
    dayNumber: json["day_number"],
    dayName: json["day_name"]!,
    createdDate: json["created_date"],
    checkInTime: json["check_in_time"]!,
    checkOutTime: json["check_out_time"]!,
    workingTime: json["working_time"]!,
    status: json["status"]!,
    isLate: json["isLate"]!,
    isEarly: json["isEarly"]!,
  );

  Map<String, dynamic> toJson() => {
    "tbl_attendance_id": tblAttendanceId,
    "tbl_user_id": tblUserId,
    "emp_id": empId,
    "full_name": fullName,
    "designation_abbr": designationAbbr,
    "tbl_office_id": tblOfficeId,
    "day_number": dayNumber,
    "day_name": dayName,
    "created_date": createdDate,
    "check_in_time": checkInTime,
    "check_out_time": checkOutTime,
    "working_time": workingTime,
    "status": status,
    "isLate": isLate,
    "isEarly": isEarly,
  };
}
