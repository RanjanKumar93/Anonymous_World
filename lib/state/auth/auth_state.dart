part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// The state when the app is checking the user's authentication status
class AuthStateLoading extends AuthState {}

// The state when the user is authenticated (logged in)
class AuthStateAuthenticated extends AuthState {
  final String? userId;

  const AuthStateAuthenticated(this.userId);

  @override
  List<Object?> get props => [userId];
}

// The state when the user is not authenticated (logged out)
class AuthStateLogout extends AuthState {}

class AuthStateError extends AuthState {}

class AuthStateUninitialized extends AuthState {}
