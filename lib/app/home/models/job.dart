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
    if (name == null) {
      return null;
    }
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

  //added when testing model classes
  //using code generation to automatic generate these below values
  @override
  // TODO: implement hashCode
  int get hashCode => hashValues(id, name, ratePerHour);

  //equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Job otherJob = other;
    return id == otherJob.id &&
        ratePerHour == otherJob.ratePerHour &&
        name == otherJob.name;
  }

  //always implement
  @override
  String toString() => 'id: $id, name: $name, ratePerHour: $ratePerHour';
}
