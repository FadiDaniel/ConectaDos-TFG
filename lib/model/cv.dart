import 'package:conectados/model/experience.dart';

class Cv {
  String? presentation;
  List<String>? interests;
  List<Experience>? experiences;
  List<String>? skills;

  Cv({
    required this.presentation,
    required this.interests,
    required this.experiences,
    required this.skills,
  });
}
