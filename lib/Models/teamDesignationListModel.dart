// To parse this JSON data, do
//
//     final teamDesignationListModel = teamDesignationListModelFromJson(jsonString);

import 'dart:convert';

TeamDesignationListModel teamDesignationListModelFromJson(String str) => TeamDesignationListModel.fromJson(json.decode(str));

String teamDesignationListModelToJson(TeamDesignationListModel data) => json.encode(data.toJson());

class TeamDesignationListModel {
  bool status;
  String message;
  String fullName;
  String userDesignation;
  List<desDatum> data;

  TeamDesignationListModel({
    required this.status,
    required this.message,
    required this.fullName,
    required this.userDesignation,
    required this.data,
  });

  factory TeamDesignationListModel.fromJson(Map<String, dynamic> json) => TeamDesignationListModel(
    status: json["status"],
    message: json["message"],
    fullName: json["full_name"],
    userDesignation: json["user_designation"],
    data: List<desDatum>.from(json["data"].map((x) => desDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "full_name": fullName,
    "user_designation": userDesignation,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class desDatum {
  String tblDesignationId;
  String designationAbbr;
  String designationName;

  desDatum({
    required this.tblDesignationId,
    required this.designationAbbr,
    required this.designationName,
  });

  factory desDatum.fromJson(Map<String, dynamic> json) => desDatum(
    tblDesignationId: json["tbl_designation_id"],
    designationAbbr: json["designation_abbr"],
    designationName: json["designation_name"],
  );

  Map<String, dynamic> toJson() => {
    "tbl_designation_id": tblDesignationId,
    "designation_abbr": designationAbbr,
    "designation_name": designationName,
  };
}
