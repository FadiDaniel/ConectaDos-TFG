import 'package:conectados/common/singleton.dart';
import 'package:conectados/common/strings.dart';
import 'package:conectados/model/position.dart';
import 'package:conectados/model/student.dart';
import 'package:conectados/presentation/screens/company/homepage_company.dart';
import 'package:conectados/presentation/themes/styles.dart';
import 'package:conectados/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class MatchedStudents extends StatefulWidget {
  const MatchedStudents(
      {super.key, required this.matchedStudents, required this.position});
  final List<Student> matchedStudents;
  final Position position;

  @override
  State<MatchedStudents> createState() => _MatchedStudentsState();
}

class _MatchedStudentsState extends State<MatchedStudents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Ws.appBar(Ss.matches, context, HomePageCompany()),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView.separated(
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(0),
                  color: Colors.yellow.shade200,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Ws.studentInfo(widget.matchedStudents[index]),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Ws.smallSeparation;
              },
              itemCount: widget.matchedStudents.length),
        ));
  }
}
