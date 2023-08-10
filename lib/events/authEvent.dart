import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:jendela_dbp/model/userModel.dart';

@immutable
abstract class AuthEvent extends Equatable {}

class AuthFetch extends AuthEvent {
  final User? user;
  AuthFetch({this.user});
  @override
  String toString() => 'Fetch Auth User';
  @override
  List<Object> get props => [user ?? User()];
}

class AuthLogin extends AuthEvent {
  final String? username;
  final String? password;
  AuthLogin({this.username, this.password});
  @override
  String toString() => 'Auth Login';
  @override
  List<Object> get props => [username ?? '', password ?? ''];
}