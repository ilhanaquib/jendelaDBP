import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/blocs/bottomNavBloc.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBloc, BottomNavState>(
      builder: (context, state) {
        if (state is TabSelectedState) {
          return BottomNavigationBar(
            items: state.bottomNavItems
                .map(
                  (item) => BottomNavigationBarItem(
                    icon: Stack(
                      children: [
                        Icon(
                          item.iconData,
                          color: state.selectedIndex ==
                                  state.bottomNavItems.indexOf(item)
                              ? Colors.orange
                              : const Color.fromARGB(255, 123, 123, 123),
                          size: 30,
                        ),
                      ],
                    ),
                    label: item.label,
                  ),
                )
                .toList(),
            currentIndex: state.selectedIndex,
            onTap: (index) {
              // Dispatch the SelectTabEvent to the Bloc
              BlocProvider.of<BottomNavBloc>(context)
                  .add(SelectTabEvent(index));
              _navigateToPage(context, index); // Handle navigation here
            },
            selectedItemColor: Colors.orange,
            unselectedItemColor: const Color.fromARGB(255, 123, 123, 123),
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          );
        }
        return Container();
      },
    );
  }

  void _navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/savedBooks');
        break;
      case 2:
        Navigator.pushNamed(context, '/audiobooks');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }
}
