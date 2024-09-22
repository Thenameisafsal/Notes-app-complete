import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  final String email;
  final String id;
  const AuthUser(
      {required this.id,
      required this.email,
      required this.isEmailVerified}); // make the parameter required by enclosing in {} and adding required keyword

  factory AuthUser.fromFirebase(User user) {
    return AuthUser(
        email: user.email!,
        isEmailVerified: user.emailVerified,
        id: user.uid); // named parameter only accepted as it is required.
  }
}
