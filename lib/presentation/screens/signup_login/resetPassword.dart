import 'package:conectados/common/routes.dart';
import 'package:conectados/common/strings.dart';
import 'package:conectados/controller/functions.dart';
import 'package:conectados/presentation/screens/signup_login/login.dart';
import 'package:conectados/presentation/themes/styles.dart';
import 'package:conectados/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController email = TextEditingController();
  bool bEmail = true;

  void callbackIdioma(String sigla) {
    setState(() {});
  }

  void callbackTextfield(bool check, int index) {
    setState(() {
      bEmail = check;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ws.appBar(Ss.recoverPassword, context, Login()),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            height: MediaQuery.sizeOf(context).height - 90,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Image.asset(
                      Routes.logo,
                      height: MediaQuery.sizeOf(context).height / 3,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Ws.textFieldCheck(
                      email, Ss.email, bEmail, callbackTextfield, 1),
                  SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!Functions.checkEmail(email.text)) {
                            callbackTextfield(false, 1);
                            Ws.errorMessage(Ss.errorEmail, context);
                          }
                          if (bEmail) {
                            Ws.popUpReturn(Ss.emailSent, Ss.checkEmail,
                                Ss.returnLogin, context, Login());
                          }
                        },
                        style: WStyles.elevatedButtonPC,
                        child: Text(
                          "Enviar correo",
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
