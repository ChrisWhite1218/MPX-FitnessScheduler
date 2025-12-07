import 'package:cloud_firestore/cloud_firestore.dart';

class ClassModel {
  final String id;
  final String name;
  final String description;
  final String instructor;
  final DateTime time;
  final int capacity;
  final int points;
  final List<String> attendees;

  ClassModel({
    required this.id,
    required this.name,
    required this.description,
    required this.instructor,
    required this.time,
    required this.capacity,
    this.points = 0,
    List<String>? attendees,
  }) : attendees = attendees ?? [];

  factory ClassModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return ClassModel(
      id: docId ?? map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      instructor: map['instructor'] ?? '',
      time: (map['time'] as Timestamp?)?.toDate() ?? DateTime.now(),
      capacity: map['capacity'] ?? 0,
      attendees: List<String>.from(map['attendees'] ?? []),
      points: map['points'] ?? 0,
    );
  }



  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'instructor': instructor,
      'time': Timestamp.fromDate(time),
      'capacity': capacity,
      'points': points,
      'attendees': attendees,
    };
  }
}
