import 'package:flutter/material.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jendela_dbp/stateManagement/states/connection_state.dart'
    as the_con_state;

class ConnectionCubit extends Cubit<the_con_state.ConnectionState> {
  ConnectionCubit() : super(the_con_state.ConnectionConnecting());
  void checkConnection(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      emit(the_con_state.ConnectionConnected());
    } else {
      emit(the_con_state.ConnectionNoConnection());
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Memerlukan penggunaan internet'),
        duration: Duration(seconds: 3),
      ));
    }
  }
}
