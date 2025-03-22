import 'dart:async';

import 'package:anti_daydream/Painters/circle_painter.dart';
import 'package:anti_daydream/helpers/app_state_provider.dart';
import 'package:anti_daydream/models/app_state.dart';
import 'package:anti_daydream/models/app_theme.dart';
import 'package:anti_daydream/models/session_settings.dart';
import 'package:anti_daydream/uiElements/buttons.dart';
import 'package:anti_daydream/views/session_screen.dart';
import 'package:anti_daydream/views/session_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AppTheme _appTheme;
  late SessionSettings _sessionSettings;
  bool _isScreenInitialized = false;

  double _sunRotaionAngle = 0;
  late Timer _sunTimer;

  init() {
    if (!_isScreenInitialized) {
      _isScreenInitialized = true;
      _sunTimer = Timer.periodic(const Duration(milliseconds: 25), _rotateSun);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        _appTheme = appState.appTheme;
        _sessionSettings = appState.sessionSettings;
        init();
        return Scaffold(
          backgroundColor: _appTheme.homeScreenBgC,
          body: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(0.8, 1),
                  colors: <Color>[
                    Color.fromARGB(255, 255, 255, 255),
                    Color(0xffffb56b),
                  ], // Gradient from https://learnui.design/tools/gradient-generator.html
                  tileMode: TileMode.mirror,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(child: _buildHeroButton()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: navigateToSessionSettingsScreen,
                        icon: (Icon(Icons.info)),
                        color: Colors.white,
                      ),
                      IconButton(
                        onPressed: navigateToSessionSettingsScreen,
                        icon: (Icon(Icons.help)),
                        color: Colors.white,
                      ),
                      IconButton(
                        onPressed: navigateToSessionSettingsScreen,
                        icon: (Icon(Icons.sunny)),
                        color: Colors.white,
                      ),
                      IconButton(
                        onPressed: navigateToSessionSettingsScreen,
                        icon: (Icon(Icons.settings)),
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Stack _buildHeroButton() {
    return Stack(
      children: [
        SizedBox(
          width: 300,
          height: 300,
          child: CustomPaint(
            painter: CirclePainter(
              _appTheme.homeHeroButtonBgC,
              _appTheme.homeRegularButtonBgC,
              _sunRotaionAngle,
            ),
          ),
        ),
        Container(
          height: 300,
          width: 300,
          padding: const EdgeInsets.all(75),
          child: ElevatedButton(
            onPressed: navigateToSessionScreen,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: _appTheme.homeHeroButtonBgC,
              foregroundColor: _appTheme.homeHeroButtonFgC,
            ),
            child: const Text(
              'Start',
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 25),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _sunTimer.cancel();
    super.dispose();
  }

  _rotateSun(Timer timer) {
    setState(() {
      _sunRotaionAngle += 0.005;
      //print(_sunAnimation.value);
    });
  }

  navigateToSessionScreen() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => AppStateProvider(
      notifier: ValueNotifier<AppState>(AppStateProvider.of(context).value),
      child: SessionScreen(),
    )));
  }

  navigateToSessionSettingsScreen() {
    
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => AppStateProvider(
      notifier: ValueNotifier<AppState>(AppStateProvider.of(context).value),
      child: SessionSettingsScreen(),
    )));
  }
}
