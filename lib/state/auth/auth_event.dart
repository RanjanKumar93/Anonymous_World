part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// Event triggered to check the current auth state
class AuthEventCheck extends AuthEvent {}

// Event triggered when a user logs in
class AuthEventLogin extends AuthEvent {}

// Event triggered when a user logs out
class AuthEventLogout extends AuthEvent {}
