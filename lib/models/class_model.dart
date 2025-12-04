class ClassModel {
  final String id;
  final String name;
  final String description;
  final String instructor;
  final DateTime time;
  final int capacity;
  final List<String> attendees;

  ClassModel({
    required this.id,
    required this.name,
    required this.description,
    required this.instructor,
    required this.time,
    required this.capacity,
    List<String>? attendees,
  }) : attendees = attendees ?? [];

  // Convert ClassModel -> Firestore map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'instructor': instructor,
      'time': time.toIso8601String(),
      'capacity': capacity,
      'attendees': attendees,
    };
  }

  // Convert Firestore map -> ClassModel
  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      instructor: map['instructor'] ?? '',
      time: DateTime.parse(map['time'] ?? DateTime.now().toIso8601String()),
      capacity: map['capacity'] ?? 0,
      attendees: List<String>.from(map['attendees'] ?? []),
    );
  }
}
