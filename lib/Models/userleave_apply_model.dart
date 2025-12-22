
import 'dart:convert';

UserLeaveApplyModel userLeaveApplyFromJson(String str) => UserLeaveApplyModel.fromJson(json.decode(str));

String userLeaveApplyToJson(UserLeaveApplyModel data) => json.encode(data.toJson());

class UserLeaveApplyModel {
  bool status;
  String message;

  UserLeaveApplyModel({
    required this.status,
    required this.message,
  });

  factory UserLeaveApplyModel.fromJson(Map<String, dynamic> json) => UserLeaveApplyModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
