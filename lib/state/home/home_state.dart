part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeStateLoading extends HomeState {}

class HomeStateError extends HomeState {}

class HomeStateLoaded extends HomeState {
  final List<String> users;
  const HomeStateLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class HomeStateInitial extends HomeState {}
