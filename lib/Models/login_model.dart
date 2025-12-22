// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  bool status;
  String message;
  List<Datum> data;

  LoginModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String tblUserId;
  String fullName;
  String email;
  String mobile;
  String userImage;
  String jwtToken;
  String createdDate;
  String designationType;
  dynamic tblOfficeId;

  Datum({
    required this.tblUserId,
    required this.fullName,
    required this.email,
    required this.mobile,
    required this.userImage,
    required this.jwtToken,
    required this.createdDate,
    required this.tblOfficeId,
    required this.designationType,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    tblUserId: json["tbl_user_id"],
    fullName: json["full_name"],
    email: json["email"],
    mobile: json["mobile"],
    userImage: json["user_image"],
    jwtToken: json["jwt_token"],
    createdDate: json["created_date"],
    tblOfficeId: json["tbl_office_id"],
    designationType: json["designation_type"],
  );

  Map<String, dynamic> toJson() => {
    "tbl_user_id": tblUserId,
    "full_name": fullName,
    "email": email,
    "mobile": mobile,
    "user_image": userImage,
    "jwt_token": jwtToken,
    "created_date": createdDate,
    "tbl_office_id": tblOfficeId,
    "designation_type": designationType,
  };
}
