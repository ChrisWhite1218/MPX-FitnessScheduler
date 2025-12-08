class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final int points;
  final List<String> signedUpClasses;
  final List<String> attendedClasses;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.points = 0,
    List<String>? signedUpClasses,
    List<String>? attendedClasses,
  })  : signedUpClasses = signedUpClasses ?? [],
        attendedClasses = attendedClasses ?? [];

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'points': points,
      'signedUpClasses': signedUpClasses,
      'attendedClasses': attendedClasses,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      points: map['points'] ?? 0,
      signedUpClasses: List<String>.from(map['signedUpClasses'] ?? []),
      attendedClasses: List<String>.from(map['attendedClasses'] ?? []),
    );
  }
}
