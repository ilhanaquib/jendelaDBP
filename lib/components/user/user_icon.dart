import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:jendela_dbp/stateManagement/blocs/image_picker_bloc.dart';

// ignore: must_be_immutable
class UserIcon extends StatelessWidget {
  final ImageProvider<Object>? imageProvider; // New parameter

  UserIcon({Key? key, this.imageProvider}) : super(key: key);

  ImageBloc imageBloc = ImageBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => imageBloc,
      child: BlocConsumer<ImageBloc, ImageState>(
        bloc: imageBloc,
        listener: (context, state) {},
        builder: (BuildContext context, ImageState state) {
          return GestureDetector(
            onTap: () async {
              final imagePicker = ImagePicker();
              final pickedImage =
                  await imagePicker.pickImage(source: ImageSource.gallery);

              if (pickedImage != null) {
                final imageFile = File(pickedImage.path);
                if (!context.mounted) return;
                context.read<ImageBloc>().add(ImagePickedEvent(imageFile));
              }
            },
            child: CircleAvatar(
              radius: 170,
              backgroundImage:
                  imageProvider ?? const AssetImage('assets/images/logo.png'),
            ),
          );
        },
      ),
    );
  }
}
