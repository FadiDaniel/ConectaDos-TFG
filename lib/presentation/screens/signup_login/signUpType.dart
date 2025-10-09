import 'package:conectados/common/singleton.dart';
import 'package:conectados/common/strings.dart';
import 'package:conectados/controller/functions.dart';
import 'package:conectados/presentation/screens/company/company_signup.dart';
import 'package:conectados/presentation/screens/student/student_signup.dart';
import 'package:conectados/presentation/screens/tutor/tutor_signup.dart';
import 'package:conectados/presentation/themes/styles.dart';
import 'package:conectados/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Signuptype extends StatefulWidget {
  const Signuptype({super.key});

  @override
  State<Signuptype> createState() => _SignuptypeState();
}

class _SignuptypeState extends State<Signuptype> {
  bool bStudentCode = true;
  final studentCodeContr = TextEditingController();
  bool bTutorCode = true;
  final tutorCodeContr = TextEditingController();

  List<bool> users = [false, false, false];
  List<IconData> userIcons = [
    Icons.school_rounded,
    Icons.person_rounded,
    Icons.business_center_rounded
  ];

  void callbackTextfield(bool check, int index) {
    setState(() {
      switch (index) {
        case 1:
          bStudentCode = check;
          break;
        case 2:
          bTutorCode = check;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      appBar: Ws.appBarNoBackSignOut(Ss.selectUser, context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: SizedBox(
                height: constraints.maxHeight -
                    Scaffold.of(context).appBarMaxHeight! +
                    keyboardHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShrinkWrappingViewport(
                      offset: ViewportOffset.zero(),
                      slivers: [
                        SliverList.separated(
                          separatorBuilder: (context, index) {
                            return Ws.bigSeparation;
                          },
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return ElevatedButton(
                              style: WStyles.elevatedButtonED(users[index])
                                  .copyWith(
                                      fixedSize: WidgetStatePropertyAll(
                                          Size(double.infinity, 100))),
                              onPressed: () {
                                setState(() {
                                  users = [false, false, false];
                                  users[index] = true;
                                });
                              },
                              child: SizedBox(
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        Ss.users[index],
                                        style:
                                            TStyles.selectedText(users[index])
                                                .copyWith(fontSize: 30),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Icon(
                                        userIcons[index],
                                        size: 40,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                    Ws.bigSeparation,
                    ShrinkWrappingViewport(
                      offset: ViewportOffset.zero(),
                      slivers: [
                        SliverList.builder(
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            switch (users.indexOf(true)) {
                              case 0:
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Ws.mandatoryText(
                                        Ss.studentCode, bStudentCode),
                                    Ws.smallSeparation,
                                    Ws.textFieldCheck(studentCodeContr, "",
                                        bStudentCode, callbackTextfield, 1),
                                  ],
                                );
                              case 1:
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Ws.mandatoryText(
                                        Ss.tutorCodeIntroduce, bTutorCode),
                                    Ws.smallSeparation,
                                    Ws.textFieldCheck(tutorCodeContr, "",
                                        bTutorCode, callbackTextfield, 2),
                                  ],
                                );
                              default:
                                return SizedBox();
                            }
                          },
                        )
                      ],
                    ),
                    Ws.separation,
                    ShrinkWrappingViewport(
                      offset: ViewportOffset.zero(),
                      slivers: [
                        SliverList.builder(
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            if (users.contains(true)) {
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: WStyles.elevatedButtonPC,
                                  onPressed: () async {
                                    switch (users.indexOf(true) + 1) {
                                      case 1:
                                        if (studentCodeContr.text.isEmpty) {
                                          setState(() {
                                            bStudentCode = false;
                                          });
                                          Ws.errorMessage(Ss.fill, context);
                                          return;
                                        }
                                        if (await SG.firestore.isStudentCodeOK(
                                                studentCodeContr.text) &&
                                            context.mounted) {
                                          Functions.push(
                                              StudentSignup(
                                                  code: studentCodeContr.text),
                                              context);
                                        } else {
                                          Ws.errorMessage(
                                              Ss.errorCode, context);
                                        }
                                      case 2:
                                        if (tutorCodeContr.text.isEmpty) {
                                          setState(() {
                                            bTutorCode = false;
                                          });
                                          Ws.errorMessage(Ss.fill, context);
                                          return;
                                        }
                                        if (await SG.firestore.isTutorCodeOK(
                                                tutorCodeContr.text) &&
                                            context.mounted) {
                                          Functions.push(
                                              TutorSignup(), context);
                                        } else {
                                          Ws.errorMessage(
                                              Ss.errorCode, context);
                                        }
                                      case 3:
                                        Functions.push(
                                            CompanySignup(), context);
                                    }
                                  },
                                  child: Text(
                                    Ss.continuE,
                                    style: TStyles.boldWhite,
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox();
                            }
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
