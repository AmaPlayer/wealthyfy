
import 'dart:convert';

CheckOutModel checkOutModelFromJson(String str) => CheckOutModel.fromJson(json.decode(str));

String checkOutModelToJson(CheckOutModel data) => json.encode(data.toJson());

class CheckOutModel {
  bool status;
  String message;

  CheckOutModel({
    required this.status,
    required this.message,
  });

  factory CheckOutModel.fromJson(Map<String, dynamic> json) => CheckOutModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
