




// To parse this JSON data, do
//
//     final myProfileModel = myProfileModelFromJson(jsonString);

import 'dart:convert';

MyProfileModel myProfileModelFromJson(String str) => MyProfileModel.fromJson(json.decode(str));

String myProfileModelToJson(MyProfileModel data) => json.encode(data.toJson());

class MyProfileModel {
  bool status;
  String message;
  List<MyProfileDatum> data;

  MyProfileModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MyProfileModel.fromJson(Map<String, dynamic> json) => MyProfileModel(
    status: json["status"],
    message: json["message"],
    data: List<MyProfileDatum>.from(json["data"].map((x) => MyProfileDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class MyProfileDatum {
  String tblUserId;
  String officeName;
  String designationName;
  String fullName;
  String email;
  String mobile;
  String userImage;
  String jwtToken;
  String createdDate;
  String checkInStatus;
  String checkOutStatus;
  String IsMdVpBm;

  MyProfileDatum({
    required this.tblUserId,
    required this.officeName,
    required this.designationName,
    required this.fullName,
    required this.email,
    required this.mobile,
    required this.userImage,
    required this.jwtToken,
    required this.createdDate,
    required this.checkInStatus,
    required this.checkOutStatus,
    required this.IsMdVpBm,
  });

  factory MyProfileDatum.fromJson(Map<String, dynamic> json) => MyProfileDatum(
    tblUserId: json["tbl_user_id"],
    officeName: json["office_name"],
    designationName: json["designation_name"],
    fullName: json["full_name"],
    email: json["email"],
    mobile: json["mobile"],
    userImage: json["user_image"],
    jwtToken: json["jwt_token"],
    createdDate: json["created_date"],
    checkInStatus: json["check_in_status"],
    checkOutStatus: json["check_out_status"],
    IsMdVpBm: json["Is_md_vp_bm"],

  );

  Map<String, dynamic> toJson() => {
    "tbl_user_id": tblUserId,
    "office_name": officeName,
    "designation_name": designationName,
    "full_name": fullName,
    "email": email,
    "mobile": mobile,
    "user_image": userImage,
    "jwt_token": jwtToken,
    "created_date": createdDate,
    "check_in_status": checkInStatus,
    "check_out_status": checkOutStatus,
    "Is_md_vp_bm": IsMdVpBm,
  };
}



// ye meri MyProfileModel hai
