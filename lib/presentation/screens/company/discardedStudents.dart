import 'package:conectados/common/singleton.dart';
import 'package:conectados/common/strings.dart';
import 'package:conectados/model/position.dart';
import 'package:conectados/model/student.dart';
import 'package:conectados/presentation/screens/company/homepage_company.dart';
import 'package:conectados/presentation/themes/styles.dart';
import 'package:conectados/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class DiscardedStudents extends StatefulWidget {
  const DiscardedStudents(
      {super.key, required this.discardedStudents, required this.position});
  final List<Student> discardedStudents;
  final Position position;

  @override
  State<DiscardedStudents> createState() => _DiscardedStudentsState();
}

class _DiscardedStudentsState extends State<DiscardedStudents> {
  void removeDiscarded(Student student) async {
    setState(() {
      widget.discardedStudents.remove(student);
      SG.studentsPosition!.add(student);
    });
    await SG.firestore.removeDiscardedStudent(widget.position, student.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Ws.appBar(Ss.discarded, context, HomePageCompany()),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: ListView.separated(
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(0),
                  color: Colors.red.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Ws.studentInfo(widget.discardedStudents[index]),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                overlayColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    side:
                                        BorderSide(color: Colors.red.shade300),
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () async {
                              removeDiscarded(widget.discardedStudents[index]);
                            },
                            child: Text(
                              "Eliminar de descartados",
                              style: TStyles.normalBlack,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Ws.smallSeparation;
              },
              itemCount: widget.discardedStudents.length),
        ));
  }
}
