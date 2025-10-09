import 'package:conectados/common/singleton.dart';
import 'package:conectados/common/strings.dart';
import 'package:conectados/controller/functions.dart';
import 'package:conectados/model/cv.dart';
import 'package:conectados/model/student.dart';
import 'package:conectados/presentation/screens/signup_login/signUpType.dart';
import 'package:conectados/presentation/screens/student/modifyCV.dart';
import 'package:conectados/presentation/themes/styles.dart';
import 'package:conectados/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class StudentSignup extends StatefulWidget {
  const StudentSignup({super.key, required this.code});
  final String code;
  @override
  State<StudentSignup> createState() => _StudentSignupState();
}

class _StudentSignupState extends State<StudentSignup> {
  bool bName = true;
  bool bSurnames = true;
  TextEditingController name = TextEditingController();
  TextEditingController surnames = TextEditingController();

  Map<String, String> tutorMap = {};

  @override
  void initState() {
    super.initState();
    loadTutorSpecs();
  }

  void callbackTextfield(bool check, int index) {
    setState(() {
      switch (index) {
        case 1:
          bName = check;
          return;
        case 2:
          bSurnames = check;
          return;
      }
    });
  }

  void loadTutorSpecs() async {
    tutorMap = await SG.firestore.fetchStringsFromCode(widget.code);
    setState(() {
      tutorMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ws.appBarNoBack(Ss.studentSignUp, context),
      body: SafeArea(
        child: PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, result) {
            Functions.push(Signuptype(), context);
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Ws.mandatoryText(Ss.name, bName),
                  Ws.smallSeparation,
                  //name 1
                  Ws.textFieldCheck(name, "", bName, callbackTextfield, 1),
                  Ws.separation,
                  Ws.mandatoryText(Ss.surname, bSurnames),
                  Ws.smallSeparation,
                  //surnames 2
                  Ws.textFieldCheck(
                      surnames, "", bSurnames, callbackTextfield, 2),
                  Ws.separation,
                  //FP
                  Ws.text(Ss.fp),
                  Ws.smallSeparation,
                  Ws.noSearcherTile(tutorMap["fp"]!),
                  Ws.separation,
                  //City
                  Ws.text(Ss.city),
                  Ws.smallSeparation,
                  Ws.noSearcherTile(
                    tutorMap["city"]!,
                  ),
                  Ws.separation,
                  //HighSchool
                  Ws.text(Ss.highSchool),
                  Ws.smallSeparation,
                  Ws.noSearcherTile(
                    tutorMap["highSchool"]!,
                  ),
                  Ws.separation,
                  //finish button
                  Center(
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          //controlls of fieltexts name and surname
                          if (name.text.isEmpty || surnames.text.isEmpty) {
                            Ws.errorMessage(Ss.fill, context);
                          }
                          if (name.text.isEmpty) {
                            setState(() {
                              bName = false;
                            });
                          }
                          if (surnames.text.isEmpty) {
                            setState(() {
                              bSurnames = false;
                            });
                          }
                          //everything fine
                          if (bName && bSurnames) {
                            Student student = Student.all(
                                id: SG.auth.currentUser!.uid,
                                name: name.text,
                                surnames: surnames.text,
                                fp: tutorMap["fp"]!,
                                highSchool: tutorMap["highSchool"]!,
                                city: tutorMap["city"]!,
                                cv: Cv(
                                    presentation: "",
                                    interests: [],
                                    experiences: [],
                                    skills: []),
                                likes: [],
                                discarded: [],
                                matches: []);
                            if (await SG.firestore
                                .writeStudent(student, tutorMap["tutorUid"]!)) {
                              await SG.initializeUser();
                              if (context.mounted) {
                                Functions.push(
                                    ModifyCV(
                                      cv: Cv(
                                          presentation: "",
                                          interests: [],
                                          experiences: [],
                                          skills: []),
                                    ),
                                    context);
                              }
                            } else {
                              if (context.mounted) {
                                Ws.errorMessage(Ss.errorWriteDB, context);
                              }
                            }
                          }
                        },
                        style: WStyles.elevatedButtonPC,
                        child: Text(
                          Ss.finalize,
                          style: TStyles.boldWhite,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
