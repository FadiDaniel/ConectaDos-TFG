import 'package:conectados/common/routes.dart';
import 'package:conectados/common/singleton.dart';
import 'package:conectados/common/strings.dart';
import 'package:conectados/controller/functions.dart';
import 'package:conectados/presentation/screens/signup_login/login.dart';
import 'package:conectados/presentation/themes/styles.dart';
import 'package:conectados/presentation/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String federacionEsc = "Seleccione sus últimos estudios";

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmar = TextEditingController();

  bool obscurePassword = true;
  bool bTermsText = true;

  bool bEmail = true;
  bool bPassword = true;
  bool bTerms = false;

  void callbackTextField(bool comprobador, int tipo) {
    setState(() {
      bPassword = comprobador;
    });
  }

  void callbackObscure(bool comprobador) {
    setState(() {
      obscurePassword = comprobador;
    });
  }

  void comprobarContrasena() {
    if (password.text.isEmpty || confirmar.text.isEmpty) {
      setState(() {
        bPassword = false;
      });
    } else {
      if (password.text == confirmar.text) {
        if (password.text.length < 6) {
          Ws.errorMessage(Ss.lengthPass, context);
          setState(() {
            bPassword = false;
          });
        } else {
          setState(() {
            bPassword = true;
          });
        }
      } else {
        Ws.errorMessage(Ss.differentPass, context);
        setState(() {
          bPassword = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ws.appBar("Crear usuario", context, Login()),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    Routes.logo,
                    height: MediaQuery.sizeOf(context).height / 4,
                  ),
                ),
                //email
                Ws.mandatoryText(Ss.email, bEmail),
                Ws.smallSeparation,
                TextField(
                  controller: email,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        bEmail = true;
                      });
                    }
                  },
                  decoration: WStyles.textInputCheck(bEmail, ""),
                  cursorColor: CStyles.primaryColor,
                ),
                Ws.separation,
                Ws.mandatoryText(Ss.password, bPassword),
                Ws.smallSeparation,
                //password 1, 3callback
                Ws.textFieldContrs2(password, bPassword, callbackTextField, 3,
                    obscurePassword, callbackObscure),
                Ws.separation,
                Ws.mandatoryText(Ss.confirmPass, bPassword),
                Ws.smallSeparation,
                Ws.textFieldContrs2(confirmar, bPassword, callbackTextField, 3,
                    obscurePassword, callbackObscure),
                Ws.separation,
                Row(
                  children: [
                    Checkbox(
                        activeColor: CStyles.primaryColor,
                        side: WStyles.checkboxSide,
                        shape: WStyles.checkboxShape,
                        value: bTerms,
                        onChanged: (checked) {
                          setState(() {
                            bTerms = checked!;
                            if (checked) {
                              bTermsText = true;
                            }
                          });
                        }),
                    Flexible(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: Ss.accept,
                              style: TStyles.errorText(bTermsText)),
                          TextSpan(text: "*", style: TStyles.red)
                        ]),
                      ),
                    )
                  ],
                ),
                Ws.separation,
                Center(
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (email.text.isEmpty || password.text.isEmpty) {
                          Ws.errorMessage(Ss.fill, context);
                        }
                        if (!Functions.checkEmail(email.text)) {
                          setState(() {
                            bEmail = false;
                          });
                          Ws.errorMessage(Ss.errorEmail, context);
                        }
                        comprobarContrasena();
                        if (!bTerms) {
                          setState(() {
                            bTermsText = false;
                          });
                          Ws.errorMessage(Ss.mustAccept, context);
                        }
                        if (bEmail && bPassword) {
                          try {
                            await SG.auth.signUp(
                                email: email.text, password: password.text);
                            SG.auth.signOut();
                            if (context.mounted) {
                              Ws.popUpReturn(Ss.succesful, Ss.emailSentConfirm,
                                  Ss.returnLogin, context, Login());
                            }
                          } on FirebaseAuthException catch (exception) {
                            if (exception
                                    .toString()
                                    .contains(Ss.emailTakenFB) &&
                                context.mounted) {
                              Ws.errorMessage(Ss.emailTaken, context);
                              return;
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
        );
      }),
    );
  }
}
