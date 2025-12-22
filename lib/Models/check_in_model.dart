
import 'dart:convert';

CheckInModel checkInModelFromJson(String str) => CheckInModel.fromJson(json.decode(str));

String checkInModelToJson(CheckInModel data) => json.encode(data.toJson());

class CheckInModel {
  bool status;
  String message;

  CheckInModel({
    required this.status,
    required this.message,
  });

  factory CheckInModel.fromJson(Map<String, dynamic> json) => CheckInModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
