import 'package:conectados/common/singleton.dart';
import 'package:conectados/common/strings.dart';
import 'package:conectados/presentation/screens/tutor/homepageTutor.dart';
import 'package:conectados/presentation/themes/styles.dart';
import 'package:conectados/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class Generatecode extends StatefulWidget {
  const Generatecode({super.key});

  @override
  State<Generatecode> createState() => _GeneratecodeState();
}

class _GeneratecodeState extends State<Generatecode> {
  bool bCode = true;
  TextEditingController code = TextEditingController();

  void callbackTextfield(bool check, int index) {
    setState(() {
      bCode = check;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ws.appBar(Ss.createNewCode, context, HomepageTutor()),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Ws.mandatoryText(Ss.tutorCodeIntroduce, bCode),
            Ws.smallSeparation,
            Ws.textFieldCheck(code, "", bCode, callbackTextfield, 3),
            Ws.bigSeparation,
            //finish button
            Center(
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    //control of textfields name and surname
                    if (code.text.isEmpty) {
                      setState(() {
                        bCode = false;
                      });
                      Ws.errorMessage(Ss.fill, context);
                      return;
                    }
                    if (await SG.firestore.isTutorCodeTaken(code.text)) {
                      if (context.mounted) {
                        Ws.errorMessage(Ss.takenCode, context);
                      }
                      setState(() {
                        bCode = false;
                      });
                      return;
                    }
                    if (await SG.firestore.generateTutorCode(
                          code.text,
                          SG.tutor!.city!,
                          SG.tutor!.highSchool!,
                          SG.tutor!.fp!,
                        ) &&
                        context.mounted) {
                      SG.tutor!.code = code.text;
                      Ws.popUpReturn(Ss.newCodeSuccessful, Ss.codeToStudent,
                          Ss.returnHomePage, context, HomepageTutor());
                    } else {
                      Ws.errorMessage(Ss.errorCode, context);
                    }
                  },
                  style: WStyles.elevatedButtonPC,
                  child: Text(
                    Ss.confirm,
                    style: TStyles.boldWhite,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
