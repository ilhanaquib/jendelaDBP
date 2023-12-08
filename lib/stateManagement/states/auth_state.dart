import 'package:equatable/equatable.dart';
import 'package:jendela_dbp/model/user_model.dart';

// part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState(
      {this.message,
      this.user,
      this.hideNavigationBar = false,
      this.isAuthenticated = false})
      : super();
  final String? message;
  final User? user;
  final bool? hideNavigationBar;
  final bool? isAuthenticated;
  @override
  List<Object> get props => [message ?? '', user ?? ''];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoaded extends AuthState {
  final User? user;
  final String? message;
  final bool? hideNavigationBar;
  final bool? isAuthenticated;
  const AuthLoaded(
      {this.message,
      this.user,
      this.hideNavigationBar = false,
      this.isAuthenticated = false})
      : super(
            user: user,
            message: message,
            hideNavigationBar: hideNavigationBar,
            isAuthenticated: isAuthenticated);
}

class AuthLoading extends AuthState {
  final User? user;
  final String? message;
  final bool? hideNavigationBar;
  final bool? isAuthenticated;
  const AuthLoading(
      {this.hideNavigationBar,
      this.user,
      this.message,
      this.isAuthenticated = false})
      : super(
            message: message,
            hideNavigationBar: hideNavigationBar,
            user: user,
            isAuthenticated: isAuthenticated);
}

class AuthError extends AuthState {
  final User? user;
  final String? message;
  final bool? hideNavigationBar;
  final bool? isAuthenticated;
  const AuthError(
      {this.hideNavigationBar, this.user, this.message, this.isAuthenticated})
      : super(
            message: message,
            hideNavigationBar: hideNavigationBar,
            user: user,
            isAuthenticated: isAuthenticated);
}
