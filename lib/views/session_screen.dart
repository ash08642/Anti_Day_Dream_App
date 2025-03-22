import 'dart:async';

import 'package:anti_daydream/helpers/app_state_provider.dart';
import 'package:anti_daydream/helpers/question_generator.dart';
import 'package:anti_daydream/helpers/session_button_params.dart';
import 'package:anti_daydream/models/app_state.dart';
import 'package:anti_daydream/models/app_theme.dart';
import 'package:anti_daydream/models/session_settings.dart';
import 'package:anti_daydream/uiElements/buttons.dart';
import 'package:anti_daydream/views/home_screen.dart';
import 'package:anti_daydream/views/session_results_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen>
    with TickerProviderStateMixin {
  double _size = 1920;
  int wrongOtionId = -1;
  final double tickIntervalS = 0.025;
  double currentTime = 0;
  late Timer _questionTimer;
  bool _isQuestionTimerRunning = false;
  late int _sessionDuration;
  late int _remainingSeconds;
  late int _remainingMinutes;
  late Timer _sessionTimer;
  bool _isSessionStarted = false;
  int correct = 0;
  int total = 0;

  final String _message =
      "Click the Question Button only if you regain your Focus after loosing it";
  bool _hasSnackBarOpened = false;

  late Color _animatedOptionButtonColor;
  late Color _animatedBackgroundBox;
  bool _isScreenInitialized = false;

  final QuestionGenerator _qg = QuestionGenerator();
  bool _isQuestionActive = true;
  late final SessionButtonsList _sbl;

  late AnimationController _enableController;
  late AnimationController _disableController;
  late Animation<Color?> _optionButtonEnableAnimation;
  late Animation<Color?> _correctOptionButtonDisableAnimation;
  late Animation<Color?> _wrongOptionButtonDisableAnimation;
  late Animation<Color?> _normalOptionButtonDisableAnimation;

  AppState appState = AppState();

  @override
  Widget build(BuildContext context) {
    initColors();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appState.appTheme.sessionScreenBgC,
      body: Stack(
        children: [
          _buildAnimationPanel(),
          _buildOptionsPanel(),
          _buildQuestionPanel(),
          _buildControlBar(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _enableController.dispose();
    _disableController.dispose();
    if (_isSessionStarted) {
      _questionTimer.cancel();
      _sessionTimer.cancel();
    }
    super.dispose();
  }

  Column _buildControlBar() {
    return Column(
      children: [
        const Expanded(child: SizedBox()),
        Row(
          children: [
            const Expanded(child: SizedBox()),
            Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.elliptical(40, 80),
                    ),
                    color: _animatedBackgroundBox,
                  ),
                  padding: const EdgeInsets.only(
                    left: 5,
                    right: 5,
                    bottom: 10,
                    top: 5,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.elliptical(40, 80),
                      ),
                      color: _animatedOptionButtonColor,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 10),
                        const Icon(Icons.timer_outlined),
                        const SizedBox(width: 5),
                        Text(_remainingSessionTime),
                        const SizedBox(width: 10),
                        uiIconButton(Icons.pause_circle, navigateToHomeScreen),
                        uiIconButton(Icons.play_circle, navigateToHomeScreen),
                        uiIconButton(Icons.stop_circle, navigateToHomeScreen),
                        const SizedBox(width: 5),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }

  Center _buildAnimationPanel() {
    return Center(
      child: AnimatedContainer(
        width: _size,
        height: _size,
        duration: const Duration(milliseconds: 500),
        color: _animatedBackgroundBox,
      ),
    );
  }

  Center _buildQuestionPanel() {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        height: 180,
        decoration: BoxDecoration(
          color: _animatedBackgroundBox,
          shape: BoxShape.circle,
        ),
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                height: 170,
                width: 170,
                child: CircularProgressIndicator(
                  value: currentTime / appState.sessionSettings.pauseInterval,
                  semanticsLabel: 'Circular',
                  strokeWidth: 10,
                  color: appState.appTheme.sessionCircularProgressBarC,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (!_hasSnackBarOpened && !_isQuestionActive) {
                  _hasSnackBarOpened = true;
                  buildSnackBar();
                }
                activateQuestion();
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  decoration: BoxDecoration(
                    color: _animatedOptionButtonColor,
                    shape: BoxShape.circle,
                    boxShadow:
                        _isQuestionActive
                            ? null
                            : [
                              BoxShadow(
                                spreadRadius: 1,
                                blurRadius: 2,
                                color: appState.appTheme.sessionShadowsC,
                              ),
                            ],
                  ),
                  child: Center(
                    child: Text(
                      (_isQuestionActive || wrongOtionId != -1)
                          ? _qg.question
                          : '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _buildOptionsPanel() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            flex: 1,
            child: Column(
              children: [
                Flexible(
                  flex: 1,
                  child: _buildOptionButton(_sbl.sessionButtonList[0], 3),
                ),
                Flexible(
                  flex: 1,
                  child: _buildOptionButton(_sbl.sessionButtonList[1], 2),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Column(
              children: [
                Flexible(
                  flex: 1,
                  child: _buildOptionButton(_sbl.sessionButtonList[2], 0),
                ),
                Flexible(
                  flex: 1,
                  child: _buildOptionButton(_sbl.sessionButtonList[3], 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector _buildOptionButton(
    SessionButtonParams sbp,
    int radiusDirection,
  ) {
    return GestureDetector(
      onTap:
          !_isQuestionActive
              ? null
              : () {
                if (sbp.isOptionCorrect) {
                  _sbl.onCorrectButtonPressed(sbp.buttonId);
                  wrongOtionId = -1;
                  correct++; total++;
                } else {
                  wrongOtionId = _qg.solutionIndex;
                  _sbl.onWrongButtonPressed(sbp.buttonId, _qg.solutionIndex);
                  total++;
                }
                disableQuesion();
              },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          borderRadius: getBorderRadius(radiusDirection),
          color: sbp.buttonColor,
          boxShadow:
              !_isQuestionActive
                  ? null
                  : [
                    BoxShadow(
                      spreadRadius: 2,
                      blurRadius: 4,
                      color: appState.appTheme.sessionShadowsC,
                    ),
                  ],
        ),
        margin: const EdgeInsets.all(10),
        child: Center(
          child: (_isQuestionActive || wrongOtionId == sbp.buttonId)
                ? sbp.buttonValue
                : SizedBox(width: 0, height: 0,),
        ),
      ),
    );
  }

  BorderRadius getBorderRadius(int radiusDirection) {
    switch (radiusDirection) {
      case 0:
        return const BorderRadius.only(topRight: Radius.circular(20));
      case 1:
        return const BorderRadius.only(bottomRight: Radius.circular(20));
      case 2:
        return const BorderRadius.only(bottomLeft: Radius.circular(20));
      case 3:
        return const BorderRadius.only(topLeft: Radius.circular(20));
      default:
        return const BorderRadius.all(Radius.zero);
    }
  }

  animate(bool state) {
    setState(() {
      if (state) {
        _size = 1920;
        _animatedOptionButtonColor = appState.appTheme.sessionEnabledButtonC;
        _animatedBackgroundBox = appState.appTheme.sessionEnabledAnimatedBgC;
        _isQuestionActive = true;
      } else {
        _size = 50;
        _animatedOptionButtonColor = appState.appTheme.sessionDisabledButtonC;
        _animatedBackgroundBox = appState.appTheme.sessionDisabledAnimatedBgC;
        _isQuestionActive = false;
      }
    });
  }

  activateQuestion() {
    if (!_isQuestionActive) {
      _qg.generateNewQuestion();
      _sbl.assingValues(_qg.options, _qg.solutionIndex);
      _stopTimer();
      animate(true);
      _enableController.reset();
      _enableController.forward();
    }
  }

  disableQuesion() {
    if (_isQuestionActive) {
      animate(false);
      _startTimer();
      _startSession();
      _disableController.reset();
      _disableController.forward();
    }
  }

  setAllButtonColor(Color color) {
    setState(() {
      _sbl.setAllColor(color);
    });
  }

  void disableButtons() {
    setState(() {
      for (var i = 0; i < _sbl.sessionButtonList.length; i++) {
        if (_sbl.sessionButtonList[i].buttonState == ButtonState.normal) {
          _sbl.sessionButtonList[i].buttonColor =
              _normalOptionButtonDisableAnimation.value!;
        } else if (_sbl.sessionButtonList[i].buttonState ==
            ButtonState.correct) {
          _sbl.sessionButtonList[i].buttonColor =
              _correctOptionButtonDisableAnimation.value!;
        } else if (_sbl.sessionButtonList[i].buttonState == ButtonState.wrong) {
          _sbl.sessionButtonList[i].buttonColor =
              _wrongOptionButtonDisableAnimation.value!;
        } else if (_sbl.sessionButtonList[i].buttonState ==
            ButtonState.correctButNotSelected) {
          _sbl.sessionButtonList[i].buttonColor =
              _correctOptionButtonDisableAnimation.value!;
        }
      }
    });
  }

  void _updateCircularProgressIndicator(Timer time) {
    setState(() {
      currentTime += tickIntervalS;
    });
    if (currentTime > appState.sessionSettings.pauseInterval) {
      _stopTimer();
      activateQuestion();
    }
  }

  void _startTimer() {
    if (_isQuestionTimerRunning) {
      _stopTimer();
    }
    setState(() {
      currentTime = 0;
      _isQuestionTimerRunning = true;
    });
    _questionTimer = Timer.periodic(
      Duration(milliseconds: (tickIntervalS * 1000).floor()),
      _updateCircularProgressIndicator,
    );
  }

  void _stopTimer() {
    setState(() {
      currentTime = 0;
      _isQuestionTimerRunning = false;
    });
    _questionTimer.cancel();
  }

  void _startSession() {
    if (!_isSessionStarted) {
      _isSessionStarted = true;
      _sessionTimer = Timer.periodic(
        const Duration(seconds: 1),
        _updateRemainingTime,
      );
    }
  }

  void _updateRemainingTime(Timer time) {
    _sessionDuration--;
    setState(() {
      _remainingSeconds = _sessionDuration % 60;
      _remainingMinutes = (_sessionDuration / 60).floor();
    });
    if (_sessionDuration <= 0) {
      Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder:
            (_) => AppStateProvider(
              notifier: ValueNotifier(appState),
              child: SessionResultsScreen(correct: correct, total: total,),
            ),
      ),
    );
    }
  }

  String get _remainingSessionTime =>
      _remainingMinutes != 0
          ? '${_remainingMinutes}m ${_remainingSeconds}s'
          : '${_remainingSeconds}s';

  _exitSession() {
    // To Do
    navigateToHomeScreen();
  }

  navigateToHomeScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder:
            (_) => AppStateProvider(
              notifier: ValueNotifier(appState),
              child: HomeScreen(),
            ),
      ),
    );
  }

  buildSnackBar() {
    final snackBar = SnackBar(
      content: Text(_message),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void initColors() {
    if (!_isScreenInitialized) {
      _isScreenInitialized = true;

      _enableController = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );
      _disableController = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );

      ValueNotifier<AppState> appStateNotifier = AppStateProvider.of(context);
      appState = appStateNotifier.value;

      _sbl = SessionButtonsList(appState.appTheme.sessionEnabledButtonC);
      _sbl.assingValues(_qg.options, _qg.solutionIndex);

      _sessionDuration = appState.sessionSettings.sessionDuration;
      _remainingSeconds = _sessionDuration % 60;
      _remainingMinutes = (_sessionDuration / 60).floor();

      _animatedOptionButtonColor = appState.appTheme.sessionEnabledButtonC;
      _animatedBackgroundBox = appState.appTheme.sessionEnabledAnimatedBgC;

      _optionButtonEnableAnimation = ColorTween(
        begin: appState.appTheme.sessionDisabledButtonC,
        end: appState.appTheme.sessionEnabledButtonC,
      ).animate(_enableController)..addListener(() {
        setAllButtonColor(_optionButtonEnableAnimation.value!);
      });
      _normalOptionButtonDisableAnimation = ColorTween(
        begin: appState.appTheme.sessionEnabledButtonC,
        end: appState.appTheme.sessionDisabledButtonC,
      ).animate(_disableController);
      _wrongOptionButtonDisableAnimation = TweenSequence<Color?>([
        TweenSequenceItem<Color?>(
          weight: 1,
          tween: ColorTween(
            begin: appState.appTheme.sessionEnabledButtonC,
            end: appState.appTheme.sessionWrongButtonC,
          ),
        ),
        TweenSequenceItem<Color?>(
          weight: 1,
          tween: ColorTween(
            begin: appState.appTheme.sessionWrongButtonC,
            end: appState.appTheme.sessionDisabledButtonC,
          ),
        ),
      ]).animate(_disableController);
      _correctOptionButtonDisableAnimation = TweenSequence<Color?>([
        TweenSequenceItem<Color?>(
          weight: 1,
          tween: ColorTween(
            begin: appState.appTheme.sessionEnabledButtonC,
            end: appState.appTheme.sessionCorrectButtonC,
          ),
        ),
        TweenSequenceItem<Color?>(
          weight: 1,
          tween: ColorTween(
            begin: appState.appTheme.sessionCorrectButtonC,
            end: appState.appTheme.sessionDisabledButtonC,
          ),
        ),
      ]).animate(_disableController)..addListener(() => disableButtons());
    }
  }
}
