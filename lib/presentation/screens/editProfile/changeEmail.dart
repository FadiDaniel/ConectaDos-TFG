import 'package:conectados/common/singleton.dart';
import 'package:conectados/common/strings.dart';
import 'package:conectados/controller/functions.dart';
import 'package:conectados/presentation/themes/styles.dart';
import 'package:conectados/presentation/widgets/widgets.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({super.key, required this.back});
  final Widget back;

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  bool bEmail = true;
  var email = TextEditingController();

  void callbackTextfield(bool check, int index) {
    setState(() {
      bEmail = check;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ws.appBar(Ss.changeEmail, context, widget.back),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Ws.mandatoryText(Ss.newEmail, bEmail),
            Ws.smallSeparation,
            Ws.textFieldCheck(email, "", bEmail, callbackTextfield, 0),
            Ws.separation,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: WStyles.elevatedButtonPC,
                  onPressed: () async {
                    if (email.text.isEmpty) {
                      setState(() {
                        bEmail = false;
                      });
                      Ws.errorMessage(Ss.fill, context);
                      return;
                    }
                    if (!Functions.checkEmail(email.text.trim())) {
                      setState(() {
                        bEmail = false;
                      });
                      Ws.errorMessage(Ss.errorEmail, context);
                      return;
                    }
                    if (bEmail) {
                      Either either =
                          await SG.auth.changeEmail(email.text.trim());
                      either.fold((left) {
                        Ws.errorMessage(left, context);
                      }, (right) {
                        Ws.popUpReturn(
                            Ss.emailSentConfirm,
                            Ss.verificationEmailSent,
                            Ss.returnHomePage,
                            context,
                            widget.back);
                      });
                    }
                  },
                  child: Text(
                    Ss.changeEmail,
                    style: TStyles.boldWhite,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
