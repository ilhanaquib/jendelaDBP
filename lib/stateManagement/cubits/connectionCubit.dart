import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jendela_dbp/stateManagement/states/connectionState.dart' as TheConState;

class ConnectionCubit extends Cubit<TheConState.ConnectionState> {
  ConnectionCubit() : super(TheConState.ConnectionConnecting());
  void checkConnection(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      emit(TheConState.ConnectionConnected());
    } else {
      emit(TheConState.ConnectionNoConnection());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Memerlukan penggunaan internet'),
        duration: Duration(seconds: 3),
      ));
    }
  }
}