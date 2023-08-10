import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/blocs/fontButtonBloc.dart';
import 'settings_buttons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FontButtons extends StatelessWidget {
  const FontButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BlocBuilder<FontBloc, FontButtonType>(
          builder: (context, state) => SettingButton(
            icon: FontAwesomeIcons.font,
            label: 'Small',
            isSelected: state == FontButtonType.Small,
            onPressed: () {
              BlocProvider.of<FontBloc>(context).add(
                FontSelectButtonEvent(FontButtonType.Small),
              );
            },
          ),
        ),
        BlocBuilder<FontBloc, FontButtonType>(
          builder: (context, state) => SettingButton(
            icon: FontAwesomeIcons.font,
            label: 'Normal',
            isSelected: state == FontButtonType.Normal,
            onPressed: () {
              BlocProvider.of<FontBloc>(context)
                  .add(FontSelectButtonEvent(FontButtonType.Normal));
            },
          ),
        ),
        BlocBuilder<FontBloc, FontButtonType>(
          builder: (context, state) => SettingButton(
            icon: FontAwesomeIcons.font,
            label: 'Medium',
            isSelected: state == FontButtonType.Medium,
            onPressed: () {
              BlocProvider.of<FontBloc>(context).add(
                FontSelectButtonEvent(FontButtonType.Medium),
              );
            },
          ),
        ),
      ],
    );
  }
}
