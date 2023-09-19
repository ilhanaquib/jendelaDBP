import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jendela_dbp/stateManagement/states/userState.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  void displaySnackBar(BuildContext context, {String? message}) {
    final snackBar = SnackBar(content: Text(message ?? ''));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<bool> update(id, {String? name, String? email}) async {
    try {
      emit(UserLoading());

      emit(UserSuccess(message: 'Saved'));
      return true;
    } catch (error) {
      emit(UserError(message: error.toString()));
      return false;
    }
  }
}
