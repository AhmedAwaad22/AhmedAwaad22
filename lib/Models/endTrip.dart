// To parse this JSON data, do
//
//     final endTrip = endTripFromJson(jsonString);

import 'dart:convert';

List<EndTrip> endTripFromJson(String str) => List<EndTrip>.from(json.decode(str).map((x) => EndTrip.fromJson(x)));

String endTripToJson(List<EndTrip> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EndTrip {
    EndTrip({
       required this.status,
    });

    String status;

    factory EndTrip.fromJson(Map<String, dynamic> json) => EndTrip(
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
    };
}
