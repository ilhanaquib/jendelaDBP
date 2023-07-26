import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jendela_dbp/blocs/bottom_nav_bloc.dart';
import 'package:jendela_dbp/view/home.dart';
import 'package:jendela_dbp/view/profile.dart';
import 'package:jendela_dbp/view/saved_books.dart';

import 'audiobooks.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({Key? key}) : super(key: key);

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
                          size: 40,
                        ),
                      ],
                    ),
                    label: item.label,
                  ),
                )
                .toList(),
            currentIndex: state.selectedIndex,
            onTap: (index) {
              BlocProvider.of<BottomNavBloc>(context)
                  .add(SelectTabEvent(index));
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
}
