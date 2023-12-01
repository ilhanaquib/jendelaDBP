import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

// Event
abstract class ImageEvent {}

class ImagePickedEvent extends ImageEvent {
  final File selectedImage;

  ImagePickedEvent(this.selectedImage);
}

class ImageSaveEvent extends ImageEvent {
  final File selectedImage;

  ImageSaveEvent(this.selectedImage);
}

// State
class ImageState {
  final ImageProvider<Object>? imageProvider;

  ImageState(this.imageProvider);
}

class ImageSaveResult {
  final bool success;
  final String? errorMessage;

  ImageSaveResult(this.success, this.errorMessage);
}

// Bloc
class ImageBloc extends Bloc<ImageEvent, ImageState> {
  File? selectedImage; // Store the selected image
  ImageProvider<Object>? selectedImageProvider;

  void updateSelectedImage(File imageFile) {
    selectedImage = imageFile;
    if (selectedImage != null) {
      selectedImageProvider = FileImage(selectedImage!);
    }
  }

  ImageBloc() : super(ImageState(null)) {
    on<ImagePickedEvent>((event, emit) {
      emit(ImageState(FileImage(event.selectedImage)));
    });
  }

  Future<ImageSaveResult> saveImage(File selectedImage) async {
    try {
      // Simulate saving logic
      // Replace this with your actual saving logic
      await Future.delayed(const Duration(seconds: 2));

      // Return success
      return ImageSaveResult(true, null);
    } catch (e) {
      // Return error with error message
      return ImageSaveResult(false, 'Failed to save image');
    }
  }

  void setImageProvider(ImageProvider<Object>? imageProvider) {
    // ignore: invalid_use_of_visible_for_testing_member
    emit(ImageState(imageProvider));
  }

  late void Function() updateAppBar = () {};

  @override
  Stream<ImageState> mapEventToState(ImageEvent event) async* {}
}
