

import 'dart:convert';

PassengersData passengersDataFromJson(String str) => PassengersData.fromJson(json.decode(str));

String passengersDataToJson(PassengersData data) => json.encode(data.toJson());

class PassengersData {
  PassengersData({
     this.totalPassengers,
     this.totalPages,
     this.data,
  });

  int totalPassengers;
  int totalPages;
  List<Passenger> data;

  factory PassengersData.fromJson(Map<String, dynamic> json) => PassengersData(
    totalPassengers: json["totalPassengers"],
    totalPages: json["totalPages"],
    data: List<Passenger>.from(json["data"].map((x) => Passenger.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalPassengers": totalPassengers,
    "totalPages": totalPages,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };

}



class Passenger {
  Passenger({
    this.id,
    this.name,
    this.trips,
    this.v,
  });

  String id;
  String name;
  int trips;
  int v;

  factory Passenger.fromJson(Map<String, dynamic> json) =>
      Passenger(
        id: json["_id"],
        name: json["name"],
        trips: json["trips"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() =>
      {
        "_id": id,
        "name": name,
        "trips": trips,
        "__v": v,
      };

  Passenger.fromMapObject(Map<String, dynamic> map) {

    this.name = map['name'];
    this.trips = map['trips'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['name'] = name;
    map['trips'] = trips;


    return map;
  }

}