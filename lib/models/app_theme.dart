import 'package:flutter/material.dart';

enum ThemeOption {classic, dark}

class AppTheme {
  late Color appBarC;

  late Color homeScreenBgC;
  late Color sessionScreenBgC;
  late Color sessionSettingsScreenBgC;
  late Color resultScreenBgC;
  late Color appThemeScreenBgC;
  late Color aboutAppScreenBgC;
  late Color otherThingsScreenBgC;

  late Color pFC;
  late Color sFC;

  late Color sessionEnabledAnimatedBgC;
  late Color sessionDisabledAnimatedBgC;
  late Color sessionCircularProgressBarC;
  late Color sessionEnabledButtonC;
  late Color sessionDisabledButtonC;
  late Color sessionCorrectButtonC;
  late Color sessionWrongButtonC;
  late Color sessionShadowsC;
  late Color sessionControlIconsC;

  late Color homeHeroButtonBgC;
  late Color homeHeroButtonFgC;

  late Color homeRegularButtonBgC;
  late Color sessionSettings_applyBtnBgC;


  AppTheme(ThemeOption themeOption) {
    switch (themeOption) {
      case ThemeOption.classic:
        loadClassicTheme();
        break;
      case ThemeOption.dark:
        loadDarkTheme();
        break;
      default:
        loadClassicTheme();
    }
  }

  loadClassicTheme() {
    Color whiteSmoke = const Color(0xfff4f6ff);
    Color lightGold = const Color(0xfff3c623);
    Color darkGold = const Color(0xffeb8317);
    Color complementryBlue = const Color(0xff10375c);

    appBarC = const Color(0xfff8f32b);

    homeScreenBgC = sessionSettingsScreenBgC = resultScreenBgC = appThemeScreenBgC = aboutAppScreenBgC = otherThingsScreenBgC = whiteSmoke;

    sessionScreenBgC = const Color(0xffc6ccd7);

    pFC = const Color(0xff000000);
    sFC = const Color(0xffffffff);

    sessionEnabledAnimatedBgC = lightGold;
    sessionDisabledAnimatedBgC = const Color(0xffc6ccd7);
    sessionCircularProgressBarC = const Color.fromARGB(255, 140, 144, 151);
    sessionEnabledButtonC = const Color(0xffffffff);
    sessionDisabledButtonC = const Color(0xffe3e6eb);
    sessionCorrectButtonC = Colors.green;
    sessionWrongButtonC = Colors.red;
    sessionShadowsC = const Color(0xff000000);
    sessionControlIconsC = Colors.amber;

    homeHeroButtonBgC = lightGold;
    homeHeroButtonFgC = complementryBlue;
    homeRegularButtonBgC = darkGold;
    sessionSettings_applyBtnBgC = darkGold;
  }

  loadDarkTheme() {
    //TO Do
    loadClassicTheme();
  }
}