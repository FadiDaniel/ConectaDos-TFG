import 'package:conectados/controller/functions.dart';
import 'package:conectados/presentation/screens/student/homepage_student.dart';
import 'package:flutter/material.dart';

class Editprofilestudent extends StatefulWidget {
  const Editprofilestudent({super.key});

  @override
  State<Editprofilestudent> createState() => _EditprofilestudentState();
}

class _EditprofilestudentState extends State<Editprofilestudent> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        Functions.push(HomepageStudent(), context);
      },
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Column(),
      ),
    );
  }
}
