import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:singerapp/core/services/local_storage_service.dart';

class BackgroundCubit extends Cubit<File?> {
  final LocalStorageService _localStorageService;

  BackgroundCubit(this._localStorageService) : super(null);

  Future<void> loadBackgroundImage() async {
    final imagePath = await _localStorageService.getBackgroundImagePath();
    if (imagePath != null) {
      emit(File(imagePath));
    } else {
      emit(null);
    }
  }

  Future<void> selectBackgroundImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      await _localStorageService.saveBackgroundImage(imageFile);
      emit(imageFile);
    }
  }
}
