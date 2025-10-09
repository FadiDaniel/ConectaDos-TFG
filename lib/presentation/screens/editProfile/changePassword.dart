import 'package:conectados/common/singleton.dart';
import 'package:conectados/common/strings.dart';
import 'package:conectados/presentation/themes/styles.dart';
import 'package:conectados/presentation/widgets/widgets.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key, required this.back});
  final Widget back;
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool bPassword = true;
  bool obscurePassword = true;
  var password1 = TextEditingController();
  var password2 = TextEditingController();

  void callbackTextfield(bool check, int index) {
    setState(() {
      bPassword = check;
    });
  }

  void callbackObscure(bool comprobador) {
    setState(() {
      obscurePassword = comprobador;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ws.appBar(Ss.changePassword, context, widget.back),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Ws.mandatoryText(Ss.newPassword, bPassword),
            Ws.smallSeparation,
            Ws.textFieldPassword(password1, bPassword, "", callbackTextfield, 0,
                obscurePassword, callbackObscure),
            Ws.separation,
            Ws.mandatoryText(Ss.confirmPass, bPassword),
            Ws.smallSeparation,
            Ws.textFieldPassword(password2, bPassword, "", callbackTextfield, 0,
                obscurePassword, callbackObscure),
            Ws.separation,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: WStyles.elevatedButtonPC,
                  onPressed: () async {
                    if (password1.text.isEmpty || password2.text.isEmpty) {
                      setState(() {
                        bPassword = false;
                      });
                      Ws.errorMessage(Ss.fill, context);
                      return;
                    }
                    if (password1.text != password2.text) {
                      setState(() {
                        bPassword = false;
                      });
                      Ws.errorMessage(Ss.differentPass, context);
                      return;
                    }
                    if (password1.text == password2.text && bPassword) {
                      if (password1.text.length > 7) {
                        Either either =
                            await SG.auth.changePassword(password1.text);
                        either.fold((left) {
                          Ws.errorMessage(left, context);
                        }, (right) {
                          Ws.popUpReturn(
                              Ss.passwordChangeSuccessful,
                              Ss.loginNewPassword,
                              Ss.returnHomePage,
                              context,
                              widget.back);
                        });
                      } else {
                        Ws.errorMessage(Ss.lengthPass, context);
                      }
                    }
                  },
                  child: Text(
                    Ss.changePassword,
                    style: TStyles.boldWhite,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
