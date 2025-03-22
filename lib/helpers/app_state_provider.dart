import 'package:anti_daydream/models/app_state.dart';
import 'package:flutter/material.dart';

class AppStateProvider extends InheritedNotifier<ValueNotifier<AppState>> {
  const AppStateProvider({super.key, required Widget child, required ValueNotifier<AppState> notifier}) : super(child: child, notifier: notifier);

  static ValueNotifier<AppState> of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppStateProvider>()!.notifier!;
  }
}