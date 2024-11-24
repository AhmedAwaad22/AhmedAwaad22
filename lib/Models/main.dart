// To parse this JSON data, do
//
//     final mainOh = mainOhFromJson(jsonString);

import 'dart:convert';

List<MainOh> mainOhFromJson(String str) => List<MainOh>.from(json.decode(str).map((x) => MainOh.fromJson(x)));

String mainOhToJson(List<MainOh> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MainOh {
  MainOh({
    required this.isDriver,
    required this.status,
  });

  String isDriver;
  String status;

  factory MainOh.fromJson(Map<String, dynamic> json) => MainOh(
    isDriver: json["IsDriver"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "IsDriver": isDriver,
    "status": status,
  };
}
