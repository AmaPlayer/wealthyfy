import 'dart:convert';

MyTeamListModel myTeamListModelFromJson(String str) => MyTeamListModel.fromJson(json.decode(str));

String myTeamListModelToJson(MyTeamListModel data) => json.encode(data.toJson());

class MyTeamListModel {
  bool status;
  String message;
  String myFullName;
  String myDesignation;
  String tblUserId;
  List<teamDatum> data;

  MyTeamListModel({
    required this.status,
    required this.message,
    required this.data,
    required this.myFullName,
    required this.tblUserId,
    required this.myDesignation,
  });

  factory MyTeamListModel.fromJson(Map<String, dynamic> json) => MyTeamListModel(
    status: json["status"],
    message: json["message"],
    myFullName: json["my_full_name"],
    myDesignation: json["my_designation"],
    tblUserId: json["tbl_user_id"],
    data: List<teamDatum>.from(json["data"].map((x) => teamDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "my_full_name": myFullName,
    "my_designation": myDesignation,
    "tbl_user_id": myDesignation,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class teamDatum {
  String tblUserId;
  String empId;
  int tblOfficeId;
  String officeName;
  String designationType;
  String designationName;
  String fullName;
  String email;
  String mobile;
  String checkInStatus;
  String checkOutStatus;
  String userImage;
  String createdDate;

  teamDatum({
    required this.tblUserId,
    required this.empId,
    required this.tblOfficeId,
    required this.officeName,
    required this.designationType,
    required this.designationName,
    required this.fullName,
    required this.email,
    required this.mobile,
    required this.checkInStatus,
    required this.checkOutStatus,
    required this.userImage,
    required this.createdDate,
  });

  factory teamDatum.fromJson(Map<String, dynamic> json) => teamDatum(
    tblUserId: json["tbl_user_id"],
    empId: json["emp_id"],
    tblOfficeId: json["tbl_office_id"],
    officeName: json["office_name"],
    designationType: json["designation_type"],
    designationName: json["designation_name"],
    fullName: json["full_name"],
    email: json["email"],
    mobile: json["mobile"],
    checkInStatus: json["check_in_status"],
    checkOutStatus: json["check_out_status"],
    userImage: json["user_image"],
    createdDate: json["created_date"],
  );

  Map<String, dynamic> toJson() => {
    "tbl_user_id": tblUserId,
    "emp_id": empId,
    "tbl_office_id": tblOfficeId,
    "office_name": officeName,
    "designation_type": designationType,
    "designation_name": designationName,
    "full_name": fullName,
    "email": email,
    "mobile": mobile,
    "check_in_status": checkInStatus,
    "check_out_status": checkOutStatus,
    "user_image": userImage,
    "created_date": createdDate,
  };
}