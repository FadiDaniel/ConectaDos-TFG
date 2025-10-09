import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conectados/common/firebase/auth.dart';
import 'package:conectados/common/firebase/firestore.dart';
import 'package:conectados/controller/functions.dart';
import 'package:conectados/model/company.dart';
import 'package:conectados/model/position.dart';
import 'package:conectados/model/student.dart';
import 'package:conectados/model/tutor.dart';
import 'package:dartz/dartz.dart';

class SG {
  static Auth auth = Auth();
  static FirestoreManager firestore = FirestoreManager();
  static Student? student;
  static Company? company;
  static Tutor? tutor;
  static List<Position>? positionsStudent;
  static List<Student>? studentsPosition;
  static List<Student>? studentsTutor;
  static Position? selectedPosition;

  static Future<void> initializeUser() async {
    Either either = await SG.firestore.retrieveStudent();
    either.fold((ifLeft) {}, (ifRight) async {
      if (ifRight is Student) {
        student = ifRight;
        await Functions.reinitializePositions(SG.student!, "");
        return;
      }
    });
    either = await SG.firestore.retrieveTutor();
    either.fold((ifLeft) {}, (ifRight) async {
      if (ifRight is Tutor) {
        tutor = ifRight;
        await Functions.reinitializePositions(SG.tutor!, "");
        return;
      }
    });
    either = await SG.firestore.retrieveCompany();
    either.fold((ifLeft) {}, (ifRight) async {
      if (ifRight is Company) {
        company = ifRight;
        if (SG.company!.positions!.isNotEmpty) {
          SG.selectedPosition = SG.company!.positions![0];
          await Functions.reinitializeStudents(SG.company!.positions![0], "");
        }
        return;
      }
    });
  }
}
