// To parse this JSON data, do
//
//     final busListDriver = busListDriverFromJson(jsonString);

import 'dart:convert';

List<BusListDriver> busListDriverFromJson(String str) => List<BusListDriver>.from(json.decode(str).map((x) => BusListDriver.fromJson(x)));

String busListDriverToJson(List<BusListDriver> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BusListDriver {
  BusListDriver({
   required this.isDriver,
    required this.userName,
    required this.userType,
    required this.tripStatus,
    required this.startStatus,
    required this.userCampus,
    required this.busId,
    required this.data_name,
  });

  String isDriver;
  String userName;
  String userType;
  String tripStatus;
  String startStatus;
  String userCampus;
  String busId;
  List<Datum> data_name;

  factory BusListDriver.fromJson(Map<String, dynamic> json) => BusListDriver(
    isDriver: json["IsDriver"],
    userName: json["user_name"],
    userType: json["user_type"],
    tripStatus: json["Trip_Status"],
    startStatus: json["Start_Status"],
    userCampus: json["user_campus"],
    busId: json["Bus_Id"],
    data_name: List<Datum>.from(json["Data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "IsDriver": isDriver,
    "user_name": userName,
    "user_type": userType,
    "Trip_Status": tripStatus,
    "Start_Status": startStatus,
    "user_campus": userCampus,
    "Bus_Id": busId,
    "Data": List<dynamic>.from(data_name.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.id,
    required  this.studName,
    required this.studId,
    required this.username,
    required this.seats,
    required this.pickPoint,
    required this.ticketNo,
    required this.status,
  });

  String id;
  String studName;
  String studId;
  String username;
  String seats;
  String pickPoint;
  String ticketNo;
  String status;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    studName: json["Stud_name"],
    studId: json["Stud_id"],
    username: json["username"],
    seats: json["seats"],
    pickPoint: json["pick_point"],
    ticketNo: json["ticket_no"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "Stud_name": studName,
    "Stud_id": studId,
    "username": username,
    "seats": seats,
    "pick_point": pickPoint,
    "ticket_no": ticketNo,
    "status": status,
  };
}
