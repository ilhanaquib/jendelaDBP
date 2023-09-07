import 'package:equatable/equatable.dart';

abstract class ConnectionState extends Equatable {
  ConnectionState();

  ConnectionConnected copyWith({List? props}) {
    return ConnectionConnected();
  }
}

class ConnectionConnected extends ConnectionState {
  List props = [];

  ConnectionConnected() : super();

  @override
  ConnectionConnected copyWith({List? props}) {
    return ConnectionConnected();
  }
}

class ConnectionConnecting extends ConnectionState {
  List props = [];

  ConnectionConnecting() : super();
}

class ConnectionNoConnection extends ConnectionState {
  List props = [];

  ConnectionNoConnection() : super();
}
