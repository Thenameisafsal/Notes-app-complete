import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser{
  final bool isEmailVerified;
  final String? email;
  const AuthUser({required this.email, required this.isEmailVerified}); // make the parameter required by enclosing in {} and adding required keyword

  factory AuthUser.fromFirebase(User user){
    return AuthUser(email: user.email, isEmailVerified: user.emailVerified); // named parameter only accepted as it is required.
  }
}