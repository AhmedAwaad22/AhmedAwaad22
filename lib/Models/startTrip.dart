// To parse this JSON data, do
//
//     final startTrip = startTripFromJson(jsonString);

import 'dart:convert';

// List<StartTrip> startTripFromJson(String str) => List<StartTrip>.from(json.decode(str).map((x) => StartTrip.fromJson(x)));
//
// String startTripToJson(List<StartTrip> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StartTripModel {
  StartTripModel({
   required this.status,
  });

  String status;

  factory StartTripModel.fromJson(Map<String, dynamic> json) => StartTripModel(
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
  };
}
