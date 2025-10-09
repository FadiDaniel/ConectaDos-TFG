import 'package:conectados/common/singleton.dart';
import 'package:conectados/common/strings.dart';
import 'package:conectados/model/position.dart';
import 'package:conectados/presentation/screens/company/homepage_company.dart';
import 'package:conectados/presentation/screens/student/homepage_student.dart';
import 'package:conectados/presentation/screens/tutor/homepageTutor.dart';
import 'package:conectados/presentation/themes/styles.dart';
import 'package:conectados/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class DiscardedPositionsTutor extends StatefulWidget {
  const DiscardedPositionsTutor({super.key, required this.discardedPositions});
  final List<Position> discardedPositions;

  @override
  State<DiscardedPositionsTutor> createState() =>
      _DiscardedPositionsTutorState();
}

class _DiscardedPositionsTutorState extends State<DiscardedPositionsTutor> {
  void removeDiscarded(Position position) async {
    setState(() {
      widget.discardedPositions.remove(position);
      SG.tutor!.discarded!.remove(position.id);
      if (!SG.positionsStudent!.contains(position)) {
        SG.positionsStudent!.add(position);
      }
    });
    await SG.firestore.removeDiscardedPositionTutor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Ws.appBar(Ss.discarded, context, HomepageTutor()),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Builder(
          builder: (context) {
            if (widget.discardedPositions.isNotEmpty) {
              return ListView.separated(
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.all(0),
                      color: Colors.red.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Ws.positionInfo(widget.discardedPositions[index]),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    overlayColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.red.shade300),
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                onPressed: () async {
                                  removeDiscarded(
                                      widget.discardedPositions[index]);
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
                  itemCount: widget.discardedPositions.length);
            } else {
              return Container(
                margin: EdgeInsets.only(top: 30),
                child: Text(
                  "Todavía no has descartado ninguna posición",
                  style: TStyles.normalBlack,
                  textAlign: TextAlign.center,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
