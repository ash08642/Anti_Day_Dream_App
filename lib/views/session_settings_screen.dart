import 'package:anti_daydream/helpers/app_state_provider.dart';
import 'package:anti_daydream/models/app_state.dart';
import 'package:anti_daydream/models/app_theme.dart';
import 'package:anti_daydream/models/session_settings.dart';
import 'package:anti_daydream/uiElements/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SessionSettingsScreen extends StatefulWidget {
  const SessionSettingsScreen({super.key});

  @override
  State<SessionSettingsScreen> createState() => _SessionSettingsScreenState();
}

class _SessionSettingsScreenState extends State<SessionSettingsScreen> {
  AppState appState = AppState();
  bool _isScreenInitialized = false;

  final _sessionDurationMinsController = TextEditingController();
  final _sessionDurationSecsController = TextEditingController();
  final _pauseIntervalMinsController = TextEditingController();
  final _pauseIntervalSecsController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  init() {
    if (!_isScreenInitialized) {
      _isScreenInitialized = true;

      setState(() {
        _sessionDurationMinsController.text =
          (appState.sessionSettings.sessionDuration / 60).floor().toString();
        _sessionDurationSecsController.text =
            (appState.sessionSettings.sessionDuration % 60).toString();
        _pauseIntervalMinsController.text =
            (appState.sessionSettings.pauseInterval / 60).floor().toString();
        _pauseIntervalSecsController.text =
            (appState.sessionSettings.pauseInterval % 60).toString();
      });
      
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ValueNotifier<AppState> appStateNotifier = AppStateProvider.of(context);
      appState = appStateNotifier.value;
      init();
    });
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<AppState> appStateNotifier = AppStateProvider.of(context);
    appState = appStateNotifier.value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appState.appTheme.homeHeroButtonBgC,
        foregroundColor: appState.appTheme.homeHeroButtonFgC,
        title: const Row(
          children: [
            Icon(Icons.settings_outlined),
            SizedBox(width: 10),
            Text('Session Settings'),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: appState.appTheme.sessionSettingsScreenBgC,
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        color: appState.appTheme.homeRegularButtonBgC,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Session Duration',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: appState.appTheme.homeHeroButtonFgC,
                        ),
                      ),
                    ],
                  ),
                  _buildTimeInputForm(
                    _sessionDurationMinsController,
                    _sessionDurationSecsController,
                  ),
                ],
              ),
              Divider(
                thickness: 0.5,
                color: appState.appTheme.homeHeroButtonFgC,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.timelapse_outlined,
                        color: appState.appTheme.homeRegularButtonBgC,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Pause Duration',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: appState.appTheme.homeHeroButtonFgC,
                        ),
                      ),
                    ],
                  ),
                  _buildTimeInputForm(
                    _pauseIntervalMinsController,
                    _pauseIntervalSecsController,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  uiIconTextButton(
                    Icons.check,
                    'Apply',
                    () => _validate(appState),
                    appState.appTheme.sFC,
                    appState.appTheme.homeHeroButtonFgC,
                  ),
                  const SizedBox(width: 50),
                  uiIconTextButton(
                    Icons.undo,
                    'Reset',
                    () {},
                    appState.appTheme.homeHeroButtonFgC,
                    appState.appTheme.homeHeroButtonBgC,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _sessionDurationMinsController.dispose();
    _sessionDurationSecsController.dispose();
    _pauseIntervalMinsController.dispose();
    _pauseIntervalSecsController.dispose();
    super.dispose();
  }

  Widget _buildTextFormField(TextEditingController controller) {
    return SizedBox(
      width: 40,
      height: 40,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ],
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          errorStyle: TextStyle(height: 0.01, fontSize: 0),
        ),
        validator: (text) {
          if (text!.isEmpty) {
            return '';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildTimeInputForm(
    TextEditingController minutesController,
    TextEditingController secondsController,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildTextFormField(minutesController),
        Text(
          ' mins,  ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: appState.appTheme.homeHeroButtonFgC,
          ),
        ),
        _buildTextFormField(secondsController),
        Text(
          ' secs',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: appState.appTheme.homeHeroButtonFgC,
          ),
        ),
      ],
    );
  }

  _validate(AppState appState) {
    final form = _formKey.currentState;
    if (!(form?.validate() ?? false)) {
      print('validation failed');
      return;
    }
    int sessionDuration =
        int.parse(_sessionDurationMinsController.text) * 60 +
        int.parse(_sessionDurationSecsController.text);
    int interval =
        int.parse(_pauseIntervalMinsController.text) * 60 +
        int.parse(_pauseIntervalSecsController.text);
    appState.sessionSettings.sessionDuration = sessionDuration;
    appState.sessionSettings.pauseInterval = interval;
    print('validation succesful');
    navigateToHomeScreen();
  }

  navigateToHomeScreen() {
    Navigator.pop(context);
  }
}
