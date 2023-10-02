import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/controllers/dbpColor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:jendela_dbp/stateManagement/blocs/imagePickerBloc.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({
    super.key,
    required this.updateAppBar,
  });

  final void Function() updateAppBar;
  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  File? _selectedImage;
  ImageProvider<Object>? _imageProvider;
  bool _isImageSelected = false;
  bool _isSaving = false;

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final imageFile = File(pickedImage.path);
      setState(() {
        _selectedImage = imageFile;
        _imageProvider = FileImage(imageFile);
        _isImageSelected = true;
      });
    }
  }

  Future<void> _saveImage() async {
    if (_selectedImage != null) {
      setState(() {
        _isSaving = true;
      });

      final result = await context.read<ImageBloc>().saveImage(_selectedImage!);

      setState(() {
        _isSaving = false;
      });

      if (result.success) {
        context.read<ImageBloc>().updateSelectedImage(_selectedImage!);

        // Call the updateAppBar callback to notify the parent widget
        widget.updateAppBar();

        Navigator.of(context).pop(); // Go back to the home screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.errorMessage!)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Upload Photo,',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  Text(
                    'User',
                    style: TextStyle(
                      fontSize: 20,
                      color: DbpColor().jendelaGray,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Center(
            child: BlocBuilder<ImageBloc, ImageState>(
              builder: (context, state) {
                return Center(
                  child: GestureDetector(
                    onTap: () async {
                      await _pickImage();
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 170,
                          backgroundImage: _imageProvider ??
                              context.watch<ImageBloc>().selectedImageProvider,
                        ),
                        if (_isSaving)
                          LoadingAnimationWidget.discreteCircle(
                            color: DbpColor().jendelaGray,
                            secondRingColor: DbpColor().jendelaGreen,
                            thirdRingColor: DbpColor().jendelaOrange,
                            size: 50.0,
                          ) // Show this when saving
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 170),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: _saveImage,
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side:  BorderSide(
                              color: DbpColor().jendelaOrange,),
                          backgroundColor:
                              DbpColor().jendelaOrange,
                          minimumSize: const Size.fromHeight(40)),
                      child: const Text('Save'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                          foregroundColor:
                              DbpColor().jendelaGray,
                          side: const BorderSide(
                              color: Color.fromARGB(255, 206, 206, 206)),
                          backgroundColor:
                              const Color.fromARGB(255, 206, 206, 206),
                          minimumSize: const Size.fromHeight(40)),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
