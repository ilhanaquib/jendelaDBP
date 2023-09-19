import 'package:equatable/equatable.dart';
import 'package:jendela_dbp/model/userModel.dart';

abstract class UserState extends Equatable {
  final String? message;
  final User? user;
  final List<User>? users;
  const UserState({this.message, this.user, this.users});

  @override
  List<Object> get props => [message ?? ''];
}

class UserInitial extends UserState {}

class UserError extends UserState {
  final String? message;
  const UserError({this.message}) : super(message: message);
}

class UserSuccess extends UserState {
  final String? message;
  const UserSuccess({this.message}) : super(message: message);
}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User? user;
  final List<User>? users;
  const UserLoaded({this.user, this.users}) : super(user: user, users: users);
}
