import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser{
  final bool isEmailVerified;
  const AuthUser({required this.isEmailVerified}); // make the parameter required by enclosing in {} and adding required keyword

  factory AuthUser.fromFirebase(User user){
    return AuthUser(isEmailVerified: user.emailVerified); // named parameter only accepted as it is required.
  }
}