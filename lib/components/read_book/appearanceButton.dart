import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jendela_dbp/stateManagement/blocs/notUsed/appearanceButtonBloc.dart';
import 'settings_buttons.dart';

class AppearanceButtons extends StatelessWidget {
  const AppearanceButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BlocBuilder<AppearanceBloc, AppearanceButtonType>(
          builder: (context, state) => SettingButton(
            icon: Icons.light_mode_rounded,
            label: 'Light',
            isSelected: state == AppearanceButtonType.Light,
            onPressed: () {
              BlocProvider.of<AppearanceBloc>(context).add(
                AppearanceSelectButtonEvent(AppearanceButtonType.Light),
              );
            },
          ),
        ),
        BlocBuilder<AppearanceBloc, AppearanceButtonType>(
          builder: (context, state) => SettingButton(
            icon: Icons.dark_mode_rounded,
            label: 'Dark',
            isSelected: state == AppearanceButtonType.Dark,
            onPressed: () {
              BlocProvider.of<AppearanceBloc>(context)
                  .add(AppearanceSelectButtonEvent(AppearanceButtonType.Dark));
            },
          ),
        ),
        BlocBuilder<AppearanceBloc, AppearanceButtonType>(
          builder: (context, state) => SettingButton(
            icon: Icons.settings_rounded,
            label: 'System',
            isSelected: state == AppearanceButtonType.System,
            onPressed: () {
              BlocProvider.of<AppearanceBloc>(context).add(
                AppearanceSelectButtonEvent(AppearanceButtonType.System),
              );
            },
          ),
        ),
      ],
    );
  }
}
