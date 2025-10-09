import 'package:conectados/model/position.dart';
import 'package:conectados/model/student.dart';

class Tutor {
  String? id;
  String? name;
  String? surnames;
  String? fp;
  String? city;
  String? highSchool;
  String? code;
  List<Student>? students;
  List<String>? likes;
  List<String>? discarded;

  Tutor.signUp({
    required this.name,
    required this.surnames,
    required this.fp,
    required this.city,
    required this.highSchool,
    required this.code,
  });

  Tutor.fromDB({
    required this.id,
    required this.name,
    required this.surnames,
    required this.fp,
    required this.city,
    required this.highSchool,
    required this.students,
    required this.code,
    required this.likes,
    required this.discarded,
  });
}
