import 'package:conectados/model/cv.dart';

class Student {
  String? id;
  String? name;
  String? surnames;
  String? fp;
  String? city;
  String? highSchool;
  Cv? cv;
  List<String>? likes;
  List<String>? discarded;
  String? tutorPass;
  List<String>? matches;

  Student.show({
    required this.id,
    required this.name,
    required this.surnames,
    required this.fp,
    required this.cv,
  });

  Student.all({
    required this.id,
    required this.name,
    required this.surnames,
    required this.fp,
    required this.city,
    required this.highSchool,
    required this.cv,
    required this.likes,
    required this.discarded,
    required this.matches,
  });

  Student.signUp({
    required this.name,
    required this.surnames,
    required this.fp,
    required this.city,
    required this.highSchool,
  });
}
