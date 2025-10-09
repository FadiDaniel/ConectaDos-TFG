import 'package:conectados/common/routes.dart';
import 'package:conectados/common/singleton.dart';
import 'package:conectados/common/strings.dart';
import 'package:conectados/controller/functions.dart';
import 'package:conectados/presentation/screens/company/homepage_company.dart';
import 'package:conectados/presentation/screens/signup_login/resetPassword.dart';
import 'package:conectados/presentation/screens/signup_login/signUp.dart';
import 'package:conectados/presentation/screens/signup_login/signUpType.dart';
import 'package:conectados/presentation/screens/student/homepage_student.dart';
import 'package:conectados/presentation/screens/tutor/homepageTutor.dart';
import 'package:conectados/presentation/themes/styles.dart';
import 'package:conectados/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  void cambiarIdioma() {}

  void callbackTextfield(bool check, int index) {
    switch (index) {
      case 1:
        setState(() {
          bEmail = check;
          return;
        });
      case 2:
        setState(() {
          bPassword = check;
          return;
        });
    }
  }

  void callbackObscure(bool check) {
    setState(() {
      obscure = check;
    });
  }

  Future<void> sendEmail() async {
    await SG.auth.currentUser!.sendEmailVerification();
  }

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool bEmail = true;
  bool bPassword = true;
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    var keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      appBar: Ws.appBarNoBack(Ss.login, context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: SizedBox(
              height: constraints.maxHeight - 60 + keyboardHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Image.asset(
                      Routes.logo,
                      height: MediaQuery.sizeOf(context).height * 0.3,
                    ),
                  ),
                  Ws.textFieldEmail(
                      email, Ss.email, bEmail, callbackTextfield, 1),
                  Ws.textFieldPassword(password, bPassword, Ss.password,
                      callbackTextfield, 2, obscure, callbackObscure),
                  Center(
                    child: TextButton(
                        onPressed: () {
                          Functions.push(ResetPassword(), context);
                        },
                        child: Text(
                          Ss.forgotten,
                          style: TStyles.boldBlack,
                        )),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (email.text.isEmpty) {
                          callbackTextfield(false, 1);
                        }
                        if (password.text.isEmpty) {
                          callbackTextfield(false, 2);
                        }
                        if (email.text.isEmpty || password.text.isEmpty) {
                          Ws.errorMessage(Ss.fill, context);
                          return;
                        }
                        if (!Functions.checkEmail(email.text)) {
                          callbackTextfield(false, 1);
                          Ws.errorMessage(Ss.errorEmail, context);
                          return;
                        }
                        if (bEmail && bPassword) {
                          if (await SG.auth.logIn(
                              email: email.text.trim(),
                              password: password.text)) {
                            if (SG.auth.currentUser!.emailVerified &&
                                context.mounted) {
                              if (SG.student != null) {
                                await Functions.reinitializePositions(
                                    SG.student!, "");
                                if (context.mounted) {
                                  Functions.push(HomepageStudent(), context);
                                }
                                return;
                              }
                              if (SG.tutor != null) {
                                await Functions.reinitializePositions(
                                    SG.tutor!, "");
                                if (context.mounted) {
                                  Functions.push(HomepageTutor(), context);
                                }

                                return;
                              }
                              if (SG.company != null) {
                                if (SG.company!.positions!.isNotEmpty) {
                                  await Functions.reinitializeStudents(
                                      SG.company!.positions![0], "");
                                }
                                if (context.mounted) {
                                  Functions.push(HomePageCompany(), context);
                                }
                                return;
                              }
                              Functions.push(Signuptype(), context);
                            } else {
                              if (context.mounted) {
                                Ws.popUpConfirm(
                                    Ss.emailNotVerified,
                                    Ss.emailNotVerifiedContent,
                                    context,
                                    Ss.sendEmailAgain,
                                    Ss.cancel,
                                    sendEmail);
                              }
                            }
                          } else {
                            if (context.mounted) {
                              Ws.errorMessage(Ss.loginError, context);
                            }
                          }
                        }
                      },
                      style: WStyles.elevatedButtonPC,
                      child: Text(
                        Ss.enter,
                        style: TStyles.boldWhite,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Divider(
                          height: 20,
                        ),
                      ),
                      Text(Ss.dontHave),
                      Expanded(child: Divider())
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Functions.push(SignUp(), context);
                      },
                      style: WStyles.elevatedButtonPC,
                      child: Text(
                        Ss.makeAccount,
                        style: TStyles.boldWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
