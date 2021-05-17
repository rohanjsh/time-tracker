import 'package:flutter/cupertino.dart';

class Job {
  Job({@required this.name, @required this.ratePerHour, @required this.id});
  final String name;
  final int ratePerHour;
  final String id;

  //fromMap and toMap in data classes as much as possible

  factory Job.fromMap(Map<String, dynamic> data, String documentID) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final int ratePerHour = data['ratePerHour'];
    return Job(
      name: name,
      ratePerHour: ratePerHour,
      id: documentID,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }
}
