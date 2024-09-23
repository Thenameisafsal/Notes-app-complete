import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:notes/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;
  const AuthState(
      {required this.isLoading, this.loadingText = "Please wait, loading..."});
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required super.isLoading});
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user; // indicates current user
  const AuthStateLoggedIn({required this.user, required super.isLoading});
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required super.isLoading});
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  @override
  final bool isLoading;
  const AuthStateLoggedOut(
      {required this.exception,
      required this.isLoading,
      super.loadingText = null})
      : super(isLoading: isLoading);

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthStateRegistering extends AuthState {
  final Exception? exception; // may or may not be successfu;
  const AuthStateRegistering(
      {required this.exception, required super.isLoading});
}

class AuthStateForgotPassword extends AuthState {
  final Exception? exception;
  final bool emailSent;

  const AuthStateForgotPassword(
      {required super.isLoading,
      required this.exception,
      required this.emailSent});
}
