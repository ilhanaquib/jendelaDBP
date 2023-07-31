// bottom_nav_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/model/bottom_nav_model.dart';

// Events
abstract class BottomNavEvent {}

class SelectTabEvent extends BottomNavEvent {
  final int index;

  SelectTabEvent(this.index);
}

// States
abstract class BottomNavState {}

class TabSelectedState extends BottomNavState {
  final int selectedIndex;
  final List<BottomNavModel> bottomNavItems;

  TabSelectedState(this.selectedIndex, this.bottomNavItems);

  TabSelectedState copyWith({int? selectedIndex}) {
    return TabSelectedState(
      selectedIndex ?? this.selectedIndex,
      bottomNavItems,
    );
  }
}

// BLoC
class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super(TabSelectedState(0, BottomNavModel.items)) {
    on<SelectTabEvent>((event, emit) {
      if (state is TabSelectedState) {
        final int selectedIndex = event.index;
        emit(TabSelectedState(
            selectedIndex, (state as TabSelectedState).bottomNavItems));
      }
    });
  }

  Stream<BottomNavState> mapEventToState(BottomNavEvent event) async* {}
}
