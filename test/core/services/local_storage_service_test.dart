import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:singerapp/core/services/local_storage_service.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockFile extends Mock implements File {}

class MockPathProviderPlatform extends Mock implements PathProviderPlatform {}

void main() {
  late LocalStorageService localStorageService;
  late MockFile mockFile;
  late MockPathProviderPlatform mockPathProvider;

  setUp(() {
    localStorageService = LocalStorageService();
    mockFile = MockFile();
    mockPathProvider = MockPathProviderPlatform();

    PathProviderPlatform.instance = mockPathProvider;
  });

  group('LocalStorageService', () {
    test('getBackgroundImagePath retorna caminho salvo', () async {
      const imagePath = '/mocked/path/to/image.jpg';
      SharedPreferences.setMockInitialValues({
        'backgroundImagePath': imagePath,
      });

      final result = await localStorageService.getBackgroundImagePath();

      expect(result, imagePath);
    });

    test('getBackgroundImagePath retorna nulo se nenhum caminho foi salvo',
        () async {
      SharedPreferences.setMockInitialValues({});

      final result = await localStorageService.getBackgroundImagePath();

      expect(result, isNull);
    });

    test('saveBackgroundImage salva caminho de imagem no SharedPreferences',
        () async {
      final directory = Directory('/mocked/app/documents');
      const mockFileName = 'image.jpg';
      const mockFilePath = '/mocked/path/$mockFileName';
      final savedImagePath = '${directory.path}/$mockFileName';

      when(mockFile.path).thenReturn(mockFilePath);

      await localStorageService.saveBackgroundImage(mockFile);

      verify(mockFile.copy(savedImagePath)).called(1);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('backgroundImagePath'), savedImagePath);
    });
  });
}
