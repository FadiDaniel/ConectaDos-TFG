import 'dart:io';
import 'dart:math';

import 'package:conectados/common/singleton.dart';
import 'package:conectados/model/position.dart';
import 'package:flutter/material.dart';

class Functions {
  static void push(Widget route, BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => route,
    ));
  }

  static bool checkEmail(String text) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(text);
  }

  static bool checkIfNumber(String text) {
    if (int.tryParse(text) != null) {
      return true;
    } else {
      return false;
    }
  }

  static String getRandomString(int length) {
    const chars =
        'AaBbCcDdEeFfGgHhiJjKkLMmNnoPpQqRrSsTtUuVvWwXxYyZz123456789!?.';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  static Future<void> reinitializePositions(dynamic user, String filter) async {
    SG.positionsStudent = await SG.firestore.retrievePositionsStudent(
        user.fp!, user.city!, filter, user.likes!, user.discarded!);
  }

  static Future<void> reinitializeStudents(
      Position position, String filter) async {
    SG.studentsPosition =
        await SG.firestore.retrieveStudentsPosition(position, filter);
  }
}
