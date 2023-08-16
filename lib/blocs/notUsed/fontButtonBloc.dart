import 'package:flutter_bloc/flutter_bloc.dart';

// Enum for the button types
// ignore: constant_identifier_names
enum FontButtonType { Small, Normal, Medium}

// Event class for button press
abstract class FontButtonPressEvent {}

class FontSelectButtonEvent extends FontButtonPressEvent {
  final FontButtonType type;

  FontSelectButtonEvent(this.type);
}

// Bloc for handling the selected state of the SettingButton
class FontBloc extends Bloc<FontButtonPressEvent, FontButtonType> {
  FontBloc() : super(FontButtonType.Normal) {
    on<FontSelectButtonEvent>(_onSelectButtonEvent);
  }

  void _onSelectButtonEvent(FontSelectButtonEvent event, Emitter<FontButtonType> emit) {
    emit(event.type);
  }

  Stream<FontButtonType> mapEventToState(FontButtonPressEvent event) async* {
    // Default behavior, if needed
  }
}
