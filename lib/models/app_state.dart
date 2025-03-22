import 'package:anti_daydream/models/app_theme.dart';
import 'package:anti_daydream/models/session_settings.dart';
import 'package:flutter/material.dart';

class AppState with ChangeNotifier{
  AppTheme appTheme = AppTheme(ThemeOption.classic);
  SessionSettings sessionSettings = SessionSettings(20, 5);

  AppState();
}