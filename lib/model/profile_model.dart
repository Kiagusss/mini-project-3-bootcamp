import 'package:firebase_auth/firebase_auth.dart';

class Profile {
  final String? displayName;
  final String email;
  String? photoUrl;

  Profile({
    this.displayName,
    required this.email,
    this.photoUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      displayName: json['displayName'],
      email: json['email'],
      photoUrl: json['photoUrl'],
    );
  }

  factory Profile.fromFirebaseUser(User user) {
    return Profile(
      displayName: user.displayName,
      email: user.email!,
      photoUrl: user.photoURL,
    );
  }

  Profile copyWith({
    String? displayName,
    String? email,
    String? photoUrl,
  }) {
    return Profile(
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
