// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

abstract class ConnectionState extends Equatable {
  const ConnectionState();

  ConnectionConnected copyWith({List? props}) {
    return ConnectionConnected();
  }
}
class ConnectionConnected extends ConnectionState {
  @override
  List props = [];

  ConnectionConnected() : super();

  @override
  ConnectionConnected copyWith({List? props}) {
    return ConnectionConnected();
  }
}

class ConnectionConnecting extends ConnectionState {
  @override
  List props = [];

  ConnectionConnecting() : super();
}

class ConnectionNoConnection extends ConnectionState {
  @override
  List props = [];

  ConnectionNoConnection() : super();
}
