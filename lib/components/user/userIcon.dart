import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/stateManagement/blocs/imagePickerBloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserIcon extends StatelessWidget {
  final ImageProvider<Object>? imageProvider; // New parameter

  const UserIcon({Key? key, this.imageProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageBloc, ImageState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () async {
            final imagePicker = ImagePicker();
            final pickedImage =
                await imagePicker.pickImage(source: ImageSource.gallery);

            if (pickedImage != null) {
              final imageFile = File(pickedImage.path);
              context.read<ImageBloc>().add(ImagePickedEvent(imageFile));
            }
          },
          child: CircleAvatar(
            radius: 170,
            backgroundImage:
                imageProvider ?? AssetImage('assets/images/tiadakulitbuku.png'),
          ),
        );
      },
    );
  }
}
