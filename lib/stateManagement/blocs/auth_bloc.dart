import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jendela_dbp/controllers/user_repositories.dart';
import 'package:jendela_dbp/model/user_model.dart';
import 'package:jendela_dbp/stateManagement/events/auth_event.dart';
import 'package:jendela_dbp/stateManagement/states/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.userRepository}) : super(const AuthInitial());
  UserRepository userRepository;
  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AuthLogin) {
      // login
      yield const AuthLoading();
      User? user = await userRepository.authenticate(
          username: event.username ?? '', password: event.password ?? '');
      yield AuthLoaded(user: user);
    }
  }
}
