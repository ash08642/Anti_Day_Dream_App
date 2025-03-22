
import 'package:flutter/material.dart';

enum ButtonState {normal, correct, wrong, correctButNotSelected}

class SessionButtonParams {
  int buttonId;
  Widget buttonValue;
  ButtonState buttonState;
  Color buttonColor;
  bool isOptionCorrect;

  SessionButtonParams(this.buttonId, this.buttonValue, this.buttonState, this.buttonColor, this.isOptionCorrect);
}

class SessionButtonsList {
  late List<SessionButtonParams> sessionButtonList;

  SessionButtonsList(Color color) {
    sessionButtonList = <SessionButtonParams>[
      SessionButtonParams(0, SizedBox(width: 0, height: 0,), ButtonState.normal, color, false),
      SessionButtonParams(1, SizedBox(width: 0, height: 0,), ButtonState.normal, color, false),
      SessionButtonParams(2, SizedBox(width: 0, height: 0,), ButtonState.normal, color, false),
      SessionButtonParams(3, SizedBox(width: 0, height: 0,), ButtonState.normal, color, false)
    ];
  }

  void onCorrectButtonPressed(int sessionButtonIndex) {
    for (var i = 0; i < sessionButtonList.length; i++) {
      if (i == sessionButtonIndex) {
        sessionButtonList[i].buttonState = ButtonState.correct;
      } else {
        sessionButtonList[i].buttonState = ButtonState.normal;
      }
    }
  }

  void onWrongButtonPressed(int sessionButtonIndex, int correctButtonIndex) {
    for (var i = 0; i < sessionButtonList.length; i++) {
      if (i == sessionButtonIndex) {
        sessionButtonList[i].buttonState = ButtonState.wrong;
      } else if (i == correctButtonIndex) {
        sessionButtonList[i].buttonState = ButtonState.correctButNotSelected;
      } else {
        sessionButtonList[i].buttonState = ButtonState.normal;
      }
    }
  }

  void assingValues(List<Widget> options, int solutionIndex) {
    for (var i = 0; i < 4; i++) {
      sessionButtonList[i].buttonValue = options[i];
      sessionButtonList[i].isOptionCorrect = false;
      if (i == solutionIndex) {
        sessionButtonList[i].isOptionCorrect = true;
      }
    }
  }

  void setAllColor(Color color) {
      sessionButtonList[0].buttonColor = color;
      sessionButtonList[1].buttonColor = color;
      sessionButtonList[2].buttonColor = color;
      sessionButtonList[3].buttonColor = color;
  }
}