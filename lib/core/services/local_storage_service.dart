import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _backgroundImageKey = 'backgroundImagePath';

  Future<String?> getBackgroundImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_backgroundImageKey);
  }

  Future<void> saveBackgroundImage(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final savedImagePath =
        '${directory.path}/${imageFile.path.split('/').last}';
    final savedImage = await imageFile.copy(savedImagePath);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_backgroundImageKey, savedImage.path);
  }
}
