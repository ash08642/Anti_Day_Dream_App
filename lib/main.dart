import 'package:anti_daydream/helpers/app_state_provider.dart';
import 'package:anti_daydream/views/session_screen.dart';

import 'models/app_state.dart';
import 'views/home_screen.dart';
import 'views/session_results_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const AntiDayDreamApp(),
    ),
  );
}

class AntiDayDreamApp extends StatelessWidget {
  const AntiDayDreamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'ChakraPetch'),
      home: AppStateProvider(
        notifier: ValueNotifier<AppState>(AppState()),
        child: const SessionResultsScreen(total: 4, correct: 2,))
    );
  }
}