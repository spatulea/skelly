import 'package:flutter/material.dart';

import 'package:skelly/src/settings/settings_service.dart';

class MockSettingsService with SettingsService {
  ThemeMode _themeMode = ThemeMode.system;

  /// Fake loading from some external storage.
  @override
  Future<ThemeMode> themeMode() async => _themeMode;

  // Fake writing to some external storage
  @override
  Future<void> updateThemeMode(ThemeMode theme) async {
    _themeMode = theme;
  }
}
