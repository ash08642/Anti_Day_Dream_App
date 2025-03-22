import 'dart:math';

import 'package:flutter/material.dart';

class QuestionGenerator {
  late int x;
  late int y;
  late int sign;
  late int solution;
  late int solutionIndex;
  List<Widget> options = <Widget>[
    SizedBox(),
    SizedBox(),
    SizedBox(),
    SizedBox(),
  ];
  List<Widget> bufferOptions = <Widget>[
    SizedBox(),
    SizedBox(),
    SizedBox(),
    SizedBox(),
  ];

  QuestionGenerator() {
    generateNewQuestion();
  }

  void generateNewQuestion() {
    x = Random().nextInt(10);
    y = Random().nextInt(10);
    sign = Random().nextInt(2);
    if (sign == 0) {
      //sign is +
      solution = x + y;
    } else {
      solution = x - y;
    }
    bufferOptions[0] = Text(
      solution.toString(),
      style: const TextStyle(fontSize: 40),
    );

    int temp = solution + Random().nextInt(3) + 1;

    bufferOptions[1] = Text(
      temp.toString(),
      style: const TextStyle(fontSize: 40),
    );

    int temp2 = solution + Random().nextInt(3) + 1;

    bufferOptions[2] = Text(
      temp2.toString(),
      style: const TextStyle(fontSize: 40),
    );

    while (temp == temp2) {
      temp2 = solution + Random().nextInt(3) + 1;
      bufferOptions[2] = Text(
        temp2.toString(),
        style: const TextStyle(fontSize: 40),
      );
    }

    temp2 = solution - Random().nextInt(3) - 1;
    bufferOptions[3] = Text(
      temp2.toString(),
      style: const TextStyle(fontSize: 40),
    );

    _shuffle();
  }

  String get question {
    String q = '$x ';
    q += sign == 0 ? '+ ' : '- ';
    q += y.toString();
    return q;
  }

  bool isOptionCorrect(int value) {
    if (value == solution) {
      return true;
    }
    return false;
  }

  void _shuffle() {
    int index0 = Random().nextInt(4);
    options[index0] = bufferOptions[0];
    solutionIndex = index0;

    int index1 = Random().nextInt(4);
    while (index1 == index0) {
      index1 = Random().nextInt(4);
    }
    options[index1] = bufferOptions[1];

    int index2 = Random().nextInt(4);
    while (index2 == index0 || index2 == index1) {
      index2 = Random().nextInt(4);
    }
    options[index2] = bufferOptions[2];

    int index3 = Random().nextInt(4);
    while (index3 == index0 || index3 == index1 || index3 == index2) {
      index3 = Random().nextInt(4);
    }
    options[index3] = bufferOptions[3];
  }
}
