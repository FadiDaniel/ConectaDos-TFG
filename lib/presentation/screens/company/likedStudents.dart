import 'package:conectados/common/singleton.dart';
import 'package:conectados/common/strings.dart';
import 'package:conectados/controller/functions.dart';
import 'package:conectados/model/position.dart';
import 'package:conectados/model/student.dart';
import 'package:conectados/presentation/screens/company/homepage_company.dart';
import 'package:conectados/presentation/themes/styles.dart';
import 'package:conectados/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class LikedStudents extends StatefulWidget {
  const LikedStudents(
      {super.key, required this.favouriteStudents, required this.position});
  final List<Student> favouriteStudents;
  final Position position;

  @override
  State<LikedStudents> createState() => _LikedStudentsState();
}

class _LikedStudentsState extends State<LikedStudents> {
  void removeFavourite(Student student) async {
    setState(() {
      widget.favouriteStudents.remove(student);
      SG.studentsPosition!.add(student);
    });
    await SG.firestore.removeLikedStudent(widget.position, student.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Ws.appBar(Ss.liked, context, HomePageCompany()),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView.separated(
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(0),
                  color: Colors.green.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Ws.studentInfo(widget.favouriteStudents[index]),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.red.shade100,
                                overlayColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    side:
                                        BorderSide(color: Colors.red.shade300),
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () async {
                              removeFavourite(widget.favouriteStudents[index]);
                            },
                            child: Text(
                              "Eliminar favorito",
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
              itemCount: widget.favouriteStudents.length),
        ));
  }
}
