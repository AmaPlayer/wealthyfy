// To parse this JSON data, do
//
//     final notificationModelList = notificationModelListFromJson(jsonString);

import 'dart:convert';

NotificationModelList notificationModelListFromJson(String str) => NotificationModelList.fromJson(json.decode(str));

String notificationModelListToJson(NotificationModelList data) => json.encode(data.toJson());

class NotificationModelList {
  bool status;
  String message;
  List<notificationDatum> data;

  NotificationModelList({
    required this.status,
    required this.message,
    required this.data,
  });

  factory NotificationModelList.fromJson(Map<String, dynamic> json) => NotificationModelList(
    status: json["status"],
    message: json["message"],
    data: List<notificationDatum>.from(json["data"].map((x) => notificationDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class notificationDatum {
  String tblNotificationId;
  int tblUserId;
  int parentId;
  String empId;
  String fullName;
  String userImage;
  String designationAbbr;
  int tblOfficeId;
  int meetingLeaveId;
  String title;
  String description;
  String notificationType;
  String createdDate;
  String createdTime;
  dynamic status;
  dynamic createdDay;

  notificationDatum({
    required this.tblNotificationId,
    required this.tblUserId,
    required this.parentId,
    required this.empId,
    required this.fullName,
    required this.userImage,
    required this.designationAbbr,
    required this.tblOfficeId,
    required this.meetingLeaveId,
    required this.title,
    required this.description,
    required this.notificationType,
    required this.createdDate,
    required this.createdTime,
    required this.status,
    required this.createdDay,
  });

  factory notificationDatum.fromJson(Map<String, dynamic> json) => notificationDatum(
    tblNotificationId: json["tbl_notification_id"],
    tblUserId: json["tbl_user_id"],
    parentId: json["parent_id"],
    empId: json["emp_id"],
    fullName: json["full_name"],
    userImage: json["user_image"],
    designationAbbr: json["designation_abbr"],
    tblOfficeId: json["tbl_office_id"],
    meetingLeaveId: json["meeting_leave_id"],
    title: json["title"],
    description: json["description"],
    notificationType: json["notification_type"],
    createdDate: json["created_date"],
    createdTime: json["created_time"],
    status: json["status"],
    createdDay: json["created_day"],
  );

  Map<String, dynamic> toJson() => {
    "tbl_notification_id": tblNotificationId,
    "tbl_user_id": tblUserId,
    "parent_id": parentId,
    "emp_id": empId,
    "full_name": fullName,
    "user_image": userImage,
    "designation_abbr": designationAbbr,
    "tbl_office_id": tblOfficeId,
    "meeting_leave_id": meetingLeaveId,
    "title": title,
    "description": description,
    "notification_type": notificationType,
    "created_date": createdDate,
    "created_time": createdTime,
    "status": status,
    "created_day": createdDay,
  };
}
