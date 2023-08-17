import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/model/userModel.dart';
import 'package:jendela_dbp/stateManagement/events/authEvent.dart';
import 'package:jendela_dbp/stateManagement/states/authState.dart';
import 'package:jendela_dbp/userRepositories.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.userRepository}) : super(AuthInitial());
  UserRepository userRepository;
  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AuthLogin) {
      // login
      yield AuthLoading();
      User? user = await userRepository.authenticate(
          username: event.username ?? '', password: event.password ?? '');
      yield AuthLoaded(user: user);
    }
  }
}
