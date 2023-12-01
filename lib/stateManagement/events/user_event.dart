import 'package:equatable/equatable.dart';
import 'package:jendela_dbp/model/userModel.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UserEvent extends Equatable {}

class UserFetch extends UserEvent {
  final List<User>? users;
  UserFetch({this.users});
  @override
  String toString() => 'Fetch';
  @override
  List<Object> get props => [users ?? []];
}

class UserLogIn extends UserEvent {
  final String? username;
  final String? password;
  UserLogIn({this.username, this.password});
  @override
  String toString() => 'UserLogIn';
  @override
  List<Object> get props => [username ?? '', password ?? ''];
}

class UserSignUp extends UserEvent {
  final String? email;
  UserSignUp({this.email});
  @override
  String toString() => 'UserSignUp';
  @override
  List<Object> get props => [email ?? ''];
}

class UserIsLogined extends UserEvent {
  final User? user;
  UserIsLogined({this.user});
  @override
  String toString() => 'UserisLogined';
  @override
  List<Object> get props => [user ?? User()];
}
