import 'package:flutter_bloc/flutter_bloc.dart';

// Enum for the button types
// ignore: constant_identifier_names
enum AppearanceButtonType { Light, Dark, System }

// Event class for button press
abstract class AppearanceButtonPressEvent {}

class AppearanceSelectButtonEvent extends AppearanceButtonPressEvent {
  final AppearanceButtonType type;

  AppearanceSelectButtonEvent(this.type);
}

// Bloc for handling the selected state of the SettingButton
class AppearanceBloc extends Bloc<AppearanceButtonPressEvent, AppearanceButtonType> {
  AppearanceBloc() : super(AppearanceButtonType.Light) {
    on<AppearanceSelectButtonEvent>(_onSelectButtonEvent);
  }

  void _onSelectButtonEvent(AppearanceSelectButtonEvent event, Emitter<AppearanceButtonType> emit) {
    emit(event.type);
  }

  Stream<AppearanceButtonType> mapEventToState(AppearanceButtonPressEvent event) async* {
    // Default behavior, if needed
  }
}
