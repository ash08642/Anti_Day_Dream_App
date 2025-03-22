import 'dart:async';

import 'package:anti_daydream/helpers/app_state_provider.dart';
import 'package:anti_daydream/models/app_state.dart';
import 'package:anti_daydream/models/app_theme.dart';
import 'package:anti_daydream/models/session_settings.dart';
import 'package:anti_daydream/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anti_daydream/uiElements/buttons.dart';

class SessionResultsScreen extends StatefulWidget {
  final int correct;
  final int total;

  const SessionResultsScreen({
    super.key,
    required this.correct,
    required this.total,
  });

  @override
  State<SessionResultsScreen> createState() => _SessionResultsScreenState();
}

class _SessionResultsScreenState extends State<SessionResultsScreen> {
  late AppTheme _appTheme;
  late SessionSettings _sessionSettings;
  bool _isScreenInitialized = false;
  Color _diagramColor1 = Colors.white70;
  Color _diagramColor2 = Colors.blue;
  double _diagramValue = 0;
  late Timer _diagramTimer;
  final int milSec = 20;
  int totalSec = 0;
  init() {
    if (!_isScreenInitialized) {
      _isScreenInitialized = true;
    }
  }

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        switch (widget.correct / widget.total) {
          case < 0.4:
            _diagramColor1 = Colors.redAccent;
            _diagramColor2 = Colors.red;
            break;
          case > 0.6:
            _diagramColor1 = Colors.greenAccent;
            _diagramColor2 = Colors.green;
            break;
          default:
            _diagramColor1 = Colors.amberAccent;
            _diagramColor2 = Colors.amber;
        }
        _diagramValue = widget.correct / widget.total;
      });
    });
    _diagramTimer = Timer.periodic(
      Duration(milliseconds: milSec),
      _updateDiagramBar,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        _appTheme = appState.appTheme;
        _sessionSettings = appState.sessionSettings;
        init();

        return Scaffold(
          backgroundColor: _appTheme.resultScreenBgC,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  'Session Completed!',
                  style: TextStyle(fontSize: 30),
                ),
                _createResultDiagram(),
                Column(
                  children: [
                    _createMainQuestion(),
                    _createYesOptions(),
                    _createNoOptions(),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _createMainQuestion() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: const Text(
        'Were you able to avoid Day-Dreaming during the pauses?',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _createNoOptions() {
    return _createOptions(
      'No',
      ['- 1s', '- 2s', '- 5s'],
      [-1, -2, -5],
      Color.fromARGB(255, 177, 0, 0),
      Color.fromARGB(255, 116, 0, 0),
    );
  }

  Container _createOptions(
    String label,
    List<String> nums,
    List<int> values,
    Color bg,
    Color fg,
  ) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(10),
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 2, color: bg)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: fg,
            ),
          ),
          for (int i = 0; i < nums.length; i++)
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: bg),
              onPressed: () => _updatePauseInterval(values[i]),
              child: Text(nums[i], style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
    );
  }

  Widget _createYesOptions() {
    return _createOptions(
      'Yes',
      ['+ 1s', '+ 2s', '+ 5s'],
      [1, 2, 5],
      Color.fromARGB(255, 177, 160, 0),
      Color.fromARGB(255, 102, 92, 0),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _createResultDiagram() {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      height: 150,
      decoration: BoxDecoration(color: _diagramColor1, shape: BoxShape.circle),
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              height: 140,
              width: 140,
              child: CircularProgressIndicator(
                value: _diagramValue,
                semanticsLabel: 'Circular',
                strokeWidth: 10,
                color: _diagramColor2,
              ),
            ),
          ),
          Center(child: Text('${widget.correct} / ${widget.total}')),
        ],
      ),
    );
  }

  _updatePauseInterval(int x) {
    ValueNotifier<AppState> appStateNotifier = AppStateProvider.of(context);
    AppState appState = appStateNotifier.value;
    appState.sessionSettings.pauseInterval = appState.sessionSettings.pauseInterval + x;
    appStateNotifier.value = appState;

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => AppStateProvider(
      notifier: ValueNotifier(appStateNotifier.value),
      child: HomeScreen(),
    )));
  }

  void _updateDiagramBar(Timer timer) {
    totalSec += milSec;
    setState(() {
      _diagramValue = (widget.correct / widget.total) / (1000 / totalSec);
    });
    if (totalSec >= 1000) {
      _diagramTimer.cancel();
    }
  }
}
